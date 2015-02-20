//
//  CMGuidedSearchAdditionalQuestionChoiceViewController.m
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionChoiceViewController.h"

@interface CMGuidedSearchAdditionalQuestionChoiceViewController ()

@end

static NSString *CMChoiceCellIdentifier = @"cell";

@implementation CMGuidedSearchAdditionalQuestionChoiceViewController

- (void)viewDidLoad
{
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CMChoiceCellIdentifier];
}

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion *)additionalQuestion
{
    // TODO!
    // 2. Select item matching productSpecification.valueForAdditionalQuestionKey:additionalQuestion.key
    _additionalQuestion = additionalQuestion;
    [self.tableView reloadData];
}

#pragma mark -

- (NSArray*)choices
{
    return self.additionalQuestion.attributes[@"Choices"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self choices].count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMChoiceCellIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [self choices][indexPath.row];
    return cell;
}

@end
