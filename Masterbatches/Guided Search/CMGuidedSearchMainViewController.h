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

@interface CMGuidedSearchMainViewController : UIViewController <CMGuidedSearchQuestionViewControllerDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIView *questionViewControllerContainerView;
@property (nonatomic, weak) IBOutlet UILabel *questionViewControllerTitleLabel;

@property (nonatomic, weak) IBOutlet UITableView *futureQuestionsTableView;

@property (nonatomic, strong) CMProductSpecification *productSpecification;

@end
