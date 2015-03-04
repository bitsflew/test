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
- (CMGuidedSearchFlow*)flowForStepViewController:(id<CMGuidedSearchStepViewController>)stepViewController;
- (UIEdgeInsets)edgeInsetsForStepViewController:(id<CMGuidedSearchStepViewController>)stepViewController;

@end

@protocol CMGuidedSearchStepViewController <NSObject>

@optional
+ (BOOL)applicableToFlow:(CMGuidedSearchFlow*)flow;
- (BOOL)completeStepWithValidationError:(NSString**)errorDescription;

@required
- (void)setStepDelegate:(id<CMGuidedSearchStepViewControllerDelegate>)stepDelegate;

- (CMGuidedSearchFlowStep*)step;
- (void)setStep:(CMGuidedSearchFlowStep*)step;

@end