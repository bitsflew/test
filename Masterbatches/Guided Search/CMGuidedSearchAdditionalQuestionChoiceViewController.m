//
//  CMGuidedSearchAdditionalQuestionChoiceViewController.m
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionChoiceViewController.h"

@interface CMGuidedSearchAdditionalQuestionChoiceTableView : UITableView

@end

@implementation CMGuidedSearchAdditionalQuestionChoiceTableView

- (CGSize)intrinsicContentSize
{
    CGFloat totalHeight = self.rowHeight * [self numberOfRowsInSection:0];
    return CGSizeMake(UIViewNoIntrinsicMetric, totalHeight);
}

@end

@interface CMGuidedSearchAdditionalQuestionChoiceViewController ()

@end

static NSString *CMChoiceCellIdentifier = @"cell";

@implementation CMGuidedSearchAdditionalQuestionChoiceViewController

- (void)loadView
{
    [super loadView];
    self.view = [CMGuidedSearchAdditionalQuestionChoiceTableView new];
    self.tableView = (UITableView*)self.view;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.rowHeight = 40.f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
    self.clearsSelectionOnViewWillAppear = NO;

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CMChoiceCellIdentifier];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion *)additionalQuestion
{
    // TODO!
    // 2. Select item matching productSpecification.valueForAdditionalQuestionKey:additionalQuestion.key
    _additionalQuestion = additionalQuestion;

    [self.tableView reloadData];
    [self.tableView invalidateIntrinsicContentSize];

    id selected = additionalQuestion.value;

    NSUInteger selectedIndex = [[self choices] indexOfObject:selected];
    
    if (selectedIndex != NSNotFound) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id selected = [self choices][indexPath.row];
    
    [self.additionalQuestion setValue:selected];
}

@end
