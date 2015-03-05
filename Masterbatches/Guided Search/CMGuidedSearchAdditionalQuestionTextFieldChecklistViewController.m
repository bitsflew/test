//
//  CMGuidedSearchAdditionalQuestionTextFieldChecklistViewController.m
//  MB Sales
//
//  Created by Craig on 04/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionTextFieldChecklistViewController.h"
#import "CMChecklistView.h"

@interface CMGuidedSearchAdditionalQuestionTextFieldChecklistTextField : UITextField

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldChecklistTextField

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(300.f, [super intrinsicContentSize].height);
}

@end

@interface CMGuidedSearchAdditionalQuestionTextFieldChecklistItem : NSObject<CMChecklistItem>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *textFieldPrompt;
@property (nonatomic) BOOL textFieldHidden;
@property (nonatomic) BOOL textFieldNumeric;
@property (nonatomic, readonly, retain) CMGuidedSearchAdditionalQuestionTextFieldChecklistTextField *textField;

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldChecklistItem
@synthesize textField=_textField;

- (UIView*)accessoryView
{
    return self.textField;
}

- (UITextField*)textField
{
    if (self.textFieldHidden) {
        return nil;
    }

    if (!_textField) {
        _textField = [[CMGuidedSearchAdditionalQuestionTextFieldChecklistTextField alloc]
                          initWithFrame:CGRectZero];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = self.textFieldPrompt;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardAppearance = UIKeyboardAppearanceDark;
        _textField.keyboardType = self.textFieldNumeric
          ? UIKeyboardTypeNumberPad
          : UIKeyboardTypeAlphabet;

    }
    return _textField;
}

- (void)setEnabled:(BOOL)enabled forAccessoryView:(UIView*)accessoryView fromUser:(BOOL)fromUser
{
    self.textField.enabled = enabled;
    self.textField.hidden = !enabled;
    
    if (enabled && fromUser) {
        [self.textField becomeFirstResponder];
    }
}

@end

@interface CMGuidedSearchAdditionalQuestionTextFieldChecklistViewController () <UITextFieldDelegate>

@property (nonatomic, weak) CMChecklistView *checklist;
@property (nonatomic) BOOL multiSelect;

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldChecklistViewController

- (void)loadView
{
    self.view = [[CMChecklistView alloc] initWithFrame:CGRectZero];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.checklist = (CMChecklistView*)self.view;
    self.checklist.orientation = CMChecklistOrientationVertical;
    self.checklist.backgroundColor = [UIColor clearColor];
    [self.checklist addTarget:self
                       action:@selector(checklistValueDidChange:)
             forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.additionalQuestion) {
        [self updateChecklist];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.checklist invalidateIntrinsicContentSize];
}

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion *)additionalQuestion
{
    _additionalQuestion = additionalQuestion;

    self.multiSelect = [additionalQuestion.attributes[@"MultiSelect"] boolValue];

    if (self.isViewLoaded) {
        [self updateChecklist];
    }
}

- (void)updateChecklist
{
    NSMutableArray *items = [NSMutableArray new];
    NSMutableArray *selectedItems = [NSMutableArray new];
    
    for (NSDictionary *dictionaryItem in self.additionalQuestion.attributes[@"Items"]) {
        CMGuidedSearchAdditionalQuestionTextFieldChecklistItem *item = [CMGuidedSearchAdditionalQuestionTextFieldChecklistItem new];
        item.title = dictionaryItem[@"Title"];
        item.key = dictionaryItem[@"Key"] ?: item.title;
        item.textFieldPrompt = dictionaryItem[@"TextFieldPrompt"];
        item.textFieldNumeric = [dictionaryItem[@"TextFieldNumeric"] boolValue];
        item.textFieldHidden = [dictionaryItem[@"TextFieldHidden"] boolValue];

        NSString *value = [self.additionalQuestion.value objectForKey:item.key];

        if (value) {
            item.textField.text = value;
            [selectedItems addObject:item];
        }

        [item.textField setDelegate:self];

        [items addObject:item];
    }

    self.checklist.allowsMultipleSelection = self.multiSelect;
    self.checklist.items = items;
    [self.checklist checkItems:selectedItems];
}

- (void)checklistValueDidChange:(id)sender
{
    NSMutableDictionary *value = [NSMutableDictionary new];
    
    for (CMGuidedSearchAdditionalQuestionTextFieldChecklistItem *item in self.checklist.checkedItems) {
        value[item.key] = item.textField.text ?: @"";
    }

    self.additionalQuestion.value = value;
}

#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    CMGuidedSearchAdditionalQuestionTextFieldChecklistItem *changedItem = nil;

    for (CMGuidedSearchAdditionalQuestionTextFieldChecklistItem *item in self.checklist.items) {
        if (item.accessoryView == textField) {
            changedItem = item;
            break;
        }
    }

    if (!changedItem) {
        return NO;
    }

    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];

    NSMutableDictionary *value = [self.additionalQuestion.value mutableCopy];
    value[changedItem.key] = text;
    self.additionalQuestion.value = value;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:NO];
    return NO;
}

@end
