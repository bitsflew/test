//
//  CMGuidedSearchProjectRequestViewController.h
//  MB Sales
//
//  Created by Craig on 24/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMProjectRequest.h"
#import "CMGuidedSearchFlow.h"

@class CMGuidedSearchProjectRequestViewController;

@protocol CMGuidedSearchProjectRequestViewControllerDelegate <NSObject>

- (void)projectRequestViewControllerDismissedCancellingProjectRequest:(CMGuidedSearchProjectRequestViewController*)projectRequestViewController;

@end

@interface CMGuidedSearchProjectRequestViewController : UIViewController

@property (nonatomic, strong) CMProjectRequest *projectRequest;

@property (nonatomic, weak) id<CMGuidedSearchProjectRequestViewControllerDelegate> delegate;

@end
