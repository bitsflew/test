//
//  CMGuidedSearchGridViewController.m
//  MB Sales
//
//  Created by Craig on 25/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchGridViewController.h"

@interface CMGuidedSearchGridViewController ()

@end

@implementation CMGuidedSearchGridViewController

- (void)loadView
{
    self.view = [[CMGuidedSearchGrid alloc] initWithFrame:CGRectZero];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.grid = (CMGuidedSearchGrid*)self.view;
    self.grid.selectionDelegate = self;
    self.grid.backgroundColor = [UIColor clearColor];
}

#pragma mark -

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didSelectItem:(id<CMGuidedSearchGridItem>)item
{
    
}

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didDeselectItem:(id<CMGuidedSearchGridItem>)item
{
    
}

@end
