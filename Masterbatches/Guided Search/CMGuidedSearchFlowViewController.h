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

@interface CMGuidedSearchFlowViewController : UIViewController <CMGuidedSearchStepViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *questionViewControllerContainerView;
@property (nonatomic, weak) IBOutlet UILabel *questionViewControllerTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet CMGuidedSearchFlowProgressView *flowProgressView;

@property (nonatomic, strong) CMGuidedSearchFlow *flow;

@end
