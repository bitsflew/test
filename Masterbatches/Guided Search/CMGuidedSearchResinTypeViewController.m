//
//  CMGuidedSearchResinTypeViewController.m
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchResinTypeViewController.h"
#import "CMGuidedSearchProductTypeViewController.h"

@interface CMProductSpecificationResin (Item) <CMGuidedSearchGridSelectionItem>

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
}

- (BOOL)completeStepWithValidationError:(NSString *__autoreleasing *)errorDescription
{
    if (self.gridSelectionView.selectedItems.count == 0) {
        *errorDescription = NSLocalizedString(@"MustSpecifyResin", nil);
        return NO;
    }

    return YES;
}

@end
