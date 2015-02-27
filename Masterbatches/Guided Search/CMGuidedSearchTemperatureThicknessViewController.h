//
//  CMGuidedSearchTemperatureThicknessViewController.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchStepViewController.h"
#import "CMUnitSlider.h"

@interface CMGuidedSearchTemperatureThicknessViewController : UIViewController <CMGuidedSearchStepViewController>

@property (nonatomic, weak) IBOutlet CMUnitSlider *temperatureSlider;
@property (nonatomic, weak) IBOutlet CMUnitSlider *thicknessSlider;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) CMGuidedSearchFlowStep *step;
@property (nonatomic, weak) id<CMGuidedSearchStepViewControllerDelegate> stepDelegate;

@end
