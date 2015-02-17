//
//  CMGuidedSearchQuestionViewController.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMProductSpecification.h"

@protocol CMGuidedSearchQuestionViewController;

@protocol CMGuidedSearchQuestionViewControllerDelegate <NSObject>

- (void)questionViewControllerDidCompleteQuestion:(UIViewController<CMGuidedSearchQuestionViewController>*)questionViewController;
- (void)questionViewControllerDidChangeNextQuestion:(UIViewController<CMGuidedSearchQuestionViewController>*)questionViewController;

@end

@protocol CMGuidedSearchQuestionViewController <NSObject>

@optional
+ (NSString*)questionMenuTitle;
- (void)setProductSpecification:(CMProductSpecification*)productSpecification;
- (BOOL)isQuestionCompleteValidationError:(NSString**)validationError;

@required
+ (Class)defaultNextQuestionViewControllerClass;
- (Class)nextQuestionViewControllerClass;
- (void)setQuestionViewControllerDelegate:(id<CMGuidedSearchQuestionViewControllerDelegate>)delegate;

@end