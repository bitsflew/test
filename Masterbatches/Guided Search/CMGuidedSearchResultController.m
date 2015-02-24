//
//  CMGuidedSearchResultController.m
//  MB Sales
//
//  Created by Craig on 23/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchResultController.h"

@interface CMGuidedSearchResultController ()

@end

@implementation CMGuidedSearchResultController

- (IBAction)tappedStartProjectRequest:(id)sender
{
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.3f
                          delay: 0
                        options:0
                     animations:^{
        [self.startProjectRequestButton setTitle:@"Delete project request"
                                        forState:UIControlStateNormal];

        [self.startProjectRequestButton setTitleColor:[UIColor redColor]
                                             forState:UIControlStateNormal];

                         self.noResultsLabel.alpha = 0.f;

        for (UIImageView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                view.alpha = 0.f;
            }
        }
         [self.view layoutIfNeeded];
    }
     completion:^(BOOL finished) {
         if (finished) {
             [UIView animateWithDuration:0.3f
                              animations:^{
                                  self.projectRequestNameField.alpha = 1.f;
                              }];
         }
     }];
}

@end
