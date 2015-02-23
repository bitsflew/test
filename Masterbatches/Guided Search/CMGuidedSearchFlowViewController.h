//
//  CMGuidedSearchMainViewController.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMGuidedSearchStepViewController.h"
#import "CMProductSpecification.h"
#import "CMGuidedSearchFlowProgressView.h"
#import "CMGuidedSearchFlow.h"
#import "CMGuidedSearchResultController.h"

@interface CMGuidedSearchFlowViewController : UIViewController <CMGuidedSearchStepViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *stepContainerView;
@property (nonatomic, weak) IBOutlet UIView *stepOverlayView;
@property (nonatomic, weak) IBOutlet UIView *resultContainerView;
@property (nonatomic, weak) IBOutlet UILabel *questionViewControllerTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UIButton *modeToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *closeSearchModeButton;
@property (nonatomic, weak) IBOutlet CMGuidedSearchFlowProgressView *flowProgressView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (nonatomic, strong) CMGuidedSearchFlow *flow;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *modeToggleButtonTopConstraint;

@property (nonatomic, strong) CMGuidedSearchResultController *resultController;

@end
