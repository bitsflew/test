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

static CGFloat kCMGuidedSearchFlowViewControllerOverviewAnimationSpeed = 0.3f;
static CGFloat kCMGuidedSearchFlowViewControllerTransitionAnimationSpeed = 0.3f;
static CGFloat kCMGuidedSearchFlowViewControllerSearchThrottleDelay = 1.f;

@interface CMGuidedSearchFlowViewController () <
    CMGuidedSearchResultsViewControllerDelegate,
    CMGuidedSearchProjectRequestViewControllerDelegate,
    UIGestureRecognizerDelegate
    >

@property (nonatomic, strong) NSArray *searchResults;

@property (nonatomic, strong) UIViewController<CMGuidedSearchStepViewController> *stepViewController;

@property (nonatomic) CGFloat overviewToggleButtonInitialTop;
@property (nonatomic) CGFloat overviewPosition;
@property (nonatomic) CGFloat overviewPositionBeforePan;
@property (nonatomic) BOOL overviewBusy;

@property (nonatomic, retain) UIGestureRecognizer *overviewPanRecognizer;

- (void)setOverviewPosition:(CGFloat)overviewPosition animated:(BOOL)animated completion:(dispatch_block_t)completionBlock;

@end

@implementation CMGuidedSearchFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.overviewToggleButtonInitialTop = self.overviewToggleButtonTopConstraint.constant;

    [self.overviewToggleButton setBackgroundImage:[[UIImage imageNamed:@"img_guided_search_tab.png"]
                                               resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 40.f, 0.f, 40.f)]
                                     forState:UIControlStateNormal];

    self.overviewPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedPan:)];
    self.overviewPanRecognizer.delegate = self;
    [self.overviewToggleButton addGestureRecognizer:self.overviewPanRecognizer];

    if (self.flow) {
        [self presentStep:self.flow.firstStep];
        [self updateSearchResults];
    }
}

- (void)setFlow:(CMGuidedSearchFlow*)flow
{
    _flow = flow;
    
    self.title = flow.title;

    if (self.isViewLoaded) {
        [self presentStep:flow.firstStep];
        [self updateSearchResults];
    }
}

- (void)setOverviewBusy:(BOOL)overviewBusy
{
    if (overviewBusy == _overviewBusy) {
        return;
    }

    _overviewBusy = overviewBusy;

    if (_overviewBusy) {
        [self.overviewActivityIndicator startAnimating];
    } else {
        [self.overviewActivityIndicator stopAnimating];
    }

    [UIView animateWithDuration:kCMGuidedSearchFlowViewControllerOverviewAnimationSpeed
                     animations:^{
                         CGAffineTransform scaledToPoint =
                           CGAffineTransformMakeScale(0.1f, 0.1f);
                         self.overviewActivityIndicator.transform =
                           overviewBusy ? CGAffineTransformIdentity : scaledToPoint;
                         self.overviewArrowView.transform =
                           overviewBusy ? scaledToPoint : CGAffineTransformIdentity;

                         self.overviewActivityIndicator.alpha = (CGFloat)overviewBusy;
                         self.overviewArrowView.alpha = (CGFloat)!overviewBusy;
                     }];
}

#pragma mark -

- (void)updateSearchResults
{
    self.overviewBusy = YES;

    __weak __typeof(self) _self = self;
    
    [CMSearchDAO loadSearchResultsForProductSpecification:self.flow.productSpecification
                                               completion:^(NSArray *results, NSError *error) {
                                                   _self.overviewBusy = NO;
                                                   _self.searchResults = results;
                                                   [_self updateOverviewToggleButton];
                                               }];
}

- (void)updateOverviewToggleButton
{
    NSString *title;
    UIColor *titleColor;

    if (self.flow.projectRequest) {
        title = NSLocalizedString(@"SeeProjectRequest", nil);
        titleColor = [UIColor blackColor];
    } else {
        if (self.searchResults.count == 0) {
            title = NSLocalizedString(@"ShowNoResults", nil);
            titleColor = [UIColor colorWithRed:0.788 green:0.109 blue:0.172 alpha:1];
        } else {
            title = (self.searchResults.count == 1)
              ? NSLocalizedString(@"ShowSingleResult", nil)
              : [NSString stringWithFormat:NSLocalizedString(@"ShowPluralResultsFormat", nil), self.searchResults.count];
            titleColor = [UIColor blackColor];
        }
    }

    [self.overviewToggleButton setTitle:title forState:UIControlStateNormal];
    [self.overviewToggleButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)presentStep:(CMGuidedSearchFlowStep*)step
{
    [self.view.window endEditing:YES];

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
        self.stepViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.stepContainerView addSubview:self.stepViewController.view];

        for (NSNumber *attribute in @[ @(NSLayoutAttributeLeft),
                                       @(NSLayoutAttributeTop),
                                       @(NSLayoutAttributeWidth),
                                       @(NSLayoutAttributeHeight)
                                       ]) {
            [self.stepContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.stepViewController.view
                                                             attribute:attribute.integerValue
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.stepContainerView
                                                             attribute:attribute.integerValue
                                                            multiplier:1.f
                                                              constant:0.f]];
        }

        self.titleLabel.text = self.stepViewController.step.title;
    };

    [self updateFlowProgressView];

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
        // Extremely unfortunate fix for bad initial layout
        dispatch_async(dispatch_get_main_queue(), ^{
            addStepViewBlock();
        });
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

- (IBAction)tappedOverviewToggle:(id)sender
{
    [self setOverviewPosition:(self.overviewPosition == 0.f) ? 1.f : 0.f
               animated:YES
             completion:NULL];
}

- (IBAction)tappedCloseOverview:(id)sender
{
    [self setOverviewPosition:0.f animated:YES completion:NULL];
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

#pragma mark -

- (void)setOverviewPosition:(CGFloat)overviewPosition
{
    [self setOverviewPosition:overviewPosition animated:NO completion:NULL];
}

- (void)setOverviewPosition:(CGFloat)overviewPosition animated:(BOOL)animated completion:(dispatch_block_t)completionBlock
{
    BOOL departingTop = (_overviewPosition == 0.f) && (overviewPosition > 0.f);
    BOOL hittingBottom = (_overviewPosition < 1.f) && (overviewPosition == 1.f);
    BOOL hittingTop = !hittingBottom && (_overviewPosition > 0.f) && (overviewPosition == 0.f);

    if (departingTop && !self.overviewController) {
        if (self.flow.projectRequest) {
            self.overviewController = [CMGuidedSearchProjectRequestViewController new];
            ((CMGuidedSearchProjectRequestViewController*)self.overviewController).delegate = self;
        } else {
            self.overviewController = [CMGuidedSearchResultsViewController new];
            ((CMGuidedSearchResultsViewController*)self.overviewController).delegate = self;
        }

        self.overviewController.view.frame = self.overviewContainerView.bounds;
        [self.overviewContainerView addSubview:self.overviewController.view];
    }

    _overviewPosition = overviewPosition;

    CGRect bounds = self.view.bounds;
    
    [self.view layoutIfNeeded];

    dispatch_block_t layoutBlock = ^{
        self.overviewToggleButtonTopConstraint.constant =
          self.overviewToggleButtonInitialTop + overviewPosition * (CGRectGetHeight(bounds) - self.overviewToggleButtonInitialTop - CGRectGetHeight(self.overviewToggleButton.frame)/2.f);

        self.nextButton.alpha = 1.f - overviewPosition;
        self.previousButton.alpha = self.nextButton.alpha;
        self.flowProgressView.alpha = 1.f - overviewPosition;
        self.stepOverlayView.alpha = overviewPosition;
        self.closeOverviewButton.alpha = fmaxf((overviewPosition - 0.9f) / 0.1f, 0.f);
        self.overviewActivityContainerView.alpha = 1.f - self.closeOverviewButton.alpha;

        [self.view layoutIfNeeded];
        
        if (self.stepViewController.isViewLoaded) {
            CGFloat scale = 1.f - sqrtf(overviewPosition / 1000.f);
            self.stepViewController.view.transform = hittingTop
              ? CGAffineTransformIdentity
              : CGAffineTransformMakeScale(scale, scale);
        }
    };

    if (animated) {
        [UIView animateWithDuration:kCMGuidedSearchFlowViewControllerOverviewAnimationSpeed
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

    [self.flowProgressView setContractionFactor:overviewPosition animated:animated];

    if (!animated && completionBlock) {
        completionBlock();
    }
}

#pragma mark -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.overviewPanRecognizer) {
        return self.overviewPosition < 1.f;
    }

    return YES;
}

- (void)recognizedPan:(UIPanGestureRecognizer*)recognizer
{
    CGFloat top = [recognizer locationInView:self.view].y - CGRectGetHeight(self.overviewToggleButton.bounds);
    CGFloat topVelocity = [recognizer velocityInView:self.view].y;

    CGFloat overviewPosition = fmaxf(top - self.overviewToggleButtonInitialTop, 0.f) / (CGRectGetHeight(self.view.bounds) - self.overviewToggleButtonInitialTop);

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.overviewPositionBeforePan = overviewPosition;
            self.overviewPosition = overviewPosition;
            break;
        case UIGestureRecognizerStateChanged:
            self.overviewPosition = overviewPosition;
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            CGFloat projectedTop = top + (topVelocity * kCMGuidedSearchFlowViewControllerOverviewAnimationSpeed);
            CGFloat projectedOverviewPosition = fmaxf((projectedTop) - self.overviewToggleButtonInitialTop, 0.f) / (CGRectGetHeight(self.view.bounds) - self.overviewToggleButtonInitialTop);
            
            if (self.overviewPositionBeforePan == 0.f) {
                // Started at the top: prefer movement to bottom
                if ((overviewPosition < 0.25f) || (projectedOverviewPosition < 0.5f)) {
                    [self setOverviewPosition:0.f animated:YES completion:NULL];
                } else {
                    [self setOverviewPosition:1.f animated:YES completion:NULL];
                }
            } else {
                // Started at the bottom: prefer movement to top
                if ((overviewPosition > 0.75f) || (projectedOverviewPosition > 0.5f)) {
                    [self setOverviewPosition:1.f animated:YES completion:NULL];
                } else {
                    [self setOverviewPosition:0.f animated:YES completion:NULL];
                }
            }
            break;
        }
        default:
            break;
    }
}

- (void)updateFlowProgressView
{
    self.flowProgressView.stepCount = self.flow.stepCount;
    self.flowProgressView.completedCount = [self.flow numberOfStepsBefore:[self.stepViewController step]];
}

#pragma mark - Step view controller delegate

- (void)stepViewControllerDidCompleteStep:(id<CMGuidedSearchStepViewController>)stepViewController
{
    [self presentNextStep];
}

- (void)stepViewControllerDidChangeProductSpecification:(id<CMGuidedSearchStepViewController>)stepViewController
{
    [self updateFlowProgressView];

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
    [self.flow createProjectRequest];
    [self updateOverviewToggleButton];

    __weak __typeof(self) _self = self;
    [self setOverviewPosition:0.f
               animated:YES
             completion:^{
                 _self.overviewController = nil;
                 [_self.flowProgressView setStepCount:10];
             }];
    
    [UIView animateWithDuration:kCMGuidedSearchFlowViewControllerOverviewAnimationSpeed
                     animations:^{
                         self.projectRequestLabel.alpha = 1.f;
                     }];
}

#pragma mark -

- (void)projectRequestViewControllerDismissedCancellingProjectRequest:(CMGuidedSearchProjectRequestViewController*)projectRequestViewController
{
    [self.flow cancelProjectRequest];
    [self updateOverviewToggleButton];

    __weak __typeof(self) _self = self;
    [self setOverviewPosition:0.f
                     animated:YES
                   completion:^{
                       _self.overviewController = nil;
                       [_self.flowProgressView setStepCount:10];
                   }];
    
    [UIView animateWithDuration:kCMGuidedSearchFlowViewControllerOverviewAnimationSpeed
                     animations:^{
                         self.projectRequestLabel.alpha = 0.f;
                     }];
}

@end
