//
//  CMGuidedSearchResultController.h
//  MB Sales
//
//  Created by Craig on 23/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMGuidedSearchResultController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *startProjectRequestButton;
@property (nonatomic, weak) IBOutlet UITextField *projectRequestNameField;
@property (nonatomic, weak) IBOutlet UILabel *noResultsLabel;

@end
