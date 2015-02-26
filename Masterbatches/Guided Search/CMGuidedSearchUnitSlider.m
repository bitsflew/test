//
//  CMGuidedSearchUnitSlider.m
//  MB Sales
//
//  Created by Craig on 26/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchUnitSlider.h"

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

    return self;
}


@end
