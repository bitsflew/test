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

@interface CMGuidedSearchProjectRequestViewController : UIViewController

@property (nonatomic, strong) CMProjectRequest *projectRequest;
@property (nonatomic, strong) CMGuidedSearchFlow *flow; // populate steps filled/remaining

@end
