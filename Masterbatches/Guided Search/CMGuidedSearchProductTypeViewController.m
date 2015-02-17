//
//  CMGuidedSearchRegulatoryIndustryViewController.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchProductTypeViewController.h"
#import "CMGuidedSearchTemperatureThicknessViewController.h"

@interface CMGuidedSearchProductTypeViewController ()

@end

@implementation CMGuidedSearchProductTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    self.title = NSLocalizedString(@"ProductType", "");
    return self;
}

+ (NSString*)questionMenuTitle
{
    return NSLocalizedString(@"ProductType", "");
}

+ (Class)defaultNextQuestionViewControllerClass
{
    return [CMGuidedSearchTemperatureThicknessViewController class];
}

- (Class)nextQuestionViewControllerClass
{
    return nil;
}

@end
