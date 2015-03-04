//
//  CMGuidedSearchStepView.m
//  Masterbatches
//
//  Created by Craig on 18/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMSteppedProgressView.h"
#import "ClariantColors.h"

@interface CMStepLayer : CAGradientLayer

@property (nonatomic, retain) CALayer *completeLayer;

@end

@implementation CMStepLayer

@end

@interface CMSteppedProgressView ()

@property (nonatomic, retain) CAGradientLayer *trackUntilActiveLayer;
@property (nonatomic, retain) CALayer *trackFromActiveLayer;
@property (nonatomic, retain) CALayer *stepsLayer;

@end

@implementation CMSteppedProgressView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return (self = [super initWithCoder:aDecoder]) ? [self commonInit] : nil;
}

- (id)initWithFrame:(CGRect)frame
{
    return (self = [super initWithFrame:frame]) ? [self commonInit] : nil;
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
    _completedCount = MIN(completedCount, self.stepCount);
    [self setNeedsLayout];
}

- (void)setContractionFactor:(CGFloat)contractionFactor
{
    [self setContractionFactor:contractionFactor animated:NO];
}

- (void)setContractionFactor:(CGFloat)contractionFactor animated:(BOOL)animated
{
    _contractionFactor = contractionFactor;
    [self updateLayersAnimated:animated];
}

- (void)layoutSubviews
{
    [self updateLayers];
}

- (void)updateLayers
{
    [self updateLayersAnimated:YES];
}

- (void)updateLayersAnimated:(BOOL)animated
{
    static const CGFloat borderWidth = 2.f;
    static const CGFloat stepIncompleteScale = 0.8f;
    static const CGFloat stepIncompleteContentScale = 0.01f;
    static const CGFloat animationSpeed = 0.3f;

    if (self.stepCount == 0) {
        self.stepsLayer.opacity = 0.f;
        self.trackUntilActiveLayer.opacity = 0.f;
        self.trackFromActiveLayer.opacity = 0.f;
        return;
    }

    [CATransaction begin];

    if (animated) {
        [CATransaction setValue:@(animationSpeed) forKey:kCATransactionAnimationDuration];
    } else {
        [CATransaction setValue:@(YES) forKey:kCATransactionDisableActions];
    }

    CGRect bounds = self.bounds;

    if (self.stepCount == 1) {
        bounds = CGRectMake(CGRectGetMidX(bounds)-CGRectGetHeight(bounds)/2.f,
                            CGRectGetMinY(bounds),
                            CGRectGetHeight(bounds),
                            CGRectGetHeight(bounds));
    } else
        if (self.contractionFactor > 0.f) {
            CGFloat contractedWidth = CGRectGetWidth(bounds) - (CGRectGetWidth(bounds) * self.contractionFactor);
            bounds = CGRectMake(CGRectGetMidX(bounds)-contractedWidth/2.f,
                                CGRectGetMinY(bounds),
                                contractedWidth,
                                CGRectGetHeight(bounds));
        }

    CGFloat stepSize = CGRectGetHeight(self.bounds);

    CGFloat stepWidth = (CGRectGetWidth(bounds)/(CGFloat)self.stepCount);

    if (!self.trackUntilActiveLayer) {
        self.trackUntilActiveLayer = [CAGradientLayer layer];
        self.trackUntilActiveLayer.colors = @[ (id)[UIColor colorWithRed:0.396 green:0.811 blue:0.913 alpha:1].CGColor,
                                    (id)[UIColor colorWithRed:0.458 green:0.721 blue:0.286 alpha:1].CGColor ];
        self.trackUntilActiveLayer.startPoint = CGPointMake(0.f, 0.5f);
        self.trackUntilActiveLayer.endPoint = CGPointMake(1.f, 0.5f);
        self.trackUntilActiveLayer.anchorPoint = CGPointMake(0.f, 0.5f);
        [self.layer addSublayer:self.trackUntilActiveLayer];
    } else {
        self.trackUntilActiveLayer.opacity = 1.f;
    }
    
    if (!self.trackFromActiveLayer) {
        self.trackFromActiveLayer = [CALayer layer];
        self.trackFromActiveLayer.backgroundColor = [ClariantColors silver20Color].CGColor;
        self.trackFromActiveLayer.anchorPoint = CGPointMake(1.f, 0.5f);
        [self.layer addSublayer:self.trackFromActiveLayer];
    } else {
        self.trackFromActiveLayer.opacity = 1.f;
    }

    CGFloat trackHeight = CGRectGetHeight(bounds) / 5.f;

    self.trackUntilActiveLayer.bounds = CGRectMake(0.f, 0.f, fminf((CGFloat)self.completedCount, -1.f+(CGFloat)self.stepCount)*stepWidth, trackHeight);
    self.trackUntilActiveLayer.position = CGPointMake(CGRectGetMinX(bounds) + stepWidth/2.f, CGRectGetMidY(bounds));
    self.trackUntilActiveLayer.cornerRadius = trackHeight/2.f;
    self.trackUntilActiveLayer.endPoint = CGPointMake(fminf(1.f / ((CGFloat)self.completedCount/(CGFloat)self.stepCount), 100.f), 0.5f);
    
    self.trackFromActiveLayer.bounds = CGRectMake(0.f, 0.f, fmaxf((self.stepCount-self.completedCount)*stepWidth - stepWidth, 0.f), trackHeight/2.f);
    self.trackFromActiveLayer.position = CGPointMake(CGRectGetMaxX(bounds) - stepWidth/2.f, CGRectGetMidY(bounds));

    if (!self.stepsLayer) {
        self.stepsLayer = [CALayer layer];
        [self.layer addSublayer:self.stepsLayer];
    } else {
        self.stepsLayer.opacity = 1.f;
    }

    self.stepsLayer.bounds = bounds;
    self.stepsLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));

    for (NSUInteger i=0; i<self.stepCount; i++) {

        BOOL newStepLayer = NO;

        CMStepLayer *stepLayer = nil;
        if (i < self.stepsLayer.sublayers.count) {
            stepLayer = self.stepsLayer.sublayers[i];
        } else {
            newStepLayer = YES;
            stepLayer = [CMStepLayer layer];
            stepLayer.completeLayer = [CALayer layer];
            stepLayer.completeLayer.contents = (__bridge id)([UIImage imageNamed:@"ic_pagination_checkmark_light.png"].CGImage);
            stepLayer.completeLayer.transform = CATransform3DMakeScale(stepIncompleteContentScale, stepIncompleteContentScale, stepIncompleteContentScale);
            [stepLayer addSublayer:stepLayer.completeLayer];
            [self.stepsLayer addSublayer:stepLayer];
        }

        BOOL stepCompleted = (self.completedCount > i);
        BOOL stepActive = (i == self.completedCount);
        
        stepLayer.cornerRadius = stepSize/2.f;

        stepLayer.bounds = CGRectMake(0.f, 0.f, stepSize, stepSize);
        stepLayer.position = CGPointMake(
                                CGRectGetMinX(bounds) + stepWidth*i + stepWidth/2.f,
                                CGRectGetHeight(bounds)/2.f);

        if (stepCompleted || stepActive) {
            CGRect stepFrame = [self.layer convertRect:stepLayer.bounds fromLayer:stepLayer];
            CGRect trackFrame = CGRectUnion([self.layer convertRect:self.trackUntilActiveLayer.bounds fromLayer:self.trackUntilActiveLayer],
                                            [self.layer convertRect:self.trackFromActiveLayer.bounds fromLayer:self.trackFromActiveLayer]);

            CGFloat unitsLeft  = (CGRectGetMinX(stepFrame)-CGRectGetMinX(trackFrame)) / CGRectGetWidth(stepFrame);
            CGFloat unitsRight = (CGRectGetMaxX(trackFrame)-CGRectGetMaxX(stepFrame)) / CGRectGetWidth(stepFrame);

            stepLayer.colors = self.trackUntilActiveLayer.colors;
            stepLayer.startPoint = CGPointMake(-unitsLeft, 0.5f);
            stepLayer.endPoint = CGPointMake(1.f+unitsRight, 0.5f);
        } else {
            stepLayer.colors = @[ (id)[ClariantColors silver20Color].CGColor, (id)[ClariantColors silver20Color].CGColor, ];
        }

        stepLayer.completeLayer.backgroundColor = (stepCompleted
                                                   ? [UIColor clearColor]
                                                   : (stepActive ? [UIColor whiteColor] : [UIColor whiteColor])).CGColor;
        
        stepLayer.completeLayer.bounds = CGRectInset(stepLayer.bounds, borderWidth, borderWidth);
        stepLayer.completeLayer.cornerRadius = CGRectGetHeight(stepLayer.completeLayer.bounds)/2.f;
        stepLayer.completeLayer.position = CGPointMake(CGRectGetMidX(stepLayer.bounds), CGRectGetMidY(stepLayer.bounds));

        CGFloat contentScale = (stepCompleted || stepActive) ? 1.f : stepIncompleteContentScale;
        stepLayer.completeLayer.transform = CATransform3DMakeScale(contentScale, contentScale, 1.f);

        CGFloat stepScale = (stepCompleted || stepActive) ? 1.f : stepIncompleteScale;
        stepLayer.transform = CATransform3DMakeScale(stepScale, stepScale, 1.f);
    }
    
    while (self.stepsLayer.sublayers.count > self.stepCount) {
        [self.stepsLayer.sublayers.lastObject removeFromSuperlayer];
    }
    
//    self.layer.opacity = sqrtf(1.f - self.contractionFactor);
    
    [CATransaction commit];
}

@end
