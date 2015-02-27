//
//  CMGuidedSearchColorViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchColorViewController.h"

@interface CMGuidedSearchColorViewController ()

@end

@interface CMProductSpecificationColor (GridItem) <CMGridItem>

@end

@implementation CMProductSpecificationColor (GridItem)

- (UIColor*)fillColor
{
    return self.color;
}

- (UIColor*)titleColor
{
    CGFloat hue, saturation, brightness;
    if ([self.fillColor getHue:&hue saturation:&saturation brightness:&brightness alpha:NULL]) {
        
        NSLog(@"%f : %f : %f", hue, saturation, brightness);
        
        if (((brightness > 0.9f) && (saturation < 0.1f)) || ((brightness > 0.9f) && (hue > 0.1f) && (hue < 1.f)) || (((brightness > 0.7f) && (hue > 0.12f)) && !((brightness > 0.9f) && (saturation > 0.9f)))) {
            return [UIColor blackColor];
        }
    }
    return [UIColor whiteColor];
}

- (BOOL)centerTitle
{
    return YES;
}

@end

@implementation CMGuidedSearchColorViewController

- (void)viewDidLoad
{
    self.colorGridView.items = @[ [CMProductSpecificationColor attributeWithName:@"White"
                                                                           color:[UIColor whiteColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Silver"
                                                                           color:[UIColor lightGrayColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Grey"
                                                                           color:[UIColor grayColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Black"
                                                                           color:[UIColor blackColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Yellow"
                                                                           color:[UIColor yellowColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Orange"
                                                                           color:[UIColor orangeColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Red"
                                                                           color:[UIColor redColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Violet"
                                                                           color:[UIColor purpleColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Blue"
                                                                           color:[UIColor colorWithRed:0.396 green:0.811 blue:0.913 alpha:1]],
                                  [CMProductSpecificationColor attributeWithName:@"Green"
                                                                           color:[UIColor greenColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Brown"
                                                                           color:[UIColor brownColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Bronze"
                                                                           color:[UIColor colorWithRed:0.443 green:0.274 blue:0.043 alpha:1]],
                                  [CMProductSpecificationColor attributeWithName:@"Gold"
                                                                           color:[UIColor colorWithRed:0.937 green:0.803 blue:0 alpha:1]],
                                  [CMProductSpecificationColor attributeWithName:@"Copper"
                                                                           color:[UIColor colorWithRed:0.725 green:0.541 blue:0 alpha:1]] ];
}

@end
