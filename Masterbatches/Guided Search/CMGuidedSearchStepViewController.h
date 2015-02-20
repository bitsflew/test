//
//  CMGuidedSearchStepViewController.h
//  Masterbatches
//
//  Created by Craig on 19/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchFlow.h"

@protocol CMGuidedSearchStepViewController;

@protocol CMGuidedSearchStepViewControllerDelegate <NSObject>

- (void)stepViewControllerDidCompleteStep:(id<CMGuidedSearchStepViewController>)stepViewController;
- (void)stepViewControllerDidChangeProductSpecification:(id<CMGuidedSearchStepViewController>)stepViewController;

- (CMGuidedSearchFlow*)flow;

@end

@protocol CMGuidedSearchStepViewController <NSObject>

- (void)setStepDelegate:(id<CMGuidedSearchStepViewControllerDelegate>)stepDelegate;

- (CMGuidedSearchFlowStep*)step;
- (void)setStep:(CMGuidedSearchFlowStep*)step;

@optional
- (BOOL)completeStepWithValidationError:(NSString**)errorDescription;

@end