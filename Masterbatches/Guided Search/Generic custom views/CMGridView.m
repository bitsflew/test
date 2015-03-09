//
//  CMGuidedSearchGridSelectionView.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGridView.h"
#import "ClariantColors.h"

static NSString *CMGuidedSearchGridSelectionItemRoundedCellIdentifier = @"CMGuidedSearchGridSelectionItemRoundedCell";

@interface CMGuidedSearchGridCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIView *fillView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleCenterYConstraint;
@property (nonatomic, weak) id<CMGridItem> lastAppliedItem;


@end

@implementation CMGuidedSearchGridCollectionViewCell

- (void)awakeFromNib
{
    self.fillView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.fillView.layer.borderWidth = 1.f;
    self.fillView.layer.masksToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.fillView.layer.cornerRadius = CGRectGetHeight(self.fillView.frame)/2.f;
}

- (void)applyItem:(id<CMGridItem>)item
{
    self.lastAppliedItem = item;

    self.titleLabel.text = [item title];

    if ([item respondsToSelector:@selector(centerTitle)] && [item centerTitle]) {
        self.titleCenterYConstraint.constant = 0.f;
    }
    
    [self updateAlpha];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    [self updateAlpha];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    [self updateAlpha];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateAlpha];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateAlpha];
}

- (void)updateAlpha
{
    UIControlState controlState = UIControlStateNormal;
    if (self.isHighlighted) {
        controlState = controlState | UIControlStateHighlighted;
    }
    if (self.isSelected) {
        controlState = controlState | UIControlStateSelected;
    }

    if ([self.lastAppliedItem respondsToSelector:@selector(borderColorForState:)]) {
        self.fillView.layer.borderColor = [self.lastAppliedItem borderColorForState:controlState].CGColor;
    } else {
        self.fillView.layer.borderColor = (self.isSelected ? [ClariantColors blueColor] : [ClariantColors silver20Color]).CGColor;
    }

    self.fillView.layer.borderWidth = self.isSelected ? 2.f : 1.f;
    
    self.alpha = self.isHighlighted ? 0.5f : 1.f;
    
    if (![self.lastAppliedItem respondsToSelector:@selector(titleColorForState:)]) {
        self.titleLabel.textColor = self.isSelected ? [UIColor colorWithWhite:0.1f alpha:1.f] : [UIColor colorWithWhite:0.3f alpha:1.f];
    }
    
    if ([self.lastAppliedItem respondsToSelector:@selector(fillColorForState:)]) {
        self.fillView.layer.backgroundColor = [[self.lastAppliedItem fillColorForState:controlState] CGColor];
    }

    if ([self.lastAppliedItem respondsToSelector:@selector(titleColorForState:)]) {
        self.titleLabel.textColor = [self.lastAppliedItem titleColorForState:controlState];
    }
}

@end

@interface CMGuidedSearchGridCollectionViewLayout : UICollectionViewFlowLayout

@end

@implementation CMGuidedSearchGridCollectionViewLayout

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    self.itemSize = CGSizeMake(150.f, 150.f);
    return self;
}

@end

@interface CMGridView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CMGridView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, self.contentSize.height);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    return [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame collectionViewLayout:[CMGuidedSearchGridCollectionViewLayout new]])) {
        return nil;
    }
    return [self commonInit];
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (!(self = [super initWithFrame:frame collectionViewLayout:layout])) {
        return nil;
    }
    return [self commonInit];
}

- (id)commonInit
{
    self.collectionViewLayout = [CMGuidedSearchGridCollectionViewLayout new];
    
    self.dataSource = self;
    self.delegate = self;
    self.clipsToBounds = YES;
    
    [self registerNib:[UINib nibWithNibName:CMGuidedSearchGridSelectionItemRoundedCellIdentifier
                                     bundle:[NSBundle mainBundle]]
     forCellWithReuseIdentifier:CMGuidedSearchGridSelectionItemRoundedCellIdentifier];

    return self;
}

#pragma mark -

- (void)setItems:(NSArray *)items
{
    @synchronized(self) {
        _items = items;
    }
    [self reloadData];
}

- (NSArray*)selectedItems
{
    if (self.items.count == 0) {
        return @[];
    }

    NSArray *indexPathsForSelectedItems = [self indexPathsForSelectedItems];
    if (!indexPathsForSelectedItems) {
        return @[];
    }
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet new];
    
    for (NSIndexPath *indexPath in indexPathsForSelectedItems) {
        [indexes addIndex:indexPath.row];
    }

    return [self.items objectsAtIndexes:indexes];
}

- (void)selectItems:(NSArray *)items animated:(BOOL)animated
{
    NSArray *indexPathsForSelectedItems = [self indexPathsForSelectedItems];
    if (indexPathsForSelectedItems) {
        for (NSIndexPath *indexPath in indexPathsForSelectedItems) {
            [self deselectItemAtIndexPath:indexPath animated:NO];
        }
    }
    
    for (id item in items) {
        NSUInteger index = [self.items indexOfObject:item];
        if (index == NSNotFound) {
            continue;
        }
        [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                           animated:animated
                     scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMGuidedSearchGridCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:CMGuidedSearchGridSelectionItemRoundedCellIdentifier
                                                forIndexPath:indexPath];

    id<CMGridItem> item = self.items[indexPath.row];

    [cell applyItem:item];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<CMGridItem> item = self.items[indexPath.row];
    [self.selectionDelegate gridView:self didSelectItem:item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<CMGridItem> item = self.items[indexPath.row];
    [self.selectionDelegate gridView:self didDeselectItem:item];
}

@end
