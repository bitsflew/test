//
//  CMGuidedSearchFlow.h
//  Masterbatches
//
//  Created by Craig on 19/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMProductSpecification.h"

@interface CMGuidedSearchFlowStep : NSObject

@property (nonatomic, retain) Class viewControllerClass;
@property (nonatomic, copy) NSString *title;

@end

@interface CMGuidedSearchFlow : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) CMProductSpecification* productSpecification;
@property (nonatomic, readonly) NSUInteger stepCount;

+ (CMGuidedSearchFlow*)flowNamed:(NSString*)name;

- (id)initWithContentsOfFile:(NSString*)path;

- (NSUInteger)numberOfStepsBefore:(CMGuidedSearchFlowStep*)finishStep;
- (NSUInteger)numberOfStepsBetween:(CMGuidedSearchFlowStep*)firstStep and:(CMGuidedSearchFlowStep*)finishStep;

- (CMGuidedSearchFlowStep*)firstStep;
- (CMGuidedSearchFlowStep*)nextStepAfter:(CMGuidedSearchFlowStep*)step;

@end
