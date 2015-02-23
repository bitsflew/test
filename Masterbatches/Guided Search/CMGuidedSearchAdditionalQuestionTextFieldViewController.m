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

@interface CMGuidedSearchAdditionalQuestionTextFieldView : UITextField

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldView

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(CGRectGetMinX(bounds) + CMGuidedSearchAdditionalQuestionTextFieldViewHorizontalPadding,
                      CGRectGetMinY(bounds) + CMGuidedSearchAdditionalQuestionTextFieldViewVerticalPadding,
                      CGRectGetWidth(bounds) - CMGuidedSearchAdditionalQuestionTextFieldViewHorizontalPadding*2.f,
                      CGRectGetHeight(bounds) - CMGuidedSearchAdditionalQuestionTextFieldViewVerticalPadding*2.f);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end

@interface CMGuidedSearchAdditionalQuestionTextFieldViewController () <UITextFieldDelegate>

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldViewController

- (void)loadView
{
    self.view = [CMGuidedSearchAdditionalQuestionTextFieldView new];
    self.view.backgroundColor = [UIColor whiteColor];
    ((CMGuidedSearchAdditionalQuestionTextFieldView*)self.view).delegate = self;
}

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion *)additionalQuestion
{
    _additionalQuestion = additionalQuestion;

    ((CMGuidedSearchAdditionalQuestionTextFieldView*)self.view).text =
      [additionalQuestion.productSpecification valueForAdditionalQuestionKey:additionalQuestion.key];
}

#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    [self.additionalQuestion.productSpecification setValue:text forAdditionalQuestionKey:self.additionalQuestion.key];
    return YES;
}

@end
