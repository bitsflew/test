//
//  CMGuidedSearchGridViewController.m
//  MB Sales
//
//  Created by Craig on 25/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGridViewController.h"

@interface CMGridViewController ()

@end

@implementation CMGridViewController

- (void)loadView
{
    self.view = [[CMGridView alloc] initWithFrame:CGRectZero];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.grid = (CMGridView*)self.view;
    self.grid.selectionDelegate = self;
    self.grid.backgroundColor = [UIColor clearColor];
}

#pragma mark -

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item
{
    
}

- (void)gridView:(CMGridView*)gridView didDeselectItem:(id<CMGridItem>)item
{
    
}

@end
