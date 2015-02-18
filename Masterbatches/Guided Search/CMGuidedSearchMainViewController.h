//
//  CMGuidedSearchMainViewController.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMGuidedSearchSolutionTypeViewController.h"
#import "CMProductSpecification.h"
#import "CMGuidedSearchStepView.h"

@interface CMGuidedSearchMainViewController : UIViewController <CMGuidedSearchQuestionViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *questionViewControllerContainerView;
@property (nonatomic, weak) IBOutlet UILabel *questionViewControllerTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet CMGuidedSearchStepView * stepView;

@property (nonatomic, strong) CMProductSpecification *productSpecification;

@end
