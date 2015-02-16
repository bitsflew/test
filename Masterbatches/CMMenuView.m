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
@property (retain, nonatomic) NSValue *contentPosition;
@property (retain, nonatomic) NSValue *contentBounds;
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

    dispatch_async(dispatch_get_main_queue(), ^{
        CMMenuItem *centralItem = [CMMenuItem itemWithPosition:CGPointMake(0.5, 0.5) radius:0.2 parent:nil];
        [self addItem:centralItem];
        [self addItem:[CMMenuItem itemWithPosition:CGPointMake(0.5, 0.75) radius:0.1 parent:centralItem]];
        [self addItem:[CMMenuItem itemWithPosition:CGPointMake(0.125, 0.5) radius:0.05 parent:centralItem]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            centralItem.position = CGPointMake(0.5f, 0.1f);
            [self updateLayersAnimated:YES];
        });
        
    });

    return self;
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
    static const int steps = 20;
    static const CGFloat squeezeFactor = 0.9f;
    static const CGFloat animationDuration = 0.5f;

    CGRect frame = self.frame;
    
    NSMutableArray *contentLayers = [NSMutableArray new];
    NSMutableArray *connectorLayers = [NSMutableArray new];

    for (CMMenuItem *item in self.items) {
        CGRect itemFrame = [self frameForItem:item inside:frame];

        if (!item.contentLayer) {
            item.contentLayer = [CALayer layer];
            item.contentLayer.backgroundColor = [UIColor whiteColor].CGColor;
            item.contentLayer.borderWidth = 2.f;
            item.contentLayer.anchorPoint = CGPointZero;
        }
        
        NSValue *contentFrame = [NSValue valueWithCGRect:itemFrame];
        
        if (animated && item.contentFrame) {
            CAKeyframeAnimation *animation = [CABasicAnimation animationWithKeyPath:@"frame"];
            animation.fromValue = item.contentFrame;
            animation.toValue = contentFrame;
            animation.duration = animationDuration;
            [item.contentLayer addAnimation:animation forKey:@"frame"];
        } else {
            
        }
        
        
        item.contentLayer.cornerRadius = CGRectGetHeight(itemFrame)/2.f;
        
        [contentLayers addObject:item.contentLayer];

        if (!item.parentItem) {
            continue;
        }
        
        if (!item.connectorLayer) {
            item.connectorLayer = [CAShapeLayer layer];
            item.connectorLayer.frame = frame;
        }
        
        CGRect parentFrame = [self frameForItem:item.parentItem inside:frame];
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        float xDistance = CGRectGetMidX(itemFrame)-CGRectGetMidX(parentFrame);
        float yDistance = CGRectGetMidY(itemFrame)-CGRectGetMidY(parentFrame);

        float angle = atan2f(xDistance, -yDistance);
        
        float distance = sqrtf(xDistance*xDistance + yDistance*yDistance);
        
        CGAffineTransform transform =
        CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(CGRectGetMidX(itemFrame), CGRectGetMidY(itemFrame)), angle), -1.f, 1.f);
        
        CGFloat baseRadius = CGRectGetWidth(itemFrame)/2.f;
        CGFloat topRadius = CGRectGetWidth(parentFrame)/2.f;

        // Simple line connector
//            CGPathMoveToPoint(path, &transform, 0.f, 0.f);
//            CGPathAddLineToPoint(path, &transform, 0.f, distance);
        
        // "Squeezy" base
        CGPathMoveToPoint(path, &transform, -baseRadius, 0.f);
        CGPathAddLineToPoint(path, &transform, baseRadius, 0.f);

        // "Right" side
        for (int i=0; i<steps; i++) {
            CGFloat fraction = (CGFloat)i / (CGFloat)steps;
            CGFloat y = fraction * distance;
            CGFloat x = baseRadius + (topRadius - baseRadius) * fraction;
            x -= (sinf(fraction * M_PI) / squeezeFactor) * baseRadius;
            CGPathAddLineToPoint(path, &transform, x, y);
        }
        
        for (int i=0; i<steps; i++) {
            CGFloat fraction = (CGFloat)i / (CGFloat)steps;
            CGFloat y = (1.f - fraction) * distance;
            CGFloat x = -topRadius - (baseRadius - topRadius) * fraction;
            x += (sinf(fraction * M_PI) / squeezeFactor) * baseRadius;
            CGPathAddLineToPoint(path, &transform, x, y);
        }
        
        UIBezierPath *connectorPath = [UIBezierPath bezierPathWithCGPath:path];
        
        if (animated && item.connectorPath) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            animation.values = @[ (id)item.connectorPath.CGPath, (id)connectorPath.CGPath ];
            animation.duration = animationDuration;
            [item.connectorLayer addAnimation:animation forKey:@"path"];
        }
        
        item.connectorLayer.path = path;

        item.connectorPath = connectorPath;
        
        [connectorLayers addObject:item.connectorLayer];
    }

    self.layer.sublayers = [connectorLayers arrayByAddingObjectsFromArray:contentLayers];
}

@end
