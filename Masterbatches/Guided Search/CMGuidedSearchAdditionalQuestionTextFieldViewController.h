//
//  CMGuidedSearchAdditionalQuestionInputFieldViewController.h
//  MB Sales
//
//  Created by Craig on 23/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionViewController.h"

@interface CMGuidedSearchAdditionalQuestionTextFieldViewController : UIViewController <CMGuidedSearchAdditionalQuestionViewController>

// Supported attributes: Numeric (optional, boolean – whether to show numeric keypad)

@property (nonatomic, retain) CMGuidedSearchFlowAdditionalQuestion* additionalQuestion;

@end
