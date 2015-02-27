//
//  CMGuidedSearchRegulatoryIndustryViewController.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchStepViewController.h"
#import "CMGridViewController.h"

@interface CMGuidedSearchProductTypeViewController : CMGridViewController <CMGuidedSearchStepViewController>

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@end
