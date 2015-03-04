//
//  CMGuidedSearchAdditionalQuestionChecklistViewController.m
//  MB Sales
//
//  Created by Craig on 04/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionChecklistViewController.h"
#import "CMChecklistView.h"

@interface CMGuidedSearchAdditionalQuestionChecklistItem : NSObject <CMChecklistItem>

@property (nonatomic, copy) NSString *title;

@end

@implementation CMGuidedSearchAdditionalQuestionChecklistItem

@end

@interface CMGuidedSearchAdditionalQuestionChecklistViewController ()

@property (nonatomic, weak) CMChecklistView *checklist;
@property (nonatomic) BOOL multiSelect;
@property (nonatomic) BOOL layoutVertically;

@end

@implementation CMGuidedSearchAdditionalQuestionChecklistViewController

- (void)loadView
{
    self.view = [[CMChecklistView alloc] initWithFrame:CGRectZero];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.checklist = (CMChecklistView*)self.view;
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
    self.layoutVertically = [additionalQuestion.attributes[@"Vertical"] boolValue];

    if (self.isViewLoaded) {
        [self updateChecklist];
    }
}

- (void)updateChecklist
{
    NSMutableArray *items = [NSMutableArray new];
    NSMutableArray *selectedItems = [NSMutableArray new];

    for (NSString *stringItem in self.additionalQuestion.attributes[@"Items"]) {
        CMGuidedSearchAdditionalQuestionChecklistItem *checklistItem = [CMGuidedSearchAdditionalQuestionChecklistItem new];
        checklistItem.title = stringItem;
        [items addObject:checklistItem];
        
        if ((self.multiSelect && [self.additionalQuestion.value containsObject:stringItem]) ||
            (!self.multiSelect && [self.additionalQuestion.value isEqual:stringItem])) {
            [selectedItems addObject:checklistItem];
        }
    }

    self.checklist.orientation = self.layoutVertically ? CMChecklistOrientationVertical : CMChecklistOrientationHorizontal;
    self.checklist.allowsMultipleSelection = self.multiSelect;
    self.checklist.items = items;

    [self.checklist checkItems:selectedItems];
}

- (void)checklistValueDidChange:(id)sender
{
    if (self.multiSelect) {
        self.additionalQuestion.value = [self.checklist.checkedItems valueForKey:@"title"];
    } else {
        self.additionalQuestion.value = [self.checklist.checkedItems.lastObject title];
    }
}

@end
