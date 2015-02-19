//
//  CMGuidedSearchAdditiveFunctionalityViewController.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchStepViewController.h"
#import "CMGuidedSearchGridSelectionView.h"

@interface CMGuidedSearchAdditiveFunctionalityViewController : UIViewController <CMGuidedSearchStepViewController>

@property (nonatomic, weak) IBOutlet CMGuidedSearchGridSelectionView *gridSelectionView;

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@end
