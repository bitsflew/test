//
//  CMProductSpecification.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMProductSpecification.h"

@implementation CMProductSpecificationSimpleNamedAttribute

- (id)initWithName:(NSString *)name
{
    if (!(self = [super init])) {
        return nil;
    }
    self.name = name;
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    return [self hash] == [object hash];
}

- (NSUInteger)hash
{
    return self.name.hash;
}

@end

@implementation CMProductSpecificationAdditive

+ (instancetype)additiveWithName:(NSString*)name
{
    return [[CMProductSpecificationAdditive alloc] initWithName:name];
}

@end

@implementation CMProductSpecificationResin

+ (instancetype)resinWithName:(NSString*)name
{
    return [[CMProductSpecificationResin alloc] initWithName:name];
}

@end

@implementation CMProductSpecification

@end
