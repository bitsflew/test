//
//  CMGuidedSearchAdditiveFunctionalityViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditiveFunctionalityViewController.h"
#import "CMGuidedSearchResinTypeViewController.h"

@interface CMProductSpecificationAdditive (Item) <CMGuidedSearchGridItem>

@end

@implementation CMProductSpecificationAdditive (Item)

- (NSString*)title
{
    return self.name;
}

@end

@interface CMGuidedSearchAdditiveFunctionalityViewController ()

@end

@implementation CMGuidedSearchAdditiveFunctionalityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridSelectionView.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.gridSelectionView.scrollIndicatorInsets = self.gridSelectionView.contentInset;

    self.gridSelectionView.items =
    @[ [CMProductSpecificationAdditive additiveWithName:@"Absorbents"],
       [CMProductSpecificationAdditive additiveWithName:@"Anti-blocking"],
       [CMProductSpecificationAdditive additiveWithName:@"Anti-fog"],
       [CMProductSpecificationAdditive additiveWithName:@"Anti-microbial"],
       [CMProductSpecificationAdditive additiveWithName:@"Anti-oxidant"],
       [CMProductSpecificationAdditive additiveWithName:@"Anti-slip"],
       [CMProductSpecificationAdditive additiveWithName:@"Anti-static"],
       [CMProductSpecificationAdditive additiveWithName:@"Biodegradable"],
       [CMProductSpecificationAdditive additiveWithName:@"Blowing agent"],
       [CMProductSpecificationAdditive additiveWithName:@"Cleaning agent"],
       [CMProductSpecificationAdditive additiveWithName:@"Compatibilizer"],
       [CMProductSpecificationAdditive additiveWithName:@"Conductive"],
       [CMProductSpecificationAdditive additiveWithName:@"Corrosion protection"],
       [CMProductSpecificationAdditive additiveWithName:@"Drying agent"],
       [CMProductSpecificationAdditive additiveWithName:@"Filler"],
       [CMProductSpecificationAdditive additiveWithName:@"Flame retardent"],
       [CMProductSpecificationAdditive additiveWithName:@"Laser marking"],
       [CMProductSpecificationAdditive additiveWithName:@"Light stabilizer"],
       [CMProductSpecificationAdditive additiveWithName:@"Lubricant"],
       [CMProductSpecificationAdditive additiveWithName:@"Matting agent"],
       [CMProductSpecificationAdditive additiveWithName:@"Mould release"],
       [CMProductSpecificationAdditive additiveWithName:@"Nucleating"],
       [CMProductSpecificationAdditive additiveWithName:@"Opacifier"],
       [CMProductSpecificationAdditive additiveWithName:@"Optical brightner"],
       [CMProductSpecificationAdditive additiveWithName:@"Other"],
       [CMProductSpecificationAdditive additiveWithName:@"Photo degradable"],
       [CMProductSpecificationAdditive additiveWithName:@"Process support"],
       [CMProductSpecificationAdditive additiveWithName:@"PV-stabilizer"] ];

    [self.gridSelectionView selectItems:self.step.productSpecification.additives animated:YES];
}

- (BOOL)completeStepWithValidationError:(NSString**)errorDescription
{
    if (self.step.productSpecification.additives.count == 0) {
        *errorDescription = NSLocalizedString(@"MustSpecifyAdditive", nil);
        return NO;
    }

    return YES;
}

#pragma mark -

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didSelectItem:(id<CMGuidedSearchGridItem>)item
{
    self.step.productSpecification.additives = self.gridSelectionView.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didDeselectItem:(id<CMGuidedSearchGridItem>)item
{
    self.step.productSpecification.additives = self.gridSelectionView.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

@end
