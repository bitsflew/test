//
//  CMGuidedSearchAdditiveFunctionalityViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditiveFunctionalityViewController.h"
#import "CMProductSpecification+GridItem.h"

@interface CMGuidedSearchAdditiveFunctionalityViewController () <UIAlertViewDelegate>

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
           [CMProductSpecificationAdditive attributeWithName:@"Cleaning agent"],
           [CMProductSpecificationAdditive attributeWithName:@"Compatibilizer"],
           [CMProductSpecificationAdditive attributeWithName:@"Conductive"],
           [CMProductSpecificationAdditive attributeWithName:@"Corrosion protection"],
           [CMProductSpecificationAdditive attributeWithName:@"Drying agent"],
           [CMProductSpecificationAdditive attributeWithName:@"Filler"],
           [CMProductSpecificationAdditive attributeWithName:@"Flame retardant"],
           [CMProductSpecificationAdditive attributeWithName:@"Laser marking"],
           [CMProductSpecificationAdditive attributeWithName:@"Light stabilizer"],
           [CMProductSpecificationAdditive attributeWithName:@"Lubricant"],
           [CMProductSpecificationAdditive attributeWithName:@"Matting agent"],
           [CMProductSpecificationAdditive attributeWithName:@"Mold release"],
           [CMProductSpecificationAdditive attributeWithName:@"Nucleating"],
           [CMProductSpecificationAdditive attributeWithName:@"Opacifier"],
           [CMProductSpecificationAdditive attributeWithName:@"Optical brightner"],
           [CMProductSpecificationAdditive attributeWithName:@"Other"],
           [CMProductSpecificationAdditive attributeWithName:@"Photo degradable"],
           [CMProductSpecificationAdditive attributeWithName:@"Processing aid"],
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
    if ([self.step.productSpecification hasAdditionalQuestionValues]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Additive questions"
                                                            message:@"You've already filled in information for the previously selected additive functionality. Are you sure you want to discard your answers?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Discard", nil];
        [alertView show];
        return;
    }

    [self setStepSelection];
}

#pragma mark -

- (void)setStepSelection
{
    [self.step.productSpecification removeAllAdditionalQuestionValues];
    self.step.productSpecification.additives = self.grid.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self.grid selectItems:self.step.productSpecification.additives animated:YES];
        return;
    }

    [self setStepSelection];
}


@end
