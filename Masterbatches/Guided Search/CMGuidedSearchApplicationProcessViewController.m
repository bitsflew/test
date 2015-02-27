//
//  CMGuidedSearchApplicationProcessViewController.m
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchApplicationProcessViewController.h"

@interface CMGuidedSearchApplicationProcessViewController ()

@end

@implementation CMGuidedSearchApplicationProcessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.grid.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.grid.scrollIndicatorInsets = self.grid.contentInset;
    
    self.grid.items =
    @[ [CMProductSpecificationApplicationProcess attributeWithName:@"Foam"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Bottles"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Cables"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Compound"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Sheet"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Fibres"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Injection moulding high"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Injection moulding low"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Calendar"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Film"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Multi pupose"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Non defined"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Monofilaments"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Pipes"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Bopp"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Caps and closures"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Thermoforming"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Other"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Trial product"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Rotomoulding"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Extrusion"],
       [CMProductSpecificationApplicationProcess attributeWithName:@"Blowmoulding"] ];

    if (self.step.productSpecification.applicationProcess) {
        [self.grid selectItems:@[ self.step.productSpecification.applicationProcess ] animated:YES];
    }
}

- (BOOL)completeStepWithValidationError:(NSString *__autoreleasing *)errorDescription
{
    return YES;
}

#pragma mark -

- (void)gridView:(CMGridView*)gridView didSelectItem:(id<CMGridItem>)item
{
    self.step.productSpecification.applicationProcess = self.grid.selectedItems.firstObject;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}

- (void)gridView:(CMGridView *)gridView didDeselectItem:(id<CMGridItem>)item
{
    self.step.productSpecification.applicationProcess = self.grid.selectedItems.firstObject;
    [self.stepDelegate stepViewControllerDidChangeProductSpecification:self];
}


@end
