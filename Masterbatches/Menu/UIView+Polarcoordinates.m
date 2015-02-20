//
//  UIView.m
//  Masterbatches
//
//  Created by Berik Visschers on 02-19.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "UIView+Polarcoordinates.h"

PolarCoordinate PolarCoordinateZero = (PolarCoordinate){0, 0};

PolarCoordinate PolarCoordinateMake(CGFloat radius, CGFloat angle) {
    return (PolarCoordinate){radius, angle};
}

@implementation UIView (Polar)

#define RotateToTop (-M_PI / 2)

- (PolarCoordinate)polarCoordinateWithCenter:(CGPoint)center {
    CGFloat dx = self.center.x - center.x;
    CGFloat dy = self.center.y - center.y;
    
    return (PolarCoordinate){
        sqrt(dx * dx + dy * dy),
        atan2(dy, dx) - RotateToTop
    };
}

- (void)setPolarCoordinate:(PolarCoordinate)polar withCenter:(CGPoint)center {
    CGFloat dx = cos(polar.angle + RotateToTop) * polar.radius;
    CGFloat dy = sin(polar.angle + RotateToTop) * polar.radius;
    
    self.center = (CGPoint){
        center.x + dx,
        center.y + dy
    };
}

@end

