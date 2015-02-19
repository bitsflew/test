//
//  CMGuidedSearchMainViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchFlowViewController.h"

static NSString *CMGuidedSearchMainViewControllerCellIdentifier = @"cell";

@interface CMGuidedSearchFlowViewController ()

@property (nonatomic, strong) UIViewController<CMGuidedSearchStepViewController> *stepViewController;

@end

@implementation CMGuidedSearchFlowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }

    [self setFlow:[CMGuidedSearchFlow flowNamed:@"Additive"]];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.flow) {
        [self presentStep:self.flow.firstStep];
    }
}

- (void)setFlow:(CMGuidedSearchFlow*)flow
{
    _flow = flow;

    if (self.isViewLoaded) {
        [self presentStep:flow.firstStep];
    }
}

#pragma mark -

- (void)presentStep:(CMGuidedSearchFlowStep*)step
{
    if (self.stepViewController) {
        [self.stepViewController removeFromParentViewController];
        if (self.stepViewController.isViewLoaded) {
            [self.stepViewController.view removeFromSuperview];
        }
    }
    
    self.flowProgressView.stepCount = self.flow.stepCount;
    self.flowProgressView.completedCount = [self.flow numberOfStepsBefore:step];

    self.stepViewController = [step.class new];

    [self.stepViewController setStep:step];
    [self.stepViewController setStepDelegate:self];

    [self addChildViewController:self.stepViewController];
    [self.questionViewControllerContainerView addSubview:self.stepViewController.view];
    self.stepViewController.view.frame = self.questionViewControllerContainerView.bounds;
    
    self.questionViewControllerTitleLabel.text = step.title;

//    self.backButton.hidden = self.stepViewControllers.count < 2;
//    self.nextButton.hidden = futureQuestionCount == 0;
//    
//    self.stepView.stepCount = self.stepViewControllers.count + futureQuestionCount;
//    self.stepView.completedCount = self.stepViewControllers.count - 1;
}

#pragma mark -

- (IBAction)tappedBack:(id)sender
{
//    if (self.stepViewControllers.count > 1) {
//        [self.stepViewControllers removeLastObject];
//        [self presentQuestionViewController:self.stepViewControllers.lastObject];
//    }
}

- (IBAction)tappedNext:(id)sender
{
//    NSString *validationError = nil;
//
//    if ([self.questionViewController respondsToSelector:@selector(isQuestionCompleteValidationError:)]
//        && ![self.questionViewController isQuestionCompleteValidationError:&validationError]) {
//        
//        if (validationError) {
//            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GuidedSearch", nil)
//                                       message:validationError
//                                      delegate:nil
//                             cancelButtonTitle:NSLocalizedString(@"Close", nil)
//                              otherButtonTitles:nil] show];
//        }
//
//        return;
//    }
//
//    Class nextQuestionViewControllerClass
//      = [self defaultOrDeterminedNextQuestionViewControllerClassFrom:self.questionViewController];
//
//    NSAssert(nextQuestionViewControllerClass, @"Next question view controller class known");
//
//    [self presentQuestionViewController:[nextQuestionViewControllerClass new]];
}


@end
