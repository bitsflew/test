//
//  CMGuidedSearchFlow.h
//  Masterbatches
//
//  Created by Craig on 19/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMProductSpecification.h"

@interface CMGuidedSearchFlowAdditionalQuestion : NSObject

@property (nonatomic, retain) Class viewControllerClass;
@property (nonatomic, retain) NSDictionary *attributes; // used to configure view controller
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) CMProductSpecification* productSpecification;
@property (nonatomic, retain) NSString *key;

@end

@interface CMGuidedSearchFlowStep : NSObject

@property (nonatomic, retain) Class viewControllerClass;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) CMProductSpecification* productSpecification;

@end

@interface CMGuidedSearchFlow : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly, retain) CMProductSpecification* productSpecification;
@property (nonatomic, readonly) NSUInteger stepCount;

+ (CMGuidedSearchFlow*)flowNamed:(NSString*)name;

- (id)initWithContentsOfFile:(NSString*)path;

- (NSUInteger)numberOfStepsBefore:(CMGuidedSearchFlowStep*)finishStep;
- (NSUInteger)numberOfStepsBetween:(CMGuidedSearchFlowStep*)firstStep and:(CMGuidedSearchFlowStep*)finishStep;

- (CMGuidedSearchFlowStep*)firstStep;
- (CMGuidedSearchFlowStep*)nextStepAfter:(CMGuidedSearchFlowStep*)step;
- (CMGuidedSearchFlowStep*)previousStepBefore:(CMGuidedSearchFlowStep*)step;

- (NSArray*)additionalQuestionsNamed:(NSString*)name;
- (NSArray*)additionalQuestionsWithContentsOfFile:(NSString*)path;

@end
