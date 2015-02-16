//
//  CMMenuView.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Mobiquity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMenuItem : NSObject

@property (weak, nonatomic) CMMenuItem *parentItem;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat radius;

+ (CMMenuItem*)itemWithPosition:(CGPoint)position radius:(CGFloat)radius parent:(CMMenuItem*)parentItem;

@end

@interface CMMenuView : UIView

@property (nonatomic, retain) NSArray *items;

@end
