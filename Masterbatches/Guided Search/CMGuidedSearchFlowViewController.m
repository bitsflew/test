//
//  CMGuidedSearchMainViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchFlowViewController.h"
#import "CMSearchDAO.h"
#import "CMGuidedSearchResultsViewController.h"
#import "CMGuidedSearchProjectRequestViewController.h"

static UIEdgeInsets kCMGuidedSearchFlowViewControllerEdgeInsets = (UIEdgeInsets) { 48.f, 0.f, 0.f, 0.f };
static NSString *kCMGuidedSearchMainViewControllerCellIdentifier = @"cell";

static CGFloat kCMGuidedSearchFlowViewControllerModeAnimationSpeed = 0.3f;
static CGFloat kCMGuidedSearchFlowViewControllerTransitionAnimationSpeed = 0.3f;
static CGFloat kCMGuidedSearchFlowViewControllerSearchThrottleDelay = 1.f;

@interface CMGuidedSearchFlowViewController () <CMGuidedSearchResultsViewControllerDelegate>

@property (nonatomic, strong) UIViewController<CMGuidedSearchStepViewController> *stepViewController;
@property (nonatomic) CGFloat modeToggleButtonInitialTop;
@property (nonatomic) CGFloat modeOffset;
@property (nonatomic) CGFloat modeOffsetBeforePan;

- (void)setModeOffset:(CGFloat)modeOffset animated:(BOOL)animated completion:(dispatch_block_t)completionBlock;

@end

@implementation CMGuidedSearchFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.clipsToBounds = YES;
    self.modeToggleButtonInitialTop = self.overviewToggleButtonTopConstraint.constant;

    if (self.flow) {
        [self presentStep:self.flow.firstStep];
        [self updateSearchResults];
    }

    [self.overviewToggleButton setBackgroundImage:[[UIImage imageNamed:@"img_guided_search_tab.png"]
                                               resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 40.f, 0.f, 40.f)]
                                     forState:UIControlStateNormal];

    [self.overviewToggleButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedPan:)]];
}

- (void)setFlow:(CMGuidedSearchFlow*)flow
{
    _flow = flow;

    if (self.isViewLoaded) {
        [self presentStep:flow.firstStep];
        [self updateSearchResults];
    }
}

#pragma mark -

- (void)updateSearchResults
{
    __weak __typeof(self) _self = self;
    [CMSearchDAO loadSearchResultsForProductSpecification:self.flow.productSpecification
                                               completion:^(NSArray *results, NSError *error) {
                                                   
                                                   NSString *title = (results.count > 0)
                                                     ? [NSString stringWithFormat:@"show %d results", (int)results.count]
                                                     : @"No results – tap for project request";
                                                   
                                                   UIColor *color = (results.count > 0)
                                                     ? [UIColor blackColor]
                                                     : [UIColor colorWithRed:.8f green:0.f blue:0.f alpha:1.f];

                                                   [_self.overviewToggleButton setTitleColor:color forState:UIControlStateNormal];
                                                   [_self.overviewToggleButton setTitle:title forState:UIControlStateNormal];
                                               }];
}

- (void)presentStep:(CMGuidedSearchFlowStep*)step
{
    dispatch_block_t animateOutStepViewBlock = NULL;
    dispatch_block_t removeStepViewBlock = NULL;
    CGRect bounds = self.view.bounds;
    CGFloat animationDirection = 1.f;
    
    if (self.stepViewController) {
        if ([self.flow numberOfStepsBetween:self.stepViewController.step and:step] < 1) {
            animationDirection = -1.f;
        }
        [self.stepViewController removeFromParentViewController];
        if (self.stepViewController.isViewLoaded) {
            UIView *stepView = self.stepViewController.view;
            animateOutStepViewBlock = ^{
                stepView.transform = CGAffineTransformMakeTranslation(animationDirection*-CGRectGetWidth(bounds), 0.f);
            };
            removeStepViewBlock = ^{
                [stepView removeFromSuperview];
            };
        }
    }
    
    self.stepViewController = [step.viewControllerClass new];

    [self.stepViewController setStep:step];
    [self.stepViewController setStepDelegate:self];

    [self addChildViewController:self.stepViewController];
    
    dispatch_block_t addStepViewBlock = ^{
        [self.stepContainerView addSubview:self.stepViewController.view];
    };

    self.stepViewController.view.frame = self.stepContainerView.bounds;
    self.stepViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.titleLabel.text = step.title;
    
    self.flowProgressView.stepCount = self.flow.stepCount;
    self.flowProgressView.completedCount = [self.flow numberOfStepsBefore:step];

    self.previousButton.hidden = self.flowProgressView.completedCount == 0;
    self.nextButton.hidden = self.flowProgressView.completedCount >= self.flowProgressView.stepCount;
    
    if (addStepViewBlock && animateOutStepViewBlock && removeStepViewBlock) {
        self.stepViewController.view.transform = CGAffineTransformMakeTranslation(animationDirection*CGRectGetWidth(bounds), 0.f);
        addStepViewBlock();
        [UIView animateWithDuration:kCMGuidedSearchFlowViewControllerTransitionAnimationSpeed
                         animations:^{
                             animateOutStepViewBlock();
                             self.stepViewController.view.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 removeStepViewBlock();
                             }
                         }];
    } else {
        addStepViewBlock();
    }
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

- (IBAction)tappedModeToggle:(id)sender
{
    [self setModeOffset:(self.modeOffset == 0.f) ? 1.f : 0.f
               animated:YES
             completion:NULL];
}

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

- (IBAction)tappedCloseSearchMode:(id)sender
{
        [self setModeOffset:0.f animated:YES completion:NULL];
}

- (IBAction)showMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)setModeOffset:(CGFloat)modeOffset
{
    [self setModeOffset:modeOffset animated:NO completion:NULL];
}

- (void)setModeOffset:(CGFloat)modeOffset animated:(BOOL)animated completion:(dispatch_block_t)completionBlock
{
    BOOL departingTop = (_modeOffset == 0.f) && (modeOffset > 0.f);
    BOOL hittingBottom = (_modeOffset < 1.f) && (modeOffset == 1.f);
    BOOL hittingTop = !hittingBottom && (_modeOffset > 0.f) && (modeOffset == 0.f);

    if (departingTop && !self.overviewController) {
        if (self.flow.isProjectRequest) {
            self.overviewController = [CMGuidedSearchProjectRequestViewController new];
        } else {
            self.overviewController = [CMGuidedSearchResultsViewController new];
            ((CMGuidedSearchResultsViewController*)self.overviewController).delegate = self;
        }

        self.overviewController.view.frame = self.overviewContainerView.bounds;
        [self.overviewContainerView addSubview:self.overviewController.view];
    }

    _modeOffset = modeOffset;

    CGRect bounds = self.view.bounds;
    
    [self.view layoutIfNeeded];

    dispatch_block_t layoutBlock = ^{
        self.overviewToggleButtonTopConstraint.constant =
        self.modeToggleButtonInitialTop + modeOffset * (CGRectGetHeight(bounds) - self.modeToggleButtonInitialTop);

        self.nextButton.alpha = 1.f - modeOffset;
        self.previousButton.alpha = self.nextButton.alpha;
        self.flowProgressView.alpha = 1.f - modeOffset;
        self.stepOverlayView.alpha = modeOffset;
        self.closeOverviewButton.alpha = fmaxf((modeOffset - 0.9f) / 0.1f, 0.f);

        [self.view layoutIfNeeded];
        
        if (self.stepViewController.isViewLoaded) {
            CGFloat scale = 1.f - sqrtf(modeOffset / 1000.f);
            self.stepViewController.view.transform = hittingTop
              ? CGAffineTransformIdentity
              : CGAffineTransformMakeScale(scale, scale);
        }
    };

    if (animated) {
        [UIView animateWithDuration:kCMGuidedSearchFlowViewControllerModeAnimationSpeed
                         animations:layoutBlock
                         completion:^(BOOL finished) {
                             if (completionBlock) {
                                 completionBlock();
                             }
                         }];
    } else {
        layoutBlock();
    }
    
    if (hittingBottom) {
        self.titleLabel.text = self.overviewController.title;
    }
    
    if (hittingTop) {
        self.titleLabel.text = self.stepViewController.step.title;
    }

    [self.flowProgressView setContractionFactor:modeOffset animated:animated];

    if (!animated && completionBlock) {
        completionBlock();
    }
}

#pragma mark -

- (void)recognizedPan:(UIPanGestureRecognizer*)recognizer
{
    CGFloat top = [recognizer locationInView:self.view].y - CGRectGetMidY(self.overviewToggleButton.bounds);
    CGFloat topVelocity = [recognizer velocityInView:self.view].y;

    CGFloat modeOffset = fmaxf(top - self.modeToggleButtonInitialTop, 0.f) / (CGRectGetHeight(self.view.bounds) - self.modeToggleButtonInitialTop);

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.modeOffsetBeforePan = modeOffset;
            self.modeOffset = modeOffset;
            break;
        case UIGestureRecognizerStateChanged:
            self.modeOffset = modeOffset;
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            CGFloat projectedTop = top + (topVelocity * kCMGuidedSearchFlowViewControllerModeAnimationSpeed);
            CGFloat projectedModeOffset = fmaxf((projectedTop) - self.modeToggleButtonInitialTop, 0.f) / (CGRectGetHeight(self.view.bounds) - self.modeToggleButtonInitialTop);
            
            if (self.modeOffsetBeforePan == 0.f) {
                // Started at the top: prefer movement to bottom
                if ((modeOffset < 0.25f) || (projectedModeOffset < 0.5f)) {
                    [self setModeOffset:0.f animated:YES completion:NULL];
                } else {
                    [self setModeOffset:1.f animated:YES completion:NULL];
                }
            } else {
                // Started at the bottom: prefer movement to top
                if ((modeOffset > 0.75f) || (projectedModeOffset > 0.5f)) {
                    [self setModeOffset:1.f animated:YES completion:NULL];
                } else {
                    [self setModeOffset:0.f animated:YES completion:NULL];
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Step view controller delegate

- (void)stepViewControllerDidCompleteStep:(id<CMGuidedSearchStepViewController>)stepViewController
{
    [self presentNextStep];
}

- (void)stepViewControllerDidChangeProductSpecification:(id<CMGuidedSearchStepViewController>)stepViewController
{
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSearchResults) object:nil];
    [self performSelector:@selector(updateSearchResults) withObject:nil afterDelay:kCMGuidedSearchFlowViewControllerSearchThrottleDelay];
}

- (CMGuidedSearchFlow*)flowForStepViewController:(id<CMGuidedSearchStepViewController>)stepViewController
{
    return self.flow;
}

- (UIEdgeInsets)edgeInsetsForStepViewController:(id<CMGuidedSearchStepViewController>)stepViewController
{
    return kCMGuidedSearchFlowViewControllerEdgeInsets;
}

#pragma mark -

- (void)searchResultsViewControllerDismissedWithProjectRequest:(CMGuidedSearchResultsViewController*)resultsViewController
{
    __weak __typeof(self) _self = self;
    [self setModeOffset:0.f
               animated:YES
             completion:^{
                 _self.flow.projectRequest = YES;
                 _self.overviewController = nil;
             }];
}


@end
