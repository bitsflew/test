//
//  CMGuidedSearchGridViewController.h
//  MB Sales
//
//  Created by Craig on 25/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMGridView.h"

@interface CMGridViewController : UIViewController <CMGridViewSelectionDelegate>

@property (nonatomic, weak) CMGridView *grid;

@end
