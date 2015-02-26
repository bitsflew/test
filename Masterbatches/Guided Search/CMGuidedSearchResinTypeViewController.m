//
//  CMGuidedSearchResinTypeViewController.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchResinTypeViewController.h"

@interface CMProductSpecificationResin (Item) <CMGuidedSearchGridItem>

@end

@implementation CMProductSpecificationResin (Item)

- (NSString*)title
{
    return self.name;
}

@end

@interface CMGuidedSearchResinTypeViewController ()

@end

@implementation CMGuidedSearchResinTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.grid.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.grid.scrollIndicatorInsets = self.grid.contentInset;
    self.grid.allowsMultipleSelection = YES;
    
    self.grid.items =
    @[ [CMProductSpecificationResin attributeWithName:@"PP"],
       [CMProductSpecificationResin attributeWithName:@"PE"],
       [CMProductSpecificationResin attributeWithName:@"PS"],
       [CMProductSpecificationResin attributeWithName:@"PA"],
       [CMProductSpecificationResin attributeWithName:@"POM"],
       [CMProductSpecificationResin attributeWithName:@"ABS"],
       [CMProductSpecificationResin attributeWithName:@"PC"],
       [CMProductSpecificationResin attributeWithName:@"EVA"],
       [CMProductSpecificationResin attributeWithName:@"PVC"],
       [CMProductSpecificationResin attributeWithName:@"TPU"],
       [CMProductSpecificationResin attributeWithName:@"PET"],
       [CMProductSpecificationResin attributeWithName:@"PEEK"],
       [CMProductSpecificationResin attributeWithName:@"TPO"],
       [CMProductSpecificationResin attributeWithName:@"PLA"] ];

    [self.grid selectItems:self.step.productSpecification.resins animated:YES];
}

- (BOOL)completeStepWithValidationError:(NSString *__autoreleasing *)errorDescription
{
    if (self.step.productSpecification.resins.count == 0) {
        *errorDescription = NSLocalizedString(@"MustSpecifyResin", nil);
        return NO;
    }

    return YES;
}

#pragma mark -

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didSelectItem:(id<CMGuidedSearchGridItem>)item
{
    self.step.productSpecification.resins = self.grid.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didDeselectItem:(id<CMGuidedSearchGridItem>)item
{
    self.step.productSpecification.resins = self.grid.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

@end
