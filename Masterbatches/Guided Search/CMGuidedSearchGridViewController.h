//
//  CMGuidedSearchGridViewController.h
//  MB Sales
//
//  Created by Craig on 25/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMGuidedSearchGrid.h"

@interface CMGuidedSearchGridViewController : UIViewController <CMGuidedSearchGridSelectionDelegate>

@property (nonatomic, weak) CMGuidedSearchGrid *grid;

@end
