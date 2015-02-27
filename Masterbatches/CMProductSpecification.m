//
//  CMProductSpecification.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMProductSpecification.h"

@implementation CMProductSpecificationSimpleNamedAttribute

+ (instancetype)attributeWithName:(NSString*)name
{
    return [[self alloc] initWithName:name];
}

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

@end

@implementation CMProductSpecificationResin

@end

@implementation CMProductSpecificationProductType

@end

@implementation CMProductSpecificationRegulatoryType

@end

@implementation CMProductSpecificationIndustryType

@end

@implementation CMProductSpecificationLightSource

@end

@implementation CMProductSpecificationMatchAccuracy

+ (instancetype)attributeWithName:(NSString *)name isColorCoding:(BOOL)isColorCoding
{
    CMProductSpecificationMatchAccuracy *matchAccuracy = [super attributeWithName:name];
    matchAccuracy.isColorCoding = isColorCoding;
    return matchAccuracy;
}

- (NSUInteger)hash
{
    return 31 * self.name.hash + (int)self.isColorCoding;
}

@end

@implementation CMProductSpecificationPhysicalForm

@end

@implementation CMProductSpecificationOpacity

@end

@implementation CMProductSpecificationPartFinish

@end

@implementation CMProductSpecificationExposure

@end

@interface CMProductSpecification ()

@property (nonatomic, retain) NSMutableDictionary *additionalQuestionValues;

@end

@implementation CMProductSpecification

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    self.additionalQuestionValues = [NSMutableDictionary new];
    return self;
}

- (void)setValue:(id)value forAdditionalQuestionKey:(NSString*)key
{
    self.additionalQuestionValues[key] = value;
}

- (id)valueForAdditionalQuestionKey:(NSString*)key
{
    return self.additionalQuestionValues[key];
}

@end
