//
//  CMGuidedSearchResultsViewController.h
//  MB Sales
//
//  Created by Craig on 24/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMGuidedSearchResultsViewController;

@protocol CMGuidedSearchResultsViewControllerDelegate <NSObject>

- (void)searchResultsViewControllerDismissedWithProjectRequest:(CMGuidedSearchResultsViewController*)resultsViewController;

@end

@interface CMGuidedSearchResultsViewController : UIViewController

@property (nonatomic, weak) id<CMGuidedSearchResultsViewControllerDelegate> delegate;

@property (nonatomic, retain) NSArray *results;

@end
