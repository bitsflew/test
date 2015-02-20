//
//  CMGuidedSearchAdditionalQuestionsViewController.m
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionsViewController.h"
#import "CMGuidedSearchAdditionalQuestionViewController.h"

@interface CMGuidedSearchAdditionalQuestionsViewController ()

@end

@implementation CMGuidedSearchAdditionalQuestionsViewController

- (void)viewDidLoad
{
    // TODO! REMOVE!
//    self.step.productSpecification.additives = @[ [CMProductSpecificationAdditive additiveWithName:@"Conductive"] ];
    
    for (CMProductSpecificationAdditive *additive in self.step.productSpecification.additives) {
        NSString *name = [NSString stringWithFormat:@"Additive-Additional-%@", additive.name];

        NSArray *questions = [[self.stepDelegate flow] additionalQuestionsNamed:name];
        if (!questions) {
            continue;
        }
        
        for (CMGuidedSearchFlowAdditionalQuestion *question in questions) {
            [self addAdditionalQuestionViewControllerFor:question];
        }
    }
}

- (void)addAdditionalQuestionViewControllerFor:(CMGuidedSearchFlowAdditionalQuestion*)question
{
    UIViewController<CMGuidedSearchAdditionalQuestionViewController> *viewController
      = [[question viewControllerClass] new];

    [viewController setAdditionalQuestion:question];

    [self addChildViewController:viewController];
    [self.questionsScrollView addSubview:viewController.view];
    [viewController.view setFrame:self.questionsScrollView.bounds];
}

@end
