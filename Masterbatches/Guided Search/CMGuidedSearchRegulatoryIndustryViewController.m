//
//  CMGuidedSearchRegulatoryIndustryViewController.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchRegulatoryIndustryViewController.h"

@interface CMGuidedSearchRegulatoryIndustryViewController ()

@end

@implementation CMGuidedSearchRegulatoryIndustryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    self.title = NSLocalizedString(@"RegulatoryIndustry", "");
    return self;
}

+ (NSString*)questionMenuTitle
{
    return NSLocalizedString(@"RegulatoryIndustry", "");
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
