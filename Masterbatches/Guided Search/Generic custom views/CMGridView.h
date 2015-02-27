//
//  CMGridView.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMGridItem <NSObject>
@optional
- (NSString*)title;
@end

@class CMGridView;

@protocol CMGridViewSelectionDelegate <NSObject>

//- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didSelectItem:(id<CMGuidedSearchGridItem>)item
//- (void)guidedSearchGrid:(CMGridView*)guidedSearchGrid didSelectItem:(id<CMGridItem>)item;

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item;
- (void)gridView:(CMGridView*)gridView didDeselectItem:(id<CMGridItem>)item;

@end

@interface CMGridView : UICollectionView

@property (nonatomic, retain) NSArray *items; // <CMGuidedSearchGridItem>
@property (nonatomic, readonly) NSArray *selectedItems;

@property (nonatomic, weak) IBOutlet id<CMGridViewSelectionDelegate> selectionDelegate;

- (void)selectItems:(NSArray *)items animated:(BOOL)animated;
@end
