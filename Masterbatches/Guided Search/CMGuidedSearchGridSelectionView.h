//
//  CMGuidedSearchGridSelectionView.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMGuidedSearchGridSelectionItem <NSObject>
@optional
- (NSString*)title;
@end

@interface CMGuidedSearchGridSelectionView : UICollectionView

@property (nonatomic, retain) NSArray *items; // <CMGuidedSearchGridSelectionItem>
@property (nonatomic, readonly) NSArray *selectedItems;

- (void)selectItems:(NSArray *)items animated:(BOOL)animated;
@end
