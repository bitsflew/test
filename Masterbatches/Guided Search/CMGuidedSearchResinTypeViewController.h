//
//  CMGuidedSearchResinTypeViewController.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchQuestionViewController.h"
#import "CMGuidedSearchGridSelectionView.h"

@interface CMGuidedSearchResinTypeViewController : UIViewController <CMGuidedSearchQuestionViewController>

@property (nonatomic, weak) id<CMGuidedSearchQuestionViewControllerDelegate> questionViewControllerDelegate;

@property (nonatomic, weak) IBOutlet CMGuidedSearchGridSelectionView *gridSelectionView;

@end
