//
//  CMGuidedSearchAdditiveFunctionalityViewController.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchAdditiveFunctionalityViewController.h"
#import "CMGuidedSearchResinTypeViewController.h"

@interface CMProductSpecificationAdditive (Item) <CMGuidedSearchGridSelectionItem>

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    self.title = NSLocalizedString(@"AdditiveFunctionality", "");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridSelectionView.allowsMultipleSelection = YES;

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
}

+ (NSString*)questionMenuTitle
{
    return NSLocalizedString(@"AdditiveFunctionality", "");
}

+ (Class)defaultNextQuestionViewControllerClass
{
    return [CMGuidedSearchResinTypeViewController class];
}

- (Class)nextQuestionViewControllerClass
{
    return nil;
}

- (BOOL)isQuestionCompleteValidationError:(NSString *__autoreleasing *)validationError
{
    if (self.gridSelectionView.selectedItems.count == 0) {
        *validationError = @"Choose one or more additives";
        return NO;
    }

    return YES;
}

@end
