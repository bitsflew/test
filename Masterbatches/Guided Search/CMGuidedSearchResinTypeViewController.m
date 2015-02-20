//
//  CMGuidedSearchResinTypeViewController.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchResinTypeViewController.h"
#import "CMGuidedSearchProductTypeViewController.h"

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
    
    self.gridSelectionView.contentInset = UIEdgeInsetsMake(48.f, 0.f, 0.f, 0.f);
    self.gridSelectionView.scrollIndicatorInsets = self.gridSelectionView.contentInset;
    self.gridSelectionView.allowsMultipleSelection = YES;
    
    self.gridSelectionView.items =
    @[ [CMProductSpecificationResin resinWithName:@"PP"],
       [CMProductSpecificationResin resinWithName:@"PE"],
       [CMProductSpecificationResin resinWithName:@"PS"],
       [CMProductSpecificationResin resinWithName:@"PA"],
       [CMProductSpecificationResin resinWithName:@"POM"],
       [CMProductSpecificationResin resinWithName:@"ABS"],
       [CMProductSpecificationResin resinWithName:@"PC"],
       [CMProductSpecificationResin resinWithName:@"EVA"],
       [CMProductSpecificationResin resinWithName:@"PVC"],
       [CMProductSpecificationResin resinWithName:@"TPU"],
       [CMProductSpecificationResin resinWithName:@"PET"],
       [CMProductSpecificationResin resinWithName:@"PEEK"],
       [CMProductSpecificationResin resinWithName:@"TPO"],
       [CMProductSpecificationResin resinWithName:@"PLA"] ];

    [self.gridSelectionView selectItems:self.step.productSpecification.resins animated:YES];
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
    self.step.productSpecification.resins = self.gridSelectionView.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

- (void)guidedSearchGrid:(CMGuidedSearchGrid*)guidedSearchGrid didDeselectItem:(id<CMGuidedSearchGridItem>)item
{
    self.step.productSpecification.resins = self.gridSelectionView.selectedItems;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}


@end
