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

    for (NSString *stringItem in self.additionalQuestion.attributes[@"Items"]) {
        CMGuidedSearchAdditionalQuestionGridItem *gridItem = [CMGuidedSearchAdditionalQuestionGridItem new];
        gridItem.title = stringItem;
        [items addObject:gridItem];

        if ((self.multiSelect && [self.additionalQuestion.value containsObject:stringItem]) ||
            (!self.multiSelect && [self.additionalQuestion.value isEqual:stringItem])) {
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
        self.additionalQuestion.value = [gridView.selectedItems valueForKey:@"title"];
    } else {
        self.additionalQuestion.value = [item title];
    }
}

- (void)gridView:(CMGridView*)gridView didDeselectItem:(id<CMGridItem>)item
{
    if (self.multiSelect) {
        self.additionalQuestion.value = [gridView.selectedItems valueForKey:@"title"];
    } else {
        self.additionalQuestion.value = nil;
    }
}


@end
