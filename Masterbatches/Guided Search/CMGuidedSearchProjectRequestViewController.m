//
//  CMGuidedSearchProjectRequestViewController.m
//  MB Sales
//
//  Created by Craig on 24/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchProjectRequestViewController.h"

@interface CMGuidedSearchProjectRequestViewController ()

@end

@implementation CMGuidedSearchProjectRequestViewController

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    self.title = NSLocalizedString(@"Overview", nil);
    return self;
}

- (IBAction)tappedCancelProjectRequest:(id)sender
{
    [self.delegate projectRequestViewControllerDismissedCancellingProjectRequest:self];
}

@end
