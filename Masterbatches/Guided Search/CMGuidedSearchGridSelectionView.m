//
//  CMGuidedSearchGridSelectionView.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchGridSelectionView.h"

static NSString *CMGuidedSearchGridSelectionItemRoundedCellIdentifier = @"CMGuidedSearchGridSelectionItemRoundedCell";
static NSUInteger CMGuidedSearchGridSelectionItemCellTitleTag = 100;

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

@interface CMGuidedSearchGridSelectionView () <UICollectionViewDataSource>

@end

@implementation CMGuidedSearchGridSelectionView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    return [self commonInit];
}

- (id)commonInit
{
    self.collectionViewLayout = [CMGuidedSearchGridCollectionViewLayout new];
    
    self.dataSource = self;
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

    id<CMGuidedSearchGridSelectionItem> item = self.items[indexPath.row];

    ((UILabel*)[cell viewWithTag:CMGuidedSearchGridSelectionItemCellTitleTag]).text = [item title];
    
    return cell;
}

@end
