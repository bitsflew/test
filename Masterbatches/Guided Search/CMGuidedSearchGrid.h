//
//  CMGuidedSearchGridSelectionView.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMGuidedSearchGridItem <NSObject>
@optional
- (NSString*)title;
@end

@class CMGuidedSearchGrid;

@protocol CMGuidedSearchGridLayoutDelegate <NSObject>

- (void)guidedSearchGridDidLayoutItems:(CMGuidedSearchGrid*)guidedSearchGrid;

@end

@protocol CMGuidedSearchGridSelectionDelegate <NSObject>

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didSelectItem:(id<CMGuidedSearchGridItem>)item;
- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didDeselectItem:(id<CMGuidedSearchGridItem>)item;

@end

@interface CMGuidedSearchGrid : UICollectionView

@property (nonatomic, retain) NSArray *items; // <CMGuidedSearchGridItem>
@property (nonatomic, readonly) NSArray *selectedItems;

@property (nonatomic, weak) IBOutlet id<CMGuidedSearchGridSelectionDelegate> selectionDelegate;

- (void)selectItems:(NSArray *)items animated:(BOOL)animated;
@end
