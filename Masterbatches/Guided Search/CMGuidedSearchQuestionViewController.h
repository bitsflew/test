//
//  CMGuidedSearchQuestionViewController.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMProductSpecification.h"

@protocol CMGuidedSearchQuestionViewController <NSObject>

@optional
- (void)setProductSpecification:(CMProductSpecification*)productSpecification;

@end