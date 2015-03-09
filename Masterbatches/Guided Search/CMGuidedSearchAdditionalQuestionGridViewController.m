//
//  CMGuidedSearchAdditionalQuestionGridViewController.m
//  MB Sales
//
//  Created by Craig on 03/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionGridViewController.h"

@interface CMGuidedSearchAdditionalQuestionGridItem : NSObject <CMGridItem>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;

@end

@implementation CMGuidedSearchAdditionalQuestionGridItem

@end

@interface CMGuidedSearchAdditionalQuestionGridViewController ()

@property (nonatomic) BOOL multiSelect;

@end

@implementation CMGuidedSearchAdditionalQuestionGridViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.additionalQuestion) {
        [self updateItems];
    }
}

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion *)additionalQuestion
{
    _additionalQuestion = additionalQuestion;

    self.multiSelect = [additionalQuestion.attributes[@"MultiSelect"] boolValue];
 
    if (self.isViewLoaded) {
        [self updateItems];
    }
}

- (void)updateItems
{
    NSMutableArray *items = [NSMutableArray new];
    NSMutableArray *selectedItems = [NSMutableArray new];

    for (NSDictionary *dictionaryItem in self.additionalQuestion.attributes[@"Items"]) {
        CMGuidedSearchAdditionalQuestionGridItem *gridItem = [CMGuidedSearchAdditionalQuestionGridItem new];
        gridItem.title = dictionaryItem[@"Title"];
        gridItem.key = dictionaryItem[@"Key"];
        [items addObject:gridItem];

        if ((self.multiSelect && [self.additionalQuestion.value containsObject:gridItem.key]) ||
            (!self.multiSelect && [self.additionalQuestion.value isEqual:gridItem.key])) {
            [selectedItems addObject:gridItem];
        }
    }

    self.grid.allowsMultipleSelection = self.multiSelect;
    self.grid.items = items;

    [self.grid selectItems:selectedItems animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.grid invalidateIntrinsicContentSize];
}

#pragma mark -

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item
{
    if (self.multiSelect) {
        self.additionalQuestion.value = [gridView.selectedItems valueForKey:@"key"];
    } else
        if ([item isKindOfClass:[CMGuidedSearchAdditionalQuestionGridItem class]]) {
            self.additionalQuestion.value = ((CMGuidedSearchAdditionalQuestionGridItem*)item).key;
        }
}

- (void)gridView:(CMGridView*)gridView didDeselectItem:(id<CMGridItem>)item
{
    if (self.multiSelect) {
        self.additionalQuestion.value = [gridView.selectedItems valueForKey:@"key"];
    } else {
        self.additionalQuestion.value = nil;
    }
}


@end
