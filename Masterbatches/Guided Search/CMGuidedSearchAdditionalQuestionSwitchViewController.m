//
//  CMGuidedSearchAdditionalQuestionSwitchViewController.m
//  MB Sales
//
//  Created by Craig on 04/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditionalQuestionSwitchViewController.h"

@interface CMGuidedSearchAdditionalQuestionSwitchViewController ()

@property (nonatomic, weak) UISwitch *switchView;

@end

@implementation CMGuidedSearchAdditionalQuestionSwitchViewController

- (void)loadView
{
    self.view = [UISwitch new];
    self.switchView = (UISwitch*)self.view;
    [self.switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.additionalQuestion) {
        [self updateSwitch];
    }
}

- (void)setAdditionalQuestion:(CMGuidedSearchFlowAdditionalQuestion *)additionalQuestion
{
    _additionalQuestion = additionalQuestion;

    if (self.isViewLoaded) {
        [self updateSwitch];
    }
}

- (void)updateSwitch
{
    self.switchView.on = [self.additionalQuestion.value boolValue];
}

#pragma mark -

- (void)switchValueChanged:(id)sender
{
    self.additionalQuestion.value = @(self.switchView.isOn);
}

@end
