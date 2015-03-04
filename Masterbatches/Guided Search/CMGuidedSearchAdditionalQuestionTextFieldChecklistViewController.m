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
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, retain) CMGuidedSearchAdditionalQuestionTextFieldChecklistTextField *textField;

@end

@implementation CMGuidedSearchAdditionalQuestionTextFieldChecklistItem

- (UIView*)accessoryView
{
    if (!self.textField) {
        self.textField = [[CMGuidedSearchAdditionalQuestionTextFieldChecklistTextField alloc]
                          initWithFrame:CGRectZero];
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.placeholder = self.prompt;
        self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    return self.textField;
}

- (void)setEnabled:(BOOL)enabled forAccessoryView:(UIView*)accessoryView
{
    self.textField.enabled = enabled;
}

@end

@interface CMGuidedSearchAdditionalQuestionTextFieldChecklistViewController ()

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
        item.key = dictionaryItem[@"Key"];
        item.prompt = dictionaryItem[@"Prompt"];
        [items addObject:item];

//        if ((self.multiSelect && [self.additionalQuestion.value containsObject:stringItem]) ||
//            (!self.multiSelect && [self.additionalQuestion.value isEqual:stringItem])) {
//            [selectedItems addObject:checklistItem];
//        }
    }

    self.checklist.allowsMultipleSelection = self.multiSelect;
    self.checklist.items = items;
    [self.checklist checkItems:selectedItems];
}

- (void)checklistValueDidChange:(id)sender
{
//    if (self.multiSelect) {
//        self.additionalQuestion.value = [self.checklist.checkedItems valueForKey:@"title"];
//    } else {
//        self.additionalQuestion.value = [self.checklist.checkedItems.lastObject title];
//    }
}

@end
