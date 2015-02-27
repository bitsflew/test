//
//  CMGuidedSearchProductRegulatoryIndustryViewController.m
//  MB Sales
//
//  Created by Craig on 26/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchProductRegulatoryIndustryViewController.h"
#import "CMProductSpecification+GridItem.h"

@interface CMGuidedSearchProductRegulatoryIndustryViewController ()

@end

@implementation CMGuidedSearchProductRegulatoryIndustryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    
    self.productGridHeightConstraint.constant = 0.f;
    self.productGrid.items =
      @[ [CMProductSpecificationProductType attributeWithName:@"Master Batch pellet"],
         [CMProductSpecificationProductType attributeWithName:@"Compound"],
         [CMProductSpecificationProductType attributeWithName:@"Liquid"] ];
    if (self.step.productSpecification.productType) {
        [self.productGrid selectItems:@[ self.step.productSpecification.productType ] animated:NO];
    }

    self.regulatoryGridHeightConstraint.constant = 0.f;
    self.regulatoryGrid.allowsMultipleSelection = YES;
    self.regulatoryGrid.items =
      @[ [CMProductSpecificationRegulatoryType attributeWithName:@"Food contact"],
         [CMProductSpecificationRegulatoryType attributeWithName:@"REACH (EU only)"],
         [CMProductSpecificationRegulatoryType attributeWithName:@"Medical"],
         [CMProductSpecificationRegulatoryType attributeWithName:@"NSF"] ];
    [self.regulatoryGrid selectItems:self.step.productSpecification.regulatoryTypes animated:NO];
    
    self.industryGridHeightConstraint.constant = 0.f;
    self.industryGrid.items =
      @[ [CMProductSpecificationIndustryType attributeWithName:@"Transportation"],
         [CMProductSpecificationIndustryType attributeWithName:@"Packaging"],
         [CMProductSpecificationIndustryType attributeWithName:@"MRP"],
         [CMProductSpecificationIndustryType attributeWithName:@"Consumer Goods"],
         [CMProductSpecificationIndustryType attributeWithName:@"Medical & Pharma."],
         [CMProductSpecificationIndustryType attributeWithName:@"Fibers"] ];
    if (self.step.productSpecification.industryType) {
        [self.industryGrid selectItems:@[ self.step.productSpecification.industryType ] animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.3f animations:^{
        self.productGridHeightConstraint.constant = self.productGrid.contentSize.height;
        self.industryGridHeightConstraint.constant = self.industryGrid.contentSize.height;
        self.regulatoryGridHeightConstraint.constant = self.regulatoryGrid.contentSize.height;
                [self.view layoutIfNeeded];
    }];
}

#pragma mark -

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item
{
    if (gridView == self.productGrid) {
        self.step.productSpecification.productType = item;
    } else
        if (gridView == self.regulatoryGrid) {
            self.step.productSpecification.regulatoryTypes = gridView.selectedItems;
        } else
        if (gridView == self.industryGrid) {
            self.step.productSpecification.industryType = item;
        } else {
            return;
        }

    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

- (void)gridView:(CMGridView*)gridView didDeselectItem:(id<CMGridItem>)item
{
    if (gridView == self.regulatoryGrid) {
        self.step.productSpecification.regulatoryTypes = gridView.selectedItems;
    } else {
        return;
    }

    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];

}


@end
