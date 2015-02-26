//
//  CMGuidedSearchGridSelectionView.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchGrid.h"

static NSString *CMGuidedSearchGridSelectionItemRoundedCellIdentifier = @"CMGuidedSearchGridSelectionItemRoundedCell";
static NSUInteger CMGuidedSearchGridSelectionItemCellTitleTag = 100;

@interface CMGuidedSearchGridCollectionViewCell : UICollectionViewCell

@end

@implementation CMGuidedSearchGridCollectionViewCell

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
    self.alpha = (self.isHighlighted || self.isSelected) ? 1.f : 0.3f;
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

@interface CMGuidedSearchGrid () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CMGuidedSearchGrid

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
    if (!self.collectionViewLayout) {
        self.collectionViewLayout = [CMGuidedSearchGridCollectionViewLayout new];
    }
    
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
                           animated:NO
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
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:CMGuidedSearchGridSelectionItemRoundedCellIdentifier
                                              forIndexPath:indexPath];

    id<CMGuidedSearchGridItem> item = self.items[indexPath.row];

    ((UILabel*)[cell viewWithTag:CMGuidedSearchGridSelectionItemCellTitleTag]).text = [item title];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<CMGuidedSearchGridItem> item = self.items[indexPath.row];
    [self.selectionDelegate guidedSearchGrid:self didSelectItem:item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<CMGuidedSearchGridItem> item = self.items[indexPath.row];
    [self.selectionDelegate guidedSearchGrid:self didDeselectItem:item];
}


@end
