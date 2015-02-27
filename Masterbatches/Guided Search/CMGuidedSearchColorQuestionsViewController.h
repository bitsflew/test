//
//  CMGuidedSearchColorQuestionsViewController.h
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchStepViewController.h"
#import "CMChecklistView.h"

@interface CMGuidedSearchColorQuestionsViewController : UIViewController <CMGuidedSearchStepViewController>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet CMChecklistView *opacityChecklist;
@property (nonatomic, weak) IBOutlet CMChecklistView *partFinishChecklist;
@property (nonatomic, weak) IBOutlet CMChecklistView *exposureChecklist;
@property (nonatomic, weak) IBOutlet CMChecklistView *lightSourceChecklist;
@property (nonatomic, weak) IBOutlet CMChecklistView *physicalFormChecklist;
@property (nonatomic, weak) IBOutlet CMChecklistView *matchAccuracyColorCodingChecklist;
@property (nonatomic, weak) IBOutlet CMChecklistView *matchAccuracyChecklist;
@property (nonatomic, weak) IBOutlet UITextField *matchAccuracyColorCodingTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;
@property (nonatomic, retain) CMGuidedSearchFlowStep *step;

@end
