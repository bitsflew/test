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
#import "CMProjectRequest.h"

@interface CMGuidedSearchFlowViewController : UIViewController <CMGuidedSearchStepViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *stepContainerView;
@property (nonatomic, weak) IBOutlet UIView *stepOverlayView;
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet CMGuidedSearchFlowProgressView *flowProgressView;

// The overview pulls down from the top and displays information about either search results or the ongoing project request
@property (nonatomic, weak) IBOutlet UIButton *overviewToggleButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *overviewToggleButtonTopConstraint;
@property (nonatomic, weak) IBOutlet UIImageView *overviewArrowView;
@property (nonatomic, weak) IBOutlet UIButton *closeOverviewButton;
@property (nonatomic, weak) IBOutlet UIView *overviewContainerView;
@property (nonatomic, strong) UIViewController *overviewController;

@property (nonatomic, strong) CMGuidedSearchFlow *flow; // builds up product specification; can contain project request

@end
