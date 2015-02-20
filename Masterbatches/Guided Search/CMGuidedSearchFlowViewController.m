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
@property (nonatomic) CGFloat modeToggleButtonInitialTop;
@property (nonatomic) CGFloat modeOffset;

- (void)setModeOffset:(CGFloat)modeOffset animated:(BOOL)animated;

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

    self.modeToggleButtonInitialTop = self.modeToggleButtonTopConstraint.constant;

    if (self.flow) {
        [self presentStep:self.flow.firstStep];
    }
    
    [self.modeToggleButton setBackgroundImage:[[UIImage imageNamed:@"img_guided_search_tab.png"]
                                               resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 40.f, 0.f, 40.f)]
                                     forState:UIControlStateNormal];

    [self.modeToggleButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedSwipe:)]];
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
    
    self.stepViewController = [step.viewControllerClass new];

    [self.stepViewController setStep:step];
    [self.stepViewController setStepDelegate:self];

    [self addChildViewController:self.stepViewController];
    [self.questionViewControllerContainerView addSubview:self.stepViewController.view];
    self.stepViewController.view.frame = self.questionViewControllerContainerView.bounds;
    self.stepViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.questionViewControllerTitleLabel.text = step.title;
    
    self.flowProgressView.stepCount = self.flow.stepCount;
    self.flowProgressView.completedCount = [self.flow numberOfStepsBefore:step];

    self.backButton.hidden = self.flowProgressView.completedCount == 0;
    self.nextButton.hidden = self.flowProgressView.completedCount >= self.flowProgressView.stepCount;
}

- (void)presentPreviousStep
{
    CMGuidedSearchFlowStep *previousStep = [self.flow previousStepBefore:[self.stepViewController step]];
    if (!previousStep) {
        return;
    }
    [self presentStep:previousStep];
}

- (void)presentNextStep
{
    CMGuidedSearchFlowStep *nextStep = [self.flow nextStepAfter:[self.stepViewController step]];
    if (!nextStep) {
        return;
    }
    [self presentStep:nextStep];
}

#pragma mark -

- (IBAction)tappedBack:(id)sender
{
    [self presentPreviousStep];
}

- (IBAction)tappedNext:(id)sender
{
    NSString *validationError = nil;

    if ([self.stepViewController respondsToSelector:@selector(completeStepWithValidationError:)]
        && ![self.stepViewController completeStepWithValidationError:&validationError]) {
        if (validationError) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GuidedSearch", nil)
                                       message:validationError
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"Close", nil)
                              otherButtonTitles:nil] show];
        }
        return;
    }

    [self presentNextStep];
}

- (IBAction)showMenu:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)stepViewControllerDidCompleteStep:(id<CMGuidedSearchStepViewController>)stepViewController
{
    [self presentNextStep];
}

#pragma mark -

- (void)setModeOffset:(CGFloat)modeOffset
{
    [self setModeOffset:modeOffset animated:NO];
}

- (void)setModeOffset:(CGFloat)modeOffset animated:(BOOL)animated
{
    _modeOffset = modeOffset;
    
    CGRect bounds = self.view.bounds;
    
    self.modeToggleButtonTopConstraint.constant =
      self.modeToggleButtonInitialTop + modeOffset * (CGRectGetHeight(bounds) - self.modeToggleButtonInitialTop);
    self.nextButton.alpha = 1.f - modeOffset;
    self.flowProgressView.contractionFactor = modeOffset;
    

}

#pragma mark -

- (void)recognizedSwipe:(UISwipeGestureRecognizer*)recognizer
{
    CGFloat top = [recognizer locationInView:self.view].y - CGRectGetMidY(self.modeToggleButton.bounds);
    
    CGFloat modeOffset = fmaxf(top - self.modeToggleButtonInitialTop, 0.f) / (CGRectGetHeight(self.view.bounds) - self.modeToggleButtonInitialTop);

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            self.modeOffset = modeOffset;
            break;
            
        case UIGestureRecognizerStateEnded:
            self.modeOffset = 1.f;
            break;
        default:
            break;
    }
}


@end
