//
//  CMGuidedSearchStepView.h
//  Masterbatches
//
//  Created by Craig on 18/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSteppedProgressView : UIView

@property (nonatomic) NSUInteger stepCount;
@property (nonatomic) NSUInteger completedCount;

@property (nonatomic) CGFloat contractionFactor;

- (void)setContractionFactor:(CGFloat)contractionFactor animated:(BOOL)animated;

@end
