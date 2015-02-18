//
//  CMGuidedSearchMainViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchMainViewController.h"
#import "CMGuidedSearchQuestionViewController.h"

static NSString *CMGuidedSearchMainViewControllerCellIdentifier = @"cell";

@interface CMGuidedSearchMainViewController ()

@property (nonatomic, weak) UIViewController<CMGuidedSearchQuestionViewController> *questionViewController;

@property (nonatomic, retain) NSMutableArray *questionViewControllers;

@end

@implementation CMGuidedSearchMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    
    self.productSpecification = [CMProductSpecification new];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.questionViewControllers = [NSMutableArray new];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self presentQuestionViewController:[CMGuidedSearchSolutionTypeViewController new]]; // TODO! REMOVE!
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (NSArray*)futureQuestionViewControllerClasses
{
    NSMutableArray *classes = [NSMutableArray new];

    Class nextClass = [self.questionViewController.class defaultNextQuestionViewControllerClass];

    if (!nextClass) {
        nextClass = [self.questionViewController nextQuestionViewControllerClass];
    }

    while (nextClass) {
        [classes addObject:nextClass];
        nextClass = [nextClass defaultNextQuestionViewControllerClass];
    }

    return classes;
}

- (Class)defaultOrDeterminedNextQuestionViewControllerClassFrom:(id<CMGuidedSearchQuestionViewController>)viewController
{
    Class nextQuestionViewControllerClass = viewController.nextQuestionViewControllerClass;
    
    if (!nextQuestionViewControllerClass) {
        nextQuestionViewControllerClass = [[viewController class] defaultNextQuestionViewControllerClass];
    }

    return nextQuestionViewControllerClass;
}

- (void)presentQuestionViewController:(UIViewController<CMGuidedSearchQuestionViewController>*)viewController
{
    if (self.questionViewController) {
        [self.questionViewController removeFromParentViewController];
        if (self.questionViewController.isViewLoaded) {
            [self.questionViewController.view removeFromSuperview];
        }
    }

    NSUInteger currentIndex = [self.questionViewControllers indexOfObjectIdenticalTo:viewController];
    if (currentIndex != NSNotFound) {
        [self.questionViewControllers removeObjectAtIndex:currentIndex];
    }

    self.questionViewController = viewController;
    
    if ([viewController respondsToSelector:@selector(setProductSpecification:)]) {
        [viewController setProductSpecification:self.productSpecification];
    }
    
    [viewController setQuestionViewControllerDelegate:self];

    [self addChildViewController:viewController];
    [self.questionViewControllerContainerView addSubview:viewController.view];
    viewController.view.frame = self.questionViewControllerContainerView.bounds;
    
    self.questionViewControllerTitleLabel.text = viewController.title;

    [self.questionViewControllers addObject:viewController];
    
    NSUInteger futureQuestionCount = [self futureQuestionViewControllerClasses].count;

    self.backButton.hidden = self.questionViewControllers.count < 2;
    self.nextButton.hidden = futureQuestionCount == 0;
    
    self.stepView.stepCount = self.questionViewControllers.count + futureQuestionCount;
    self.stepView.completedCount = self.questionViewControllers.count - 1;
}

#pragma mark -

- (IBAction)tappedBack:(id)sender
{
    if (self.questionViewControllers.count > 1) {
        [self.questionViewControllers removeLastObject];
        [self presentQuestionViewController:self.questionViewControllers.lastObject];
    }
}

- (IBAction)tappedNext:(id)sender
{
    NSString *validationError = nil;

    if ([self.questionViewController respondsToSelector:@selector(isQuestionCompleteValidationError:)]
        && ![self.questionViewController isQuestionCompleteValidationError:&validationError]) {
        
        if (validationError) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GuidedSearch", nil)
                                       message:validationError
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"Close", nil)
                              otherButtonTitles:nil] show];
        }

        return;
    }

    Class nextQuestionViewControllerClass
      = [self defaultOrDeterminedNextQuestionViewControllerClassFrom:self.questionViewController];

    NSAssert(nextQuestionViewControllerClass, @"Next question view controller class known");

    [self presentQuestionViewController:[nextQuestionViewControllerClass new]];
}

#pragma mark - Question view controller delegate

- (void)questionViewControllerDidChangeNextQuestion:(UIViewController<CMGuidedSearchQuestionViewController> *)questionViewController
{

}

- (void)questionViewControllerDidCompleteQuestion:(UIViewController<CMGuidedSearchQuestionViewController>*)questionViewController
{
    Class nextQuestionViewControllerClass = [self defaultOrDeterminedNextQuestionViewControllerClassFrom:questionViewController];
    
    NSAssert(nextQuestionViewControllerClass, @"Next question view controller class known");

    [self presentQuestionViewController:[nextQuestionViewControllerClass new]];
}


@end
