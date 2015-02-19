//
//  CMGuidedSearchFlow.m
//  Masterbatches
//
//  Created by Craig on 19/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMGuidedSearchFlow.h"
#import "CMProductSpecification.h"

@interface CMGuidedSearchFlowStep ()

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end

@implementation CMGuidedSearchFlowStep

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    if (!(self = [super init])) {
        return nil;
    }

    self.title = dictionary[@"Title"];
    
    NSString *className = [dictionary[@"Class"] hasSuffix:@"ViewController"]
      ? dictionary[@"Class"]
      : [NSString stringWithFormat:@"CMGuidedSearch%@ViewController", dictionary[@"Class"]];

    self.viewControllerClass = NSClassFromString(className);

    return self;
}

@end

@interface CMGuidedSearchFlow ()

@property (nonatomic, retain) NSArray *steps;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end

@implementation CMGuidedSearchFlow

+ (CMGuidedSearchFlow*)flowNamed:(NSString*)name
{
    if (![name hasPrefix:@".plist"]) {
        name = [name stringByAppendingString:@".plist"];
    }
    CMGuidedSearchFlow *flow = [[CMGuidedSearchFlow alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    return flow;
}

- (id)initWithContentsOfFile:(NSString*)path
{
    return [self initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    if (!(self = [super init])) {
        return nil;
    }
    self.productSpecification = [CMProductSpecification new];
    self.title = dictionary[@"Title"];
    self.steps = [NSMutableArray new];
    for (NSDictionary *stepDictionary in dictionary[@"Steps"]) {
        [((NSMutableArray*)self.steps) addObject:[[CMGuidedSearchFlowStep alloc] initWithDictionary:stepDictionary]];
    }
    return self;
}

- (NSUInteger)stepCount
{
    return self.steps.count;
}

- (NSUInteger)numberOfStepsBefore:(CMGuidedSearchFlowStep*)finishStep
{
    return [self numberOfStepsBetween:nil and:finishStep];
}

- (NSUInteger)numberOfStepsBetween:(CMGuidedSearchFlowStep*)firstStep and:(CMGuidedSearchFlowStep*)finishStep
{
    CMGuidedSearchFlowStep *step = firstStep ?: self.firstStep;
    NSUInteger count = 0;
    while ((step = [self nextStepAfter:step])) {
        count += 1;
        if (step == finishStep) {
            return count;
        }
    }
    return 0; // step not found
}

- (CMGuidedSearchFlowStep*)firstStep
{
    return self.steps.firstObject;
}

- (CMGuidedSearchFlowStep*)nextStepAfter:(CMGuidedSearchFlowStep *)step
{
    // TODO: This can incorporate logic for search request properties, for example in additive steps
    NSUInteger index = [self.steps indexOfObjectIdenticalTo:step];
    return ((index != NSNotFound) && (index < self.steps.count-1)) ? self.steps[index+1] : nil;
}

- (CMGuidedSearchFlowStep*)previousStepBefore:(CMGuidedSearchFlowStep*)step
{
    NSUInteger index = [self.steps indexOfObjectIdenticalTo:step];
    return (index == 0) ? nil : self.steps[index-1];
}

@end
