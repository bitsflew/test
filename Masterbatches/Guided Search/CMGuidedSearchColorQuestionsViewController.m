//
//  CMGuidedSearchColorQuestionsViewController.m
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchColorQuestionsViewController.h"
#import "CMProductSpecification+ChecklistItem.h"

@interface CMGuidedSearchColorQuestionsViewController () <UITextFieldDelegate>

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
    
    if (self.step) {
        [self updateSelections];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifiedKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setStep:(CMGuidedSearchFlowStep *)step
{
    _step = step;
    
    if (self.isViewLoaded) {
        [self updateSelections];
    }
}

- (void)updateSelections
{
    CMProductSpecification *productSpecification = self.step.productSpecification;
    
    [self.opacityChecklist checkItem:productSpecification.opacity];
    [self.partFinishChecklist checkItem:productSpecification.partFinish];
    [self.exposureChecklist checkItems:productSpecification.exposures];
    [self.lightSourceChecklist checkItems:productSpecification.lightSources];
    [self.physicalFormChecklist checkItem:productSpecification.physicalForm];
    [self.matchAccuracyChecklist checkItem:productSpecification.matchAccuracy];

    NSString *colorCoding = productSpecification.matchAccuracy.colorCoding;

    [self.matchAccuracyColorCodingChecklist checkItem:colorCoding
     ? self.matchAccuracyColorCodingChecklist.items.firstObject
     : nil];

    [self.matchAccuracyColorCodingTextField setText:colorCoding];

    self.matchAccuracyColorCodingTextField.enabled = colorCoding != nil;
}

- (IBAction)checklistValueChanged:(id)sender
{
    CMProductSpecification *productSpecification = self.step.productSpecification;
    
    id singleItemOrNil = ((CMChecklistView*)sender).checkedItems.lastObject;
    NSArray *multipleItemsOrNone = ((CMChecklistView*)sender).checkedItems;

    if (sender == self.opacityChecklist) {
        productSpecification.opacity = singleItemOrNil;
    }
    else
        if (sender == self.partFinishChecklist) {
            productSpecification.partFinish = singleItemOrNil;
        }
    else
        if (sender == self.exposureChecklist) {
            productSpecification.exposures = multipleItemsOrNone;
        }
    else
        if (sender == self.lightSourceChecklist) {
            productSpecification.lightSources = multipleItemsOrNone;
        }
    else
        if (sender == self.physicalFormChecklist) {
            productSpecification.physicalForm = singleItemOrNil;
        }
    else
        if (sender == self.matchAccuracyChecklist) {
            productSpecification.matchAccuracy = singleItemOrNil;
            if (productSpecification.matchAccuracy) {
                // Set color coding property on match accuracy when user has entered a value there
                productSpecification.matchAccuracy.colorCoding = (self.matchAccuracyColorCodingChecklist.checkedItems.count == 1)
                  ? self.matchAccuracyColorCodingTextField.text
                  : nil;
            }
        }
    else
        if (sender == self.matchAccuracyColorCodingChecklist) {
            self.matchAccuracyColorCodingTextField.enabled = singleItemOrNil != nil;
            if (singleItemOrNil) {
                if (!productSpecification.matchAccuracy) {
                    // If adding a color code enforce a selection on match accuracy
                    id firstMatchAccuracy = self.matchAccuracyChecklist.items.firstObject;
                    [self.matchAccuracyChecklist checkItems:@[ firstMatchAccuracy ]];
                    productSpecification.matchAccuracy = firstMatchAccuracy;
                }
                productSpecification.matchAccuracy.colorCoding = self.matchAccuracyColorCodingTextField.text;
                
                [self.matchAccuracyColorCodingTextField becomeFirstResponder];
            } else {
                productSpecification.matchAccuracy.colorCoding = nil;

                [self.matchAccuracyColorCodingTextField resignFirstResponder];
            }
        }
}

#pragma mark -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return textField.isEnabled;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.step.productSpecification.matchAccuracy.colorCoding = text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark -

- (void)notifiedKeyboardDidShow:(NSNotification*)notification
{
    // See: https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7

    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardSize.height += 10.f; // extra space

    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;

    CGRect frame = self.view.frame;
    frame.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(frame, self.matchAccuracyColorCodingTextField.frame.origin) ) {
        [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                         animations:^{
                             [self.scrollView scrollRectToVisible:self.matchAccuracyColorCodingTextField.frame
                                                         animated:NO];
                         }];
    }
}

- (void)notifiedKeyboardWillHide:(NSNotification*)notification
{
    self.scrollView.contentInset = [self.stepDelegate edgeInsetsForStepViewController:self];
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
}


@end
