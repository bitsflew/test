//
//  CMGuidedSearchColorFlowViewController.m
//  MB Sales
//
//  Created by Craig on 23/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchColorFlowViewController.h"

@interface CMGuidedSearchColorFlowViewController ()

@end

@implementation CMGuidedSearchColorFlowViewController

- (id)init
{
    if (!(self = [super initWithNibName:NSStringFromClass([self superclass]) bundle:[NSBundle mainBundle]])) {
        return nil;
    }
    [self setFlow:[CMGuidedSearchFlow flowNamed:@"ColorGuidedSearchFlow"]];
    return self;
}

@end
