//
//  CMMenuView.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Mobiquity. All rights reserved.
//

#import "CMMenuView.h"

@interface CMMenuItem ()

@property (retain, nonatomic) CALayer *contentLayer;
@property (retain, nonatomic) NSNumber *contentCornerRadius;
@property (retain, nonatomic) CAShapeLayer *connectorLayer; // from self to parent
@property (retain, nonatomic) UIBezierPath *connectorPath;

@end

@implementation CMMenuItem

+ (CMMenuItem*)itemWithPosition:(CGPoint)position radius:(CGFloat)radius parent:(CMMenuItem*)parentItem
{
    CMMenuItem *item = [CMMenuItem new];
    item.position = position;
    item.radius = radius;
    item.parentItem = parentItem;
    return item;
}

@end

@interface CMMenuView ()

- (void)updateLayersAnimated:(BOOL)animated;

@property (retain, nonatomic) NSTimer *debugTimer;

@end

@implementation CMMenuView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    return [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    return [self commonInit];
}

- (id)commonInit
{
    self.items = [NSMutableArray new];

    self.debugTimer = [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(debugDrift:) userInfo:nil repeats:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CMMenuItem *centralItem = [CMMenuItem itemWithPosition:CGPointMake(0.5, 0.5) radius:0.2 parent:nil];
        [self addItem:centralItem];
        [self addItem:[CMMenuItem itemWithPosition:CGPointMake(0.3, 0.75) radius:0.1 parent:centralItem]];
        [self addItem:[CMMenuItem itemWithPosition:CGPointMake(0.125, 0.5) radius:0.1 parent:centralItem]];
        [self addItem:[CMMenuItem itemWithPosition:CGPointMake(0.625, 0.2) radius:0.1 parent:centralItem]];
    });

    return self;
}

- (void)debugDrift:(NSTimer*)timer
{
    if (self.items.count == 0) {
        return;
    }

    CMMenuItem *randomItem = self.items[arc4random_uniform((u_int32_t)self.items.count)];
    
    randomItem.position = CGPointMake(0.5f, 0.2f);
    randomItem.radius = 0.2f;

    CGFloat margin = 0.2f;
    CGFloat x = margin;
    CGFloat minRadius = 0.1f;

    for (CMMenuItem *item in self.items) {
        if (item == randomItem) {
            continue;
        }

        item.radius = 0.1f;
        item.position = CGPointMake(x, 0.5f + (((CGFloat)arc4random_uniform(50))/50.f)/3.f);
        
        x += (1.f - minRadius) / ((CGFloat)self.items.count-1);
    }
    
    [self updateLayersAnimated:YES];
}


- (void)addItem:(CMMenuItem*)item
{
    [((NSMutableArray*)self.items) addObject:item];
    [self updateLayersAnimated:YES];
}

#pragma mark -

- (CGRect)frameForItem:(CMMenuItem*)item inside:(CGRect)parentFrame
{
    CGFloat minDimension = fminf(CGRectGetWidth(parentFrame), CGRectGetHeight(parentFrame));
    
    CGFloat absoluteRadius = item.radius * minDimension;

    return CGRectMake(CGRectGetMinX(parentFrame) + item.position.x*CGRectGetWidth(parentFrame) - absoluteRadius,
                      CGRectGetMinY(parentFrame) + item.position.y*CGRectGetHeight(parentFrame) - absoluteRadius,
                      absoluteRadius*2.f,
                      absoluteRadius*2.f);
}

- (void)updateLayersAnimated:(BOOL)animated
{
    static const int steps = 50;
    static const CGFloat squeezeFactor = 1.1f;
    static const CGFloat animationDuration = 0.3f;
    static const CGFloat minimumConnectorRadius = 0.5f;

    CGRect frame = self.frame;
    
    NSMutableArray *contentLayers = [NSMutableArray new];
    NSMutableArray *connectorLayers = [NSMutableArray new];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

    for (CMMenuItem *item in self.items) {
        CGRect contentFrame = [self frameForItem:item inside:frame];

        CGPoint contentPosition = CGPointMake(CGRectGetMidX(contentFrame), CGRectGetMidY(contentFrame));
        CGFloat contentRadius = CGRectGetWidth(contentFrame)/2.f;
        CGRect contentBounds = CGRectMake(0, 0, contentRadius*2, contentRadius*2);

        if (!item.contentLayer) {
            item.contentLayer = [CALayer layer];
            item.contentLayer.backgroundColor = [UIColor whiteColor].CGColor;
            item.contentLayer.borderWidth = 2.f;
        } else {
            if (animated) {
                CAAnimationGroup *animation = [CAAnimationGroup animation];

                CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
                boundsAnimation.fromValue = [NSValue valueWithCGRect:item.contentLayer.bounds];
                boundsAnimation.toValue = [NSValue valueWithCGRect:contentBounds];
                
                CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
                positionAnimation.fromValue = [NSValue valueWithCGPoint:item.contentLayer.position];
                positionAnimation.toValue = [NSValue valueWithCGPoint:contentPosition];

                CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                cornerRadiusAnimation.fromValue = @(item.contentLayer.cornerRadius);
                cornerRadiusAnimation.toValue = @(contentRadius);

                animation.duration = animationDuration;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                animation.animations = @[ boundsAnimation, positionAnimation, cornerRadiusAnimation ];
                
                [item.contentLayer addAnimation:animation forKey:@"content"];
            }
        }

        item.contentLayer.position = contentPosition;
        item.contentLayer.bounds = contentBounds;
        item.contentLayer.cornerRadius = contentRadius;
        
        [contentLayers addObject:item.contentLayer];

        if (!item.parentItem) {
            continue;
        }
        
        if (!item.connectorLayer) {
            item.connectorLayer = [CAShapeLayer layer];
            item.connectorLayer.frame = frame;
            item.connectorLayer.strokeColor = [UIColor blackColor].CGColor;
        }
        
        CGRect parentFrame = [self frameForItem:item.parentItem inside:frame];
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        float xDistance = contentPosition.x-CGRectGetMidX(parentFrame);
        float yDistance = contentPosition.y-CGRectGetMidY(parentFrame);

        float angle = atan2f(xDistance, -yDistance);
        
        float distance = sqrtf(xDistance*xDistance + yDistance*yDistance);
        
        CGAffineTransform transform =
        CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(contentPosition.x, contentPosition.y), angle), -1.f, 1.f);
        
        CGFloat baseRadius = CGRectGetWidth(contentFrame)/4.f;
        CGFloat topRadius = CGRectGetWidth(parentFrame)/4.f;

        // Simple line connector
            CGPathMoveToPoint(path, &transform, 0.f, 0.f);
            CGPathAddLineToPoint(path, &transform, 0.f, distance);
//        
//        // "Squeezy" base
//        CGPathMoveToPoint(path, &transform, -baseRadius, 0.f);
//        CGPathAddLineToPoint(path, &transform, baseRadius, 0.f);
//
//        // "Right" side
//        for (int i=0; i<=steps; i++) {
//            CGFloat fraction = (CGFloat)i / (CGFloat)steps;
//            CGFloat y = fraction * distance;
//            CGFloat x = baseRadius + (topRadius - baseRadius) * fraction;
//            CGFloat squeeze = (sinf(fraction * M_PI) / squeezeFactor) * baseRadius;
//            x = fmaxf(x - squeeze, minimumConnectorRadius);
//            CGPathAddLineToPoint(path, &transform, x, y);
//        }
//        
//        for (int i=0; i<=steps; i++) {
//            CGFloat fraction = (CGFloat)i / (CGFloat)steps;
//            CGFloat y = (1.f - fraction) * distance;
//            CGFloat x = -topRadius - (baseRadius - topRadius) * fraction;
//            CGFloat squeeze = (sinf(fraction * M_PI) / squeezeFactor) * baseRadius;
//            x = fminf(x + squeeze, -minimumConnectorRadius);
//            CGPathAddLineToPoint(path, &transform, x, y);
//        }
//        
        UIBezierPath *connectorPath = [UIBezierPath bezierPathWithCGPath:path];

        if (animated && item.connectorPath) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            animation.values = @[ (id)item.connectorPath.CGPath, (id)connectorPath.CGPath ];
            animation.duration = animationDuration;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [item.connectorLayer addAnimation:animation forKey:@"path"];
        }
        
        item.connectorLayer.path = path;
        item.connectorPath = connectorPath;
        
        [connectorLayers addObject:item.connectorLayer];
    }

    self.layer.sublayers = [connectorLayers arrayByAddingObjectsFromArray:contentLayers];
    
    [CATransaction commit];

}

@end
