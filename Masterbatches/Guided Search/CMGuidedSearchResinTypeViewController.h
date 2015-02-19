//
//  CMGuidedSearchResinTypeViewController.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchStepViewController.h"
#import "CMGuidedSearchGridSelectionView.h"

@interface CMGuidedSearchResinTypeViewController : UIViewController <CMGuidedSearchStepViewController>

@property (nonatomic, weak) IBOutlet CMGuidedSearchGridSelectionView *gridSelectionView;

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@end
