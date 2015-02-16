//
//  CMGuidedSearchSolutionTypeQuestionViewController.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMGuidedSearchQuestionViewController.h"

@interface CMGuidedSearchSolutionTypeViewController : UIViewController <CMGuidedSearchQuestionViewController>

@property (nonatomic, weak) id<CMGuidedSearchQuestionViewControllerDelegate> questionViewControllerDelegate;

@end
