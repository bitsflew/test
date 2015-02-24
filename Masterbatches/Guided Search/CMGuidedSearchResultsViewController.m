//
//  CMGuidedSearchResultsViewController.m
//  MB Sales
//
//  Created by Craig on 24/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchResultsViewController.h"

@interface CMGuidedSearchResultsViewController ()

@end

@implementation CMGuidedSearchResultsViewController

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    self.title = @"Here's what we have for you";
    return self;
}

- (IBAction)tappedCreateProjectRequest:(id)sender
{
    [self.delegate searchResultsViewControllerDismissedWithProjectRequest:self];
}

- (void)setResults:(NSArray *)results
{
    _results = results;
    
}

@end
