//
//  MenuView.h
//  Masterbatches
//
//  Created by Berik Visschers on 02-17.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"

typedef void (^MenuActionHandler)(NSString *menuAction);

@interface MenuView : UIView

@property (nonatomic, copy) MenuActionHandler menuActionHandler;
@property (nonatomic, strong) MenuModel *menu;

@end
