//
//  MenuModel.h
//  Masterbatches
//
//  Created by Berik Visschers on 02-17.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MenuModel : NSObject

+ (instancetype)readMenuFromFile;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *subMenuItems;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) NSUInteger identifier;

@end
