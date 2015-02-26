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
    [self.temperatureSlider addUnitWithName:@"Celsius"
                                 multiplier:1.f
                                   constant:0.f];

    [self.temperatureSlider addUnitWithName:@"Farenheit"
                                 multiplier:(9.f/5.f)
                                   constant:32.f];
    
    [self.thicknessSlider addUnitWithName:@"Metric (cm)"
                               multiplier:1.f
                                 constant:0.f];
    
    [self.thicknessSlider addUnitWithName:@"Imperial (in)"
                               multiplier:0.3937f
                                 constant:0.f];
}

@end
