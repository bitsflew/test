//
//  CMGuidedSearchProductRegulatoryIndustryViewController.h
//  MB Sales
//
//  Created by Craig on 26/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMGuidedSearchStepViewController.h"
#import "CMGridView.h"

@interface CMGuidedSearchProductRegulatoryIndustryViewController : UIViewController <CMGuidedSearchStepViewController, CMGridViewSelectionDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet CMGridView *productGrid;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *productGridHeightConstraint;

@property (nonatomic, weak) IBOutlet CMGridView *industryGrid;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *industryGridHeightConstraint;

@property (nonatomic, weak) IBOutlet CMGridView *regulatoryGrid;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *regulatoryGridHeightConstraint;

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@end
