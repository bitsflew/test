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
      Key (string, required)
      Title (string, required)
      Prompt (string, optional)
      TextFieldHidden (boolean, optional)

    MultiSelect (boolean, optional)
 */

@property (nonatomic, retain) CMGuidedSearchFlowAdditionalQuestion *additionalQuestion;

@end
