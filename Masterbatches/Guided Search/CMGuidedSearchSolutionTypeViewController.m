//
//  CMGuidedSearchSolutionTypeQuestionViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchSolutionTypeViewController.h"
#import "CMGuidedSearchColorViewController.h"
#import "CMGuidedSearchAdditiveFunctionalityViewController.h"

@interface CMGuidedSearchSolutionTypeViewController ()

@property (nonatomic, retain) Class nextQuestionViewControllerClass;

@end

@implementation CMGuidedSearchSolutionTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    self.title = NSLocalizedString(@"GuidedSearch", "");
    return self;
}

+ (NSString*)questionMenuTitle
{
    return nil; // hide from question menu
}

+ (Class)defaultNextQuestionViewControllerClass
{
    return nil;
}

- (IBAction)tappedColor:(id)sender
{
    self.nextQuestionViewControllerClass = [CMGuidedSearchColorViewController class];
    [self.questionViewControllerDelegate questionViewControllerDidChangeNextQuestion:self];
    [self.questionViewControllerDelegate questionViewControllerDidCompleteQuestion:self];
}

- (IBAction)tappedAdditive:(id)sender
{
    self.nextQuestionViewControllerClass = [CMGuidedSearchAdditiveFunctionalityViewController class];
    [self.questionViewControllerDelegate questionViewControllerDidChangeNextQuestion:self];
    [self.questionViewControllerDelegate questionViewControllerDidCompleteQuestion:self];
}

@end
