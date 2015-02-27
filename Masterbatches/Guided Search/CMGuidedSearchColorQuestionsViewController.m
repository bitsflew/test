//
//  CMGuidedSearchColorQuestionsViewController.m
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchColorQuestionsViewController.h"

@interface CMGuidedSearchColorQuestionsViewController ()

@end

@implementation CMGuidedSearchColorQuestionsViewController

- (void)viewDidLoad
{
    self.scrollView.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    
    self.opacityChecklist.items = @[ [CMProductSpecificationOpacity attributeWithName:@"Transparent"],
                                     [CMProductSpecificationOpacity attributeWithName:@"Translucent"],
                                     [CMProductSpecificationOpacity attributeWithName:@"Opaque"] ];
    
    self.partFinishChecklist.items = @[ [CMProductSpecificationPartFinish attributeWithName:@"Gloss"],
                                        [CMProductSpecificationPartFinish attributeWithName:@"Matte"],
                                        [CMProductSpecificationPartFinish attributeWithName:@"Texture"] ];
    
    self.exposureChecklist.items = @[ [CMProductSpecificationExposure attributeWithName:@"Indoor"],
                                      [CMProductSpecificationExposure attributeWithName:@"Outdoor"] ];
    self.exposureChecklist.allowsMultipleSelection = YES;

    self.lightSourceChecklist.items = @[ [CMProductSpecificationLightSource attributeWithName:@"Daylight"],
                                         [CMProductSpecificationLightSource attributeWithName:@"CWF"],
                                         [CMProductSpecificationLightSource attributeWithName:@"Incandescent"] ];
    self.lightSourceChecklist.allowsMultipleSelection = YES;

    self.physicalFormChecklist.items = @[ [CMProductSpecificationPhysicalForm attributeWithName:@"Pellet"],
                                          [CMProductSpecificationPhysicalForm attributeWithName:@"Liquid"] ];

    self.matchAccuracyChecklist.items = @[ [CMProductSpecificationMatchAccuracy attributeWithName:@"Approximate"],
                                           [CMProductSpecificationMatchAccuracy attributeWithName:@"Commercial"],
                                           [CMProductSpecificationMatchAccuracy attributeWithName:@"Critical"] ];

    self.matchAccuracyColorCodingChecklist.items = @[ [CMSimpleChecklistItem itemWithTitle:@"Color coding:"] ];
    self.matchAccuracyColorCodingChecklist.allowsMultipleSelection = YES; // since it ought to have checkbox styling
}

@end
