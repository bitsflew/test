//
//  UIView.h
//  Masterbatches
//
//  Created by Berik Visschers on 02-19.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat radius;
    CGFloat angle;
} PolarCoordinate;

extern PolarCoordinate PolarCoordinateZero;

PolarCoordinate PolarCoordinateMake(CGFloat radius, CGFloat angle);

@interface UIView (Polar)
- (void)setPolarCoordinate:(PolarCoordinate)polar withCenter:(CGPoint)center;
- (PolarCoordinate)polarCoordinateWithCenter:(CGPoint)center;
@end

