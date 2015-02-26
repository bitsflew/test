//
//  CMGuidedSearchTemperatureThicknessViewController.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchTemperatureThicknessViewController.h"

@interface CMGuidedSearchTemperatureThicknessViewController ()

@end

@implementation CMGuidedSearchTemperatureThicknessViewController

- (void)viewDidLoad
{
    self.topConstraint.constant = [self.stepDelegate edgeInsetsForStepViewController:self].top;

    [self.temperatureSlider addUnitWithName:@"Celsius"
                               formatString:@"%.2f C"
                                 multiplier:1.f
                                   constant:0.f];
    
    [self.temperatureSlider addUnitWithName:@"Farenheit"
                               formatString:@"%.2f F"
                                 multiplier:(9.f/5.f)
                                   constant:32.f];
    
    [self.thicknessSlider addUnitWithName:@"Metric"
                               formatString:@"%.2f cm"
                                 multiplier:1.f
                                   constant:0.f];
    
    [self.thicknessSlider addUnitWithName:@"Imperial"
                             formatString:@"%.2f in"
                               multiplier:0.3937f
                                 constant:0.f];
}

@end
