//
//  CMGuidedSearchAdditionalQuestionsViewController.h
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchStepViewController.h"

@interface CMGuidedSearchAdditionalQuestionsViewController : UIViewController <CMGuidedSearchStepViewController>

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@property (nonatomic, weak) IBOutlet UILabel *questionTitleTemplateLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *questionsScrollView;

@end
