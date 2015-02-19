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

    self.title = dictionary[@"title"];
    
    NSString *className = [dictionary[@"class"] hasSuffix:@"ViewController"]
      ? dictionary[@"class"]
      : [NSString stringWithFormat:@"CMGuidedSearch%@ViewController", dictionary[@"class"]];

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
    self.title = dictionary[@"title"];
    self.steps = [NSMutableArray new];
    for (NSDictionary *stepDictionary in dictionary[@"steps"]) {
        [((NSMutableArray*)self.steps) addObject:[[CMGuidedSearchFlowStep alloc] initWithDictionary:stepDictionary]];
    }
    return self;
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

@end
