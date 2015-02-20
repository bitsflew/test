//
//  CMGuidedSearchAdditionalQuestionViewController.h
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMGuidedSearchFlow.h"

@protocol CMGuidedSearchAdditionalQuestionViewController <NSObject>

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion*)additionalQuestion;

@end