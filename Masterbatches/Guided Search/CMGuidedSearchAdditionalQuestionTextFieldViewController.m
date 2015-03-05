//
//  CMGuidedSearchAdditionalQuestionInputFieldViewController.m
//  MB Sales
//
//  Created by Craig on 23/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionTextFieldViewController.h"

@interface CMGuidedSearchAdditionalQuestionTextFieldViewControllerTextField : UITextField

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldViewControllerTextField

- (CGSize)intrinsicContentSize
{
    if (self.keyboardType == UIKeyboardTypeNumberPad) {
        return CGSizeMake(100.f, [super intrinsicContentSize].height);
    }
    return CGSizeMake(500.f, [super intrinsicContentSize].height);
}

@end

@interface CMGuidedSearchAdditionalQuestionTextFieldViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldViewController

- (void)loadView
{
    self.view = [CMGuidedSearchAdditionalQuestionTextFieldViewControllerTextField new];
    self.textField = (UITextField*)self.view;
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.delegate = self;
}

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion *)additionalQuestion
{
    _additionalQuestion = additionalQuestion;
    if (self.isViewLoaded) {
        [self updateTextField];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.additionalQuestion) {
        [self updateTextField];
    }
}

- (void)updateTextField
{
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textField.keyboardType = [self.additionalQuestion.attributes[@"Numeric"] boolValue]
      ? UIKeyboardTypeNumberPad
      : UIKeyboardTypeAlphabet;
    self.textField.placeholder = self.additionalQuestion.attributes[@"Prompt"];
    self.textField.text = self.additionalQuestion.value;
}

#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    self.additionalQuestion.value = text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:NO];
    return NO;
}

@end
