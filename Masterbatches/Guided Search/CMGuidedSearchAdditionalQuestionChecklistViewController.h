//
//  CMGuidedSearchAdditionalQuestionChecklistViewController.h
//  MB Sales
//
//  Created by Craig on 04/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMGuidedSearchAdditionalQuestionViewController.h"

@interface CMGuidedSearchAdditionalQuestionChecklistViewController : UIViewController <CMGuidedSearchAdditionalQuestionViewController>

// Supported attributes: Items (array of strings), MultiSelect (boolean)
@property (nonatomic, retain) CMGuidedSearchFlowAdditionalQuestion *additionalQuestion;

@end
