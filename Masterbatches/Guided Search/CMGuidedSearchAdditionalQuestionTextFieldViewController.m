//
//  CMGuidedSearchAdditionalQuestionInputFieldViewController.m
//  MB Sales
//
//  Created by Craig on 23/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionTextFieldViewController.h"

static const CGFloat CMGuidedSearchAdditionalQuestionTextFieldViewHorizontalPadding = 15.f;
static const CGFloat CMGuidedSearchAdditionalQuestionTextFieldViewVerticalPadding = 10.f;

@interface CMGuidedSearchAdditionalQuestionTextFieldViewController () <UITextFieldDelegate>

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldViewController

- (void)loadView
{
    self.view = [UITextField new];
    ((UITextField*)self.view).borderStyle = UITextBorderStyleRoundedRect;
    ((UITextField*)self.view).delegate = self;
}

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion *)additionalQuestion
{
    _additionalQuestion = additionalQuestion;
    ((UITextField*)self.view).text = self.additionalQuestion.value;
}

#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    self.additionalQuestion.value = text;
    return YES;
}

@end
