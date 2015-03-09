//
//  CMGuidedSearchAdditionalQuestionTextFieldChecklistViewController.h
//  MB Sales
//
//  Created by Craig on 04/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMGuidedSearchAdditionalQuestionViewController.h"

@interface CMGuidedSearchAdditionalQuestionTextFieldChecklistViewController : UIViewController <CMGuidedSearchAdditionalQuestionViewController>

/* 
    Supported attributes:

    Items (array of dictionaries, required), where each item has:
      Title (string, required)
      Key (string, optional – defaults to Title)
      TextFieldPrompt (string, optional)
      TextFieldHidden (boolean, optional – when YES, a boolean for checked/unchecked is written to Key instead of a string)
      TextFieldNumeric (boolean, optional) 

    MultiSelect (boolean, optional)
 */

@property (nonatomic, retain) CMGuidedSearchFlowAdditionalQuestion *additionalQuestion;

@end
