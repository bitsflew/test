//
//  CMGuidedSearchAdditiveFunctionalityViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditiveFunctionalityViewController.h"
#import "CMProductSpecification+GridItem.h"

@interface CMGuidedSearchAdditiveFunctionalityViewController ()

@end

@implementation CMGuidedSearchAdditiveFunctionalityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.grid.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.grid.scrollIndicatorInsets = self.grid.contentInset;

    self.grid.items =
        @[ [CMProductSpecificationAdditive attributeWithName:@"Absorbents"],
           [CMProductSpecificationAdditive attributeWithName:@"Anti-blocking"],
           [CMProductSpecificationAdditive attributeWithName:@"Anti-fog"],
           [CMProductSpecificationAdditive attributeWithName:@"Anti-microbial"],
           [CMProductSpecificationAdditive attributeWithName:@"Anti-oxidant"],
           [CMProductSpecificationAdditive attributeWithName:@"Anti-slip"],
           [CMProductSpecificationAdditive attributeWithName:@"Anti-static"],
           [CMProductSpecificationAdditive attributeWithName:@"Biodegradable"],
           [CMProductSpecificationAdditive attributeWithName:@"Blowing agent"],
           [CMProductSpecificationAdditive attributeWithName:@"Cleaning agent"],
           [CMProductSpecificationAdditive attributeWithName:@"Compatibilizer"],
           [CMProductSpecificationAdditive attributeWithName:@"Conductive"],
           [CMProductSpecificationAdditive attributeWithName:@"Corrosion protection"],
           [CMProductSpecificationAdditive attributeWithName:@"Drying agent"],
           [CMProductSpecificationAdditive attributeWithName:@"Filler"],
           [CMProductSpecificationAdditive attributeWithName:@"Flame retardent"],
           [CMProductSpecificationAdditive attributeWithName:@"Laser marking"],
           [CMProductSpecificationAdditive attributeWithName:@"Light stabilizer"],
           [CMProductSpecificationAdditive attributeWithName:@"Lubricant"],
           [CMProductSpecificationAdditive attributeWithName:@"Matting agent"],
           [CMProductSpecificationAdditive attributeWithName:@"Mould release"],
           [CMProductSpecificationAdditive attributeWithName:@"Nucleating"],
           [CMProductSpecificationAdditive attributeWithName:@"Opacifier"],
           [CMProductSpecificationAdditive attributeWithName:@"Optical brightner"],
           [CMProductSpecificationAdditive attributeWithName:@"Other"],
           [CMProductSpecificationAdditive attributeWithName:@"Photo degradable"],
           [CMProductSpecificationAdditive attributeWithName:@"Process support"],
           [CMProductSpecificationAdditive attributeWithName:@"PV-stabilizer"] ];

    [self.grid selectItems:self.step.productSpecification.additives animated:YES];
}

- (BOOL)completeStepWithValidationError:(NSString**)errorDescription
{
    if (![self.stepDelegate flowForStepViewController:self].projectRequest) {
        return YES;
    }

    if (self.step.productSpecification.additives.count == 0) {
        *errorDescription = NSLocalizedString(@"MustSpecifyAdditive", nil);
        return NO;
    }

    return YES;
}

#pragma mark -

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item
{
    self.step.productSpecification.additives = self.grid.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

- (void)gridView:(CMGridView *)gridView didDeselectItem:(id<CMGridItem>)item
{
    self.step.productSpecification.additives = self.grid.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

@end
