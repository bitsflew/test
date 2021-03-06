//
//  CMGuidedSearchResinTypeViewController.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGridViewController.h"
#import "CMGuidedSearchStepViewController.h"

@interface CMGuidedSearchResinTypeViewController : CMGridViewController <CMGuidedSearchStepViewController>

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@end
