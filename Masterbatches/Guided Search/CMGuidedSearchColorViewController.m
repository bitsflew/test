//
//  CMGuidedSearchColorViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchColorViewController.h"

#import "CMGuidedSearchSolutionTypeViewController.h"

@interface CMGuidedSearchColorViewController ()

@end

@implementation CMGuidedSearchColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    self.title = NSLocalizedString(@"Color", "");
    return self;
}

+ (NSString*)questionMenuTitle
{
    return NSLocalizedString(@"Color", "");
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
