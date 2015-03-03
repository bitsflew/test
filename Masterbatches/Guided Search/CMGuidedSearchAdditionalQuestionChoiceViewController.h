//
//  CMGuidedSearchAdditionalQuestionChoiceViewController.h
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionViewController.h"

@interface CMGuidedSearchAdditionalQuestionChoiceViewController : UITableViewController <CMGuidedSearchAdditionalQuestionViewController>

// Supported attributes: Choices (array of strings)
@property (nonatomic, retain) CMGuidedSearchFlowAdditionalQuestion* additionalQuestion;

@end
