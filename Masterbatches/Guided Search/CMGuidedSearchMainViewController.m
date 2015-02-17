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

@interface CMGuidedSearchMainViewController () <UITableViewDataSource, UITableViewDelegate>

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
    
    [self.questionClassesTableView registerClass:[UITableViewCell class]
                          forCellReuseIdentifier:CMGuidedSearchMainViewControllerCellIdentifier];

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
    
    [self.questionClassesTableView reloadData];

    self.backButton.hidden = self.questionViewControllers.count < 2;
    self.nextButton.hidden = [self futureQuestionViewControllerClasses].count == 0;
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
    if ([self.questionViewController respondsToSelector:@selector(isQuestionComplete)]
        && ![self.questionViewController isQuestionComplete]) {
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
    [self.questionClassesTableView reloadData];
}

- (void)questionViewControllerDidCompleteQuestion:(UIViewController<CMGuidedSearchQuestionViewController>*)questionViewController
{
    Class nextQuestionViewControllerClass = [self defaultOrDeterminedNextQuestionViewControllerClassFrom:questionViewController];
    
    NSAssert(nextQuestionViewControllerClass, @"Next question view controller class known");

    [self presentQuestionViewController:[nextQuestionViewControllerClass new]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? self.questionViewControllers.count : [self futureQuestionViewControllerClasses].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMGuidedSearchMainViewControllerCellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.f];

    if (indexPath.section == 0) {
        cell.textLabel.text = [[self.questionViewControllers[indexPath.row] class] questionMenuTitle];
        cell.textLabel.textColor = [UIColor blackColor];
    } else {
        cell.textLabel.text = [[self futureQuestionViewControllerClasses][indexPath.row] questionMenuTitle];
        cell.textLabel.textColor = [UIColor grayColor];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (![[self.questionViewControllers[indexPath.row] class] questionMenuTitle]) {
            return 0.f;
        }
    }

    return 40.f;
}


@end
