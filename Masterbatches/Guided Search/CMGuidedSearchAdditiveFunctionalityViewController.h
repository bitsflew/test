//
//  CMGuidedSearchAdditiveFunctionalityViewController.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchQuestionViewController.h"
#import "CMGuidedSearchGridSelectionView.h"

@interface CMGuidedSearchAdditiveFunctionalityViewController : UIViewController <CMGuidedSearchQuestionViewController>

@property (nonatomic, weak) IBOutlet CMGuidedSearchGridSelectionView *gridSelectionView;

@property (nonatomic, weak) id<CMGuidedSearchQuestionViewControllerDelegate> questionViewControllerDelegate;

@end
