//
//  CMGuidedSearchAdditionalQuestionGridViewController.h
//  MB Sales
//
//  Created by Craig on 03/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGridViewController.h"
#import "CMGuidedSearchAdditionalQuestionViewController.h"

@interface CMGuidedSearchAdditionalQuestionGridViewController : CMGridViewController <CMGuidedSearchAdditionalQuestionViewController>

// Supported attributes: Items (array of strings)
@property (nonatomic, retain) CMGuidedSearchFlowAdditionalQuestion *additionalQuestion;

@end
