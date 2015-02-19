//
//  CMGuidedSearchStepView.m
//  Masterbatches
//
//  Created by Craig on 18/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchStepView.h"

@interface CMStepLayer : CALayer

@property (nonatomic, retain) CALayer *completeLayer;

@end

@implementation CMStepLayer

@end

@interface CMGuidedSearchStepView ()

@property (nonatomic, retain) CAGradientLayer *trackLayer;
@property (nonatomic, retain) CALayer *stepsLayer;

@end

@implementation CMGuidedSearchStepView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder] ? [self commonInit] : nil;
}

- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame] ? [self commonInit] : nil;
}

- (id)commonInit
{
    self.stepCount = 5;
    self.completedCount = 1;
    return self;
}

- (void)setStepCount:(NSUInteger)stepCount
{
    _stepCount = stepCount;
    [self setNeedsLayout];
}

- (void)setCompletedCount:(NSUInteger)completedCount
{
    _completedCount = completedCount;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [self updateLayers];
}

- (void)updateLayers
{
    static const CGFloat borderWidth = 2.f;
    static const CGFloat stepIncompleteScale = 0.8f;
    static const CGFloat stepIncompleteContentScale = 0.1f;

    if (self.stepCount == 0) {
        self.stepsLayer.opacity = 0.f;
        self.trackLayer.opacity = 0.f;
        return;
    }

    [CATransaction begin];
    [CATransaction setValue:@(.3f) forKey:kCATransactionAnimationDuration];

    CGRect bounds = self.bounds;
    
    if (self.stepCount == 1) {
        bounds = CGRectMake(CGRectGetMidX(bounds)-CGRectGetHeight(bounds)/2.f,
                            0.f,
                            CGRectGetHeight(bounds),
                            CGRectGetHeight(bounds));
    }
    
    CGFloat stepWidth = (CGRectGetWidth(bounds)/(CGFloat)self.stepCount);

    if (!self.trackLayer) {
        self.trackLayer = [CAGradientLayer layer];
        self.trackLayer.colors = @[ (id)[UIColor colorWithRed:0.396 green:0.811 blue:0.913 alpha:1].CGColor,
                                    (id)[UIColor colorWithRed:0.458 green:0.721 blue:0.286 alpha:1].CGColor ];
        self.trackLayer.startPoint = CGPointMake(0.f, 0.3f);
        self.trackLayer.endPoint = CGPointMake(1.f, 0.7f);
        [self.layer addSublayer:self.trackLayer];
    } else {
        self.trackLayer.opacity = 1.f;
    }

    CGFloat trackHeight = CGRectGetHeight(bounds) / 10.f;
    self.trackLayer.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(bounds) - stepWidth, trackHeight);
    self.trackLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    self.trackLayer.cornerRadius = trackHeight/2.f;
    
    if (!self.stepsLayer) {
        self.stepsLayer = [CALayer layer];
        [self.layer addSublayer:self.stepsLayer];
    } else {
        self.stepsLayer.opacity = 1.f;
    }

    self.stepsLayer.bounds = bounds;
    self.stepsLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));

    for (int i=0; i<self.stepCount; i++) {
        BOOL newStepLayer = NO;
        CMStepLayer *stepLayer = nil;
        if (i < self.stepsLayer.sublayers.count) {
            stepLayer = self.stepsLayer.sublayers[i];
            [stepLayer addSublayer:stepLayer.completeLayer];
        } else {
            newStepLayer = YES;
            stepLayer = [CMStepLayer layer];
            stepLayer.completeLayer = [CALayer layer];
            stepLayer.completeLayer.contents = (__bridge id)([UIImage imageNamed:@"ic_pagination_checkmark_light.png"].CGImage);
            stepLayer.completeLayer.transform = CATransform3DMakeScale(stepIncompleteContentScale, stepIncompleteContentScale, stepIncompleteContentScale);
            [self.stepsLayer addSublayer:stepLayer];
        }

        BOOL stepCompleted = (self.completedCount > i);
        BOOL stepActive = (i == self.completedCount);
        CGFloat stepSize = CGRectGetHeight(bounds) * ((stepCompleted || stepActive) ? 1.f : stepIncompleteScale);

        stepLayer.backgroundColor = (stepCompleted ? [UIColor colorWithRed:0.38 green:0.803 blue:0.909 alpha:1] : [UIColor whiteColor]).CGColor;\
        stepLayer.borderWidth = (stepCompleted || stepActive) ? borderWidth : (borderWidth/2.f);
        stepLayer.borderColor = ((stepCompleted || stepActive) ? [UIColor colorWithRed:0.38 green:0.803 blue:0.909 alpha:1] : [UIColor lightGrayColor]).CGColor;
        stepLayer.bounds = CGRectMake(0.f, 0.f, stepSize, stepSize);
        stepLayer.position = CGPointMake(
                                CGRectGetMinX(bounds) + stepWidth*i + stepWidth/2.f,
                                CGRectGetHeight(bounds)/2.f);
        stepLayer.cornerRadius = stepSize/2.f;
        
        stepLayer.completeLayer.bounds = CGRectInset(stepLayer.bounds, borderWidth, borderWidth);
        stepLayer.completeLayer.position = CGPointMake(CGRectGetMidX(stepLayer.bounds), CGRectGetMidY(stepLayer.bounds));
        CGFloat contentScale = stepCompleted ? 1.f : stepIncompleteContentScale;
        stepLayer.completeLayer.transform = CATransform3DMakeScale(contentScale, contentScale, contentScale);
    }
    
    [CATransaction commit];
}

@end
