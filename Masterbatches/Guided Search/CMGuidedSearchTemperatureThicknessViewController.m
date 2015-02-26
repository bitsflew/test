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

    self.temperatureSlider.maximumValue = 400.f;
    self.temperatureSlider.minimumValue = 150.f;
    self.temperatureSlider.value = self.step.productSpecification.temperatureInCentrigrade;

    [self.temperatureSlider addUnitWithName:@"Celsius"
                               formatString:@"%.2f C"
                                 multiplier:1.f
                                   constant:0.f];

    [self.temperatureSlider addUnitWithName:@"Farenheit"
                               formatString:@"%.2f F"
                                 multiplier:(9.f/5.f)
                                   constant:32.f];

    self.thicknessSlider.maximumValue = 30.f;
    self.thicknessSlider.minimumValue = 0.1f;
    self.thicknessSlider.value = self.step.productSpecification.thicknessInMillimeters;

    [self.thicknessSlider addUnitWithName:@"Metric"
                               formatString:@"%.2f mm"
                                 multiplier:1.f
                                   constant:0.f];
    
    [self.thicknessSlider addUnitWithName:@"Imperial"
                             formatString:@"%.2f in"
                               multiplier:0.03937f
                                 constant:0.f];
}

- (IBAction)sliderValueChanged:(id)sender
{
    if (sender == self.thicknessSlider) {
        self.step.productSpecification.thicknessInMillimeters = self.thicknessSlider.value;
    } else
        if (sender == self.temperatureSlider) {
            self.step.productSpecification.temperatureInCentrigrade = self.temperatureSlider.value;
        }

    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

@end
