//
//  CMGuidedSearchColorViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchColorViewController.h"
#import "ClariantColors.h"

@interface CMGuidedSearchColorViewController () <CMGridViewSelectionDelegate>

@end

@interface CMProductSpecificationColor (GridItem) <CMGridItem>

@end

@implementation CMProductSpecificationColor (GridItem)

- (UIColor*)borderColorForState:(UIControlState)state
{
    if ((state & UIControlStateSelected) && [self.color isEqual:[UIColor whiteColor]]) {
        return [ClariantColors blueColor];
    }
    return self.color;
}

- (UIColor*)fillColorForState:(UIControlState)state
{
    if (state & UIControlStateSelected) {
        return self.color;
    }
    
    return [UIColor whiteColor];
}

- (UIColor*)titleColorForState:(UIControlState)state
{
    if (!(state & UIControlStateSelected)) {
        return [UIColor blackColor];
    }

    CGFloat hue, saturation, brightness;
    if ([self.color getHue:&hue saturation:&saturation brightness:&brightness alpha:NULL]) {
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
                                                                           color:[UIColor colorWithRed:0.996 green:0.937 blue:0.207 alpha:1]],
                                  [CMProductSpecificationColor attributeWithName:@"Orange"
                                                                           color:[UIColor orangeColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Red"
                                                                           color:[UIColor redColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Violet"
                                                                           color:[UIColor purpleColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Blue"
                                                                           color:[UIColor colorWithRed:0.396 green:0.811 blue:0.913 alpha:1]],
                                  [CMProductSpecificationColor attributeWithName:@"Green"
                                                                           color:[UIColor colorWithRed:0.431 green:0.729 blue:0.25 alpha:1]],
                                  [CMProductSpecificationColor attributeWithName:@"Brown"
                                                                           color:[UIColor brownColor]],
                                  [CMProductSpecificationColor attributeWithName:@"Bronze"
                                                                           color:[UIColor colorWithRed:0.443 green:0.274 blue:0.043 alpha:1]],
                                  [CMProductSpecificationColor attributeWithName:@"Gold"
                                                                           color:[UIColor colorWithRed:0.937 green:0.803 blue:0 alpha:1]],
                                  [CMProductSpecificationColor attributeWithName:@"Copper"
                                                                           color:[UIColor colorWithRed:0.725 green:0.541 blue:0 alpha:1]] ];
    
    if (self.step.productSpecification.color) {
        [self.colorGridView selectItems:@[ self.step.productSpecification.color ] animated:YES];
    }
}

#pragma mark -

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item
{
    if (gridView == self.colorGridView) {
        self.step.productSpecification.color = item;
    }
}

- (void)gridView:(CMGridView*)gridView didDeselectItem:(id<CMGridItem>)item
{
    if (gridView == self.colorGridView) {
        self.step.productSpecification.color = nil;
    }
    
    
}


@end
