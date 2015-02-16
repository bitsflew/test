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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
