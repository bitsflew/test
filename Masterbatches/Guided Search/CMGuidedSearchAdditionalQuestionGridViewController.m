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
 
    if (self.isViewLoaded) {
        [self updateItems];
    }
}

- (void)updateItems
{
    NSMutableArray *items = [NSMutableArray new];
    
    CMGuidedSearchAdditionalQuestionGridItem *selectedItem = nil;

    for (NSString *stringItem in self.additionalQuestion.attributes[@"Items"]) {
        CMGuidedSearchAdditionalQuestionGridItem *gridItem = [CMGuidedSearchAdditionalQuestionGridItem new];
        if ([self.additionalQuestion.value isEqual:stringItem]) {
            selectedItem = gridItem;
        }
        gridItem.title = stringItem;
        [items addObject:gridItem];
    }

    self.grid.items = items;
    
    if (selectedItem) {
        [self.grid selectItems:@[ selectedItem ] animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.grid invalidateIntrinsicContentSize];
}

#pragma mark -

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item
{
    self.additionalQuestion.value = [item title];
}

- (void)gridView:(CMGridView*)gridView didDeselectItem:(id<CMGridItem>)item
{
    self.additionalQuestion.value = nil;
}


@end
