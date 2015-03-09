//
//  ClariantColors.m
//  Masterbatches
//
//  Created by Berik Visschers on 02-19.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "ClariantColors.h"

@implementation ClariantColors

+ (UIColor *)menuBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)menuLineColor {
    return [UIColor colorWithWhite:0.8 alpha:1];
}

+ (UIColor *)menuMainCircleColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient.png"]];
}

+ (UIColor *)menuBackCircleColor {
    return [UIColor colorWithWhite:0.2 alpha:1];
}

+ (UIColor *)menuDefaultCircleColor {
    return [UIColor colorWithWhite:0.5 alpha:1];
}

+ (UIColor *)menuMainFontColor {
    return [UIColor colorWithWhite:0.2 alpha:1];
}

+ (UIColor *)menuBackFontColor {
    return [UIColor colorWithWhite:0.4 alpha:1];
}

+ (UIColor *)menuDefaultFontColor {
    return [UIColor colorWithWhite:0.4 alpha:1];
}

+ (UIColor*)silver20Color {
    return [UIColor colorWithRed:0.819 green:0.823 blue:0.831 alpha:1];
}

+ (UIColor*)blueColor {
    return [UIColor colorWithRed:0.431 green:0.811 blue:0.901 alpha:1];
}


@end
