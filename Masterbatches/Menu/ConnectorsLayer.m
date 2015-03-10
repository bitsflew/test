//
//  ConnectorsLayer.m
//  MB Sales
//
//  Created by Craig on 09/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "ConnectorsLayer.h"
#import <UIKit/UIKit.h>

#define ConnectorsLayerAnimationDuration 0.5

@implementation LineConnectorLayer

@end

@implementation ConnectorsLayer

- (LineConnectorLayer*)addLayerConnecting:(CALayer*)fromLayer to:(CALayer*)toLayer
{
    LineConnectorLayer *layer = [LineConnectorLayer layer];
    layer.fromLayer = fromLayer;
    layer.toLayer = toLayer;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineWidth = 1.f;
    [self addSublayer:layer];
    return layer;
}

- (LineConnectorLayer*)layerConnecting:(CALayer*)fromLayer to:(CALayer*)toLayer
{
    for (LineConnectorLayer *layer in self.sublayers) {
        if ((layer.fromLayer == fromLayer) && (layer.toLayer == toLayer)) {
            return layer;
        }
    }
    return nil;
}

- (void)updateConnectorFrom:(CALayer*)fromLayer to:(CALayer*)toLayer
{
    LineConnectorLayer *layer = [self layerConnecting:fromLayer to:toLayer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint fromPoint = [layer.fromLayer.superlayer convertPoint:layer.fromLayer.position toLayer:self];
    CGPoint toPoint = [layer.toLayer.superlayer convertPoint:layer.toLayer.position toLayer:self];
    
    CGPathMoveToPoint(path, NULL, fromPoint.x, fromPoint.y);
    CGPathAddLineToPoint(path, NULL, toPoint.x, toPoint.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = ConnectorsLayerAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.fromValue = (id)layer.path;
    animation.toValue = (id)CFBridgingRelease(path);
    [layer addAnimation:animation forKey:@"path"];
}

- (void)updateConnectorsAnimated:(BOOL)animated
{
    if (!animated) {
        [CATransaction begin];
        [CATransaction setValue:@(YES) forKey:kCATransactionDisableActions];
    }
    
    for (LineConnectorLayer *layer in self.sublayers) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint fromPoint = [layer.fromLayer.superlayer convertPoint:layer.fromLayer.position toLayer:self];
        CGPoint toPoint = [layer.toLayer.superlayer convertPoint:layer.toLayer.position toLayer:self];

        CGPathMoveToPoint(path, NULL, fromPoint.x, fromPoint.y);
        CGPathAddLineToPoint(path, NULL, toPoint.x, toPoint.y);
        
        if (!animated) {
            layer.path = path;
        } else {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.fromValue = (id)layer.path;
            animation.toValue = (id)CFBridgingRelease(path);
            animation.duration = ConnectorsLayerAnimationDuration;
            [layer addAnimation:animation forKey:@"path"];
        }
    }

    if (!animated) {
        [CATransaction commit];
    }
}


@end
