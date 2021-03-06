//
//  CMGuidedSearchRegulatoryIndustryViewController.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchProductTypeViewController.h"
#import "CMProductSpecification+GridItem.h"

@interface CMGuidedSearchProductTypeViewController ()

@end

@implementation CMGuidedSearchProductTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.grid.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.grid.scrollIndicatorInsets = self.grid.contentInset;

    self.grid.items =
      @[ [CMProductSpecificationProductType attributeWithName:@"Master Batch pellet"],
         [CMProductSpecificationProductType attributeWithName:@"Compound"],
         [CMProductSpecificationProductType attributeWithName:@"Liquid"] ];

    if (self.step.productSpecification.productType) {
        [self.grid selectItems:@[ self.step.productSpecification.productType ] animated:YES];
    }
}

- (BOOL)completeStepWithValidationError:(NSString**)errorDescription
{
    if (!self.step.productSpecification.productType) {
        *errorDescription = NSLocalizedString(@"MustSpecifyProductType", nil);
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item
{
    self.step.productSpecification.productType = self.grid.selectedItems.firstObject;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

- (void)gridView:(CMGridView *)gridView didDeselectItem:(id<CMGridItem>)item
{
    self.step.productSpecification.productType = nil;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

@end

