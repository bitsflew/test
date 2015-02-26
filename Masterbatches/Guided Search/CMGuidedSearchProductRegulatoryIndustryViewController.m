//
//  CMGuidedSearchProductRegulatoryIndustryViewController.m
//  MB Sales
//
//  Created by Craig on 26/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchProductRegulatoryIndustryViewController.h"

@interface CMGuidedSearchProductRegulatoryIndustryViewController ()

@end

@interface CMProductSpecificationSimpleNamedAttribute (Grid)

- (NSString*)title;

@end

@implementation CMProductSpecificationSimpleNamedAttribute (Grid)

- (NSString*)title
{
    return self.name;
}

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

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didSelectItem:(id<CMGuidedSearchGridItem>)item
{
    if (guidedSearchGrid == self.productGrid) {
        self.step.productSpecification.productType = item;
    } else
        if (guidedSearchGrid == self.regulatoryGrid) {
            self.step.productSpecification.regulatoryTypes = guidedSearchGrid.selectedItems;
        } else
        if (guidedSearchGrid == self.industryGrid) {
            self.step.productSpecification.industryType = item;
        } else {
            return;
        }

    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didDeselectItem:(id<CMGuidedSearchGridItem>)item
{
    if (guidedSearchGrid == self.regulatoryGrid) {
        self.step.productSpecification.regulatoryTypes = guidedSearchGrid.selectedItems;
    } else {
        return;
    }

    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];

}


@end
