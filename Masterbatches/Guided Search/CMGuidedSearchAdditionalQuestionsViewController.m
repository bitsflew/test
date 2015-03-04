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
static CGFloat kCMGuidedSearchAdditionalQuestionsViewControllerTitleMarginLeft = 15.f;
static CGFloat kCMGuidedSearchAdditionalQuestionsViewControllerTitleMarginRight = 15.f;
static CGFloat kCMGuidedSearchAdditionalQuestionsViewControllerTitleMarginBottom = 10.f;

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    titleLabel.text = [question.title uppercaseString];

    [self.questionsScrollView addSubview:titleLabel];

    UIView *viewToAlignTitleLabelTo = self.lastQuestionView ?: self.questionsScrollView;
    NSLayoutAttribute attributeToLayoutTitleTo = self.lastQuestionView ? NSLayoutAttributeBottom : NSLayoutAttributeTop;
    CGFloat spacing = self.lastQuestionView ? kCMGuidedSearchAdditionalQuestionsViewControllerSpacing : 0.f;

    [self.questionsScrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:titleLabel
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:viewToAlignTitleLabelTo
                                  attribute:attributeToLayoutTitleTo
                                 multiplier:1
                                   constant:spacing]];

    [self.questionsScrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:titleLabel
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.questionsScrollView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:kCMGuidedSearchAdditionalQuestionsViewControllerTitleMarginLeft]];

    [self.questionsScrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:titleLabel
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.questionsScrollView
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:1
                                   constant:
      -kCMGuidedSearchAdditionalQuestionsViewControllerTitleMarginLeft
      -kCMGuidedSearchAdditionalQuestionsViewControllerTitleMarginRight]];

    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    [self.questionsScrollView addSubview:viewController.view];

    [self.questionsScrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:viewController.view
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:titleLabel
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:kCMGuidedSearchAdditionalQuestionsViewControllerTitleMarginBottom]];

    [self.questionsScrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:viewController.view
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:titleLabel
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:0]];

    [self.questionsScrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:viewController.view
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:titleLabel
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0]];

    self.lastQuestionView = viewController.view;

    [self.questionsScrollView layoutSubviews];
}

#pragma mark -

- (void)notifiedKeyboardDidShow:(NSNotification*)notification
{
    // See: https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardSize.height += 10.f; // extra space
    
    self.questionsScrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.questionsScrollView.scrollIndicatorInsets = self.questionsScrollView.contentInset;
    
//    CGRect frame = self.view.frame;
//    frame.size.height -= keyboardSize.height;
//    if (!CGRectContainsPoint(frame, self.matchAccuracyColorCodingTextField.frame.origin) ) {
//        [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
//                         animations:^{
//                             [self.scrollView scrollRectToVisible:self.matchAccuracyColorCodingTextField.frame
//                                                         animated:NO];
//                         }];
//    }
}

- (void)notifiedKeyboardWillHide:(NSNotification*)notification
{
    self.questionsScrollView.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.questionsScrollView.scrollIndicatorInsets = self.questionsScrollView.contentInset;
}

@end
