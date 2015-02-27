//
//  CMGuidedSearchApplicationProcessViewController.h
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGridViewController.h"
#import "CMGuidedSearchStepViewController.h"

@interface CMGuidedSearchApplicationProcessViewController : CMGridViewController <CMGuidedSearchStepViewController>

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@end
