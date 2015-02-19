//
//  CMGuidedSearchAdditiveFunctionalityViewController.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchStepViewController.h"
#import "CMGuidedSearchGrid.h"

@interface CMGuidedSearchAdditiveFunctionalityViewController : UIViewController <CMGuidedSearchStepViewController, CMGuidedSearchGridSelectionDelegate>

@property (nonatomic, weak) IBOutlet CMGuidedSearchGrid *gridSelectionView;

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@end
