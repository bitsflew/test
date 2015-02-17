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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    self.title = NSLocalizedString(@"TemperatureThickness", "");
    return self;
}

+ (NSString*)questionMenuTitle
{
    return NSLocalizedString(@"TemperatureThickness", "");
}

+ (Class)defaultNextQuestionViewControllerClass
{
    return nil;
}

- (Class)nextQuestionViewControllerClass
{
    return nil;
}


@end
