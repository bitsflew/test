//
//  CMGuidedSearchAdditionalQuestionsViewController.m
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionsViewController.h"
#import "CMGuidedSearchAdditionalQuestionViewController.h"

static CGFloat kCMGuidedSearchAdditionalQuestionsViewControllerSpacing = 10.f;
static CGFloat kCMGuidedSearchAdditionalQuestionsViewControllerTitleMargin = 10.f;

@interface CMGuidedSearchAdditionalQuestionsViewController ()

@property (nonatomic, weak) UIView *lastQuestionView;

@end

@implementation CMGuidedSearchAdditionalQuestionsViewController

- (void)viewDidLoad
{
    self.questionTitleTemplateLabel.hidden = YES;
    self.questionsScrollView.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.questionsScrollView.scrollIndicatorInsets = self.questionsScrollView.contentInset;
    self.questionsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CMGuidedSearchFlow *flow = [self.stepDelegate flowForStepViewController:self];

    for (CMProductSpecificationAdditive *additive in self.step.productSpecification.additives) {
        NSString *name = [NSString stringWithFormat:@"Additive-Additional-%@", additive.name];

        NSArray *questions = [flow additionalQuestionsNamed:name];
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
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = self.questionTitleTemplateLabel.font;
    titleLabel.textColor = self.questionTitleTemplateLabel.textColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = question.title;

    [self.questionsScrollView addSubview:titleLabel];

    UIView *viewToAlignTitleLabelTo = self.lastQuestionView ?: self.questionsScrollView;
    NSLayoutAttribute attributeToLayoutTitleTo = self.lastQuestionView ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
    CGFloat spacing = self.lastQuestionView ? kCMGuidedSearchAdditionalQuestionsViewControllerSpacing : 0.f;

    [self.questionsScrollView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:viewToAlignTitleLabelTo
                                                                         attribute:attributeToLayoutTitleTo
                                                                        multiplier:1
                                                                          constant:spacing]];
    
    [self.questionsScrollView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.questionsScrollView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1
                                                                          constant:kCMGuidedSearchAdditionalQuestionsViewControllerTitleMargin]];

    [self.questionsScrollView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.questionsScrollView
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:1
                                                                          constant:-kCMGuidedSearchAdditionalQuestionsViewControllerTitleMargin]];

    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    [self.questionsScrollView addSubview:viewController.view];
    
    [self.questionsScrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:titleLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:0]];
    
    [self.questionsScrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:titleLabel
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1
                                                                          constant:0]];
    
    [self.questionsScrollView addConstraint:[NSLayoutConstraint constraintWithItem:viewController.view
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:titleLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1
                                                                          constant:0]];

    self.lastQuestionView = viewController.view;

    [self.questionsScrollView layoutSubviews];
}

@end
