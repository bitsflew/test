//
//  CMGuidedSearchUnitSlider.m
//  MB Sales
//
//  Created by Craig on 26/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchUnitSlider.h"

@interface CMGuidedSearchUnitSliderUnit : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *formatString;
@property (nonatomic) CGFloat multiplier;
@property (nonatomic) CGFloat constant;

@end

@implementation CMGuidedSearchUnitSliderUnit

- (NSString*)stringFromValue:(CGFloat)value
{
    return [NSString stringWithFormat:self.formatString, value * self.multiplier + self.constant];
}

@end

@interface CMGuidedSearchUnitSlider ()

@property (nonatomic, retain) NSMutableArray *units;
@property (nonatomic, retain) CALayer *thumbLayer;
@property (nonatomic, retain) CALayer *trackLayer;
@property (nonatomic, retain) NSMutableArray *stepLayers;

@end

@implementation CMGuidedSearchUnitSlider

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
    self.units = [NSMutableArray new];

    UIView *contentsView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                                         owner:self
                                                       options:nil].firstObject;

    contentsView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:contentsView];

    for (NSNumber *attribute in @[ @(NSLayoutAttributeLeft),
                                   @(NSLayoutAttributeTop),
                                   @(NSLayoutAttributeWidth),
                                   @(NSLayoutAttributeHeight) ]) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:contentsView
                                                         attribute:attribute.integerValue
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:attribute.integerValue
                                                        multiplier:1.f
                                                          constant:0.f]];
    }
    
    [self.thumbContainerView addGestureRecognizer:
     [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedPan:)]];
    
    UIFont *defaultSegmentFont = [UIFont fontWithName:@"Gotham-Book" size:14.f];
    UIFont *selectedSegmentFont = [UIFont fontWithName:@"Gotham-Bold" size:14.f];
    
    [self.unitSegmentedControl setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor grayColor],
                                                         NSFontAttributeName: defaultSegmentFont }
                                             forState:UIControlStateNormal];
    
    [self.unitSegmentedControl setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                                         NSFontAttributeName: selectedSegmentFont }
                                             forState:UIControlStateSelected];

    self.unitSegmentedControl.tintColor = [UIColor clearColor];

    self.thumbSize = 0.1f;
    self.minimumValue = 0.f;
    self.maximumValue = 100.f;
    self.value = 50.f;

    [self updateUnitSegments];

    return self;
}

#pragma mark -

- (void)addUnitWithName:(NSString *)name formatString:(NSString *)formatString multiplier:(CGFloat)multiplier constant:(CGFloat)constant
{
    CMGuidedSearchUnitSliderUnit *unit = [CMGuidedSearchUnitSliderUnit new];
    unit.formatString = formatString;
    unit.name = name;
    unit.multiplier = multiplier;
    unit.constant = constant;

    [self.units addObject:unit];

    [self updateUnitSegments];
    [self updateLabel];
}

#pragma mark -

- (void)setThumbSize:(CGFloat)thumbSize
{
    _thumbSize = fmaxf(fminf(thumbSize, 0.999f), 0.001f);

    [self updateLayersAnimated:NO];
}

- (void)setValue:(CGFloat)value
{
    _value = fmaxf(fminf(value, self.maximumValue), self.minimumValue);

    [self updateLabel];

    [self updateLayersAnimated:NO];
}

#pragma mark -

- (IBAction)tappedUnitSegment:(id)sender
{
    [self updateLabel];
}

- (void)recognizedPan:(UIPanGestureRecognizer*)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat thumbHeight = self.thumbSize * CGRectGetHeight(self.thumbContainerView.frame);
            CGFloat fractionalValue = 1.f - (
                                             ([recognizer locationInView:self.thumbContainerView].y - thumbHeight) /
                                             (CGRectGetHeight(self.thumbContainerView.frame) - thumbHeight*2.f)
                                            );
            self.value = self.minimumValue + fractionalValue * (self.maximumValue - self.minimumValue);
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
}

#pragma mark -

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    [self updateLayersAnimated:NO];
}

#pragma mark -

- (void)updateLabel
{
    if (self.unitSegmentedControl.selectedSegmentIndex < self.units.count) {
        self.valueLabel.text = [self.units[self.unitSegmentedControl.selectedSegmentIndex] stringFromValue:self.value];
    } else {
        static dispatch_once_t onceToken;
        static NSNumberFormatter *numberFormatter;
        dispatch_once(&onceToken, ^{
            numberFormatter = [NSNumberFormatter new];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        });
        self.valueLabel.text = [numberFormatter stringFromNumber:@(self.value)];
    }
}

- (void)updateUnitSegments
{
    for (int i=0; i<self.units.count; i++) {
        if (i < self.unitSegmentedControl.numberOfSegments) {
            [self.unitSegmentedControl setTitle:[self.units[i] name]
                              forSegmentAtIndex:i];
        } else {
            [self.unitSegmentedControl insertSegmentWithTitle:[self.units[i] name]
                                                      atIndex:i
                                                     animated:NO];
        }
    }

    while (self.unitSegmentedControl.numberOfSegments > self.units.count) {
        [self.unitSegmentedControl removeSegmentAtIndex:self.unitSegmentedControl.numberOfSegments-1
                                               animated:NO];
    }

    if (self.unitSegmentedControl.selectedSegmentIndex == UISegmentedControlNoSegment) {
        self.unitSegmentedControl.selectedSegmentIndex = 0;
    }
}

- (void)updateLayersAnimated:(BOOL)animated
{
    [CATransaction begin];

    if (!animated) {
        [CATransaction setValue:@(YES) forKey:kCATransactionDisableActions];
    }
    
    if (!self.thumbLayer) {
        self.thumbLayer = [CALayer new];
        self.thumbLayer.backgroundColor = [UIColor whiteColor].CGColor;
        self.thumbLayer.borderColor = [UIColor lightGrayColor].CGColor;
        self.thumbLayer.borderWidth = 1.f;
        [self.thumbContainerView.layer addSublayer:self.thumbLayer];
    }
    
    CGFloat thumbHeight = self.thumbSize * CGRectGetHeight(self.thumbContainerView.frame) * 2.f;
    
    CGFloat fractionalValue = ((self.maximumValue - self.minimumValue) == 0.f) ? 0.f : (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);
    
    CGFloat thumbOffset = ((-.5f - (1.f - fractionalValue)) * thumbHeight) + thumbHeight/2.f;
    
    self.thumbLayer.cornerRadius = thumbHeight/2.f;
    self.thumbLayer.frame = CGRectIntegral(CGRectMake(CGRectGetWidth(self.thumbContainerView.frame)/2.f - thumbHeight/2.f,
                                                      (1.f - fractionalValue) * CGRectGetHeight(self.thumbContainerView.frame) + thumbOffset,
                                                      thumbHeight,
                                                      thumbHeight));

    if (!self.trackLayer) {
        self.trackLayer = [CALayer new];
        self.trackLayer.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f].CGColor;
        [self.thumbContainerView.layer insertSublayer:self.trackLayer below:self.thumbLayer];
    }
    
    self.trackLayer.frame = CGRectIntegral(CGRectMake(CGRectGetWidth(self.thumbContainerView.frame)/2.f,
                                                      0.f,
                                                      1.f,
                                                      CGRectGetHeight(self.thumbContainerView.frame)));
    
    if (!self.stepLayers) {
        self.stepLayers = [NSMutableArray new];
    }

    NSInteger numberOfSteps = (NSUInteger)ceilf(1.f / self.thumbSize);

    if (numberOfSteps > 0) {
        CGFloat stepWidth = CGRectGetWidth(self.thumbContainerView.frame);
        CGFloat stepGap = CGRectGetHeight(self.thumbContainerView.frame) / (CGFloat)numberOfSteps;

        for (int i=0; i<numberOfSteps-1; i++) {
            CAGradientLayer *stepLayer;

            if (i < self.stepLayers.count) {
                stepLayer = self.stepLayers[i];
            } else {
                stepLayer = [CAGradientLayer new];
                stepLayer.colors = @[ (id)[UIColor colorWithWhite:0.9f alpha:0.f].CGColor,
                                      (id)[UIColor colorWithWhite:0.9f alpha:1.f].CGColor,
                                      (id)[UIColor colorWithWhite:0.9f alpha:1.f].CGColor,
                                      (id)[UIColor colorWithWhite:0.9f alpha:0.f].CGColor ];
                stepLayer.locations = @[ @(0.f), @(0.3f), @(0.7f), @(1.f) ];
                stepLayer.startPoint = CGPointMake(0.f, 0.5f);
                stepLayer.endPoint = CGPointMake(1.f, 0.5f);
                [self.thumbContainerView.layer insertSublayer:stepLayer below:self.thumbLayer];
                [self.stepLayers addObject:stepLayer];
            }

            stepLayer.frame = CGRectMake(0.f, roundf((i+1)*stepGap), stepWidth, 1.f);
        }
    }

    while (self.stepLayers.count > numberOfSteps + 1) {
        [self.stepLayers.lastObject removeFromSuperlayer];
    }

    [CATransaction commit];
}


@end
