//
//  CMGuidedSearchMainViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchMainViewController.h"
#import "CMGuidedSearchQuestionViewController.h"

#import "CMGuidedSearchSolutionTypeQuestionViewController.h"

@interface CMGuidedSearchMainViewController ()

@property (nonatomic, weak) UIViewController<CMGuidedSearchQuestionViewController> *questionViewController;

@end

@implementation CMGuidedSearchMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self presentQuestionViewController:[CMGuidedSearchSolutionTypeQuestionViewController new]]; // TODO! REMOVE!
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)presentQuestionViewController:(UIViewController<CMGuidedSearchQuestionViewController>*)viewController
{
    if (self.questionViewController) {
        [self.questionViewController removeFromParentViewController];
        if (self.questionViewController.isViewLoaded) {
            [self.questionViewController.view removeFromSuperview];
        }
    }

    [self addChildViewController:viewController];
    [self.questionViewControllerContainerView addSubview:viewController.view];
    viewController.view.frame = self.questionViewControllerContainerView.bounds;
    
    self.questionViewControllerTitleLabel.text = viewController.title;
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
