//
//  CMGuidedSearchAdditiveFunctionalityViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditiveFunctionalityViewController.h"

#import "CMGuidedSearchColorViewController.h"

@interface CMGuidedSearchAdditiveFunctionalityViewController ()

@end

@implementation CMGuidedSearchAdditiveFunctionalityViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    self.title = NSLocalizedString(@"AdditiveFunctionality", "");
    return self;
}

+ (NSString*)questionMenuTitle
{
    return NSLocalizedString(@"AdditiveFunctionality", "");
}

+ (Class)defaultNextQuestionViewControllerClass
{
    return [CMGuidedSearchColorViewController class];
}

- (Class)nextQuestionViewControllerClass
{
    return nil;
}

@end
