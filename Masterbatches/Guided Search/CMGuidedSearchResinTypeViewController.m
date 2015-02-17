//
//  CMGuidedSearchResinTypeViewController.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchResinTypeViewController.h"
#import "CMGuidedSearchRegulatoryIndustryViewController.h"

@interface CMGuidedSearchResinTypeViewController ()

@end

@implementation CMGuidedSearchResinTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    self.title = NSLocalizedString(@"ResinType", "");
    return self;
}

+ (NSString*)questionMenuTitle
{
    return NSLocalizedString(@"ResinType", "");
}

+ (Class)defaultNextQuestionViewControllerClass
{
    return [CMGuidedSearchRegulatoryIndustryViewController class];
}

- (Class)nextQuestionViewControllerClass
{
    return nil;
}


@end
