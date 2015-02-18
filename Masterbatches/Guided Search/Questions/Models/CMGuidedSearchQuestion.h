//
//  CMGuidedSearchQuestion.h
//  Masterbatches
//
//  Created by Craig on 17/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMProductSpecification.h"

@interface CMGuidedSearchQuestion : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) CMProductSpecification *productSpecification;

- (NSError*)validationError; // subclasses
- (Class)nextQuestionClass;  // subclasses

@end
