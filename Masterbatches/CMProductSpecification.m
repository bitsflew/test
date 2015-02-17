//
//  CMProductSpecification.m
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMProductSpecification.h"

@implementation CMProductSpecificationAdditive

+ (instancetype)additiveWithName:(NSString*)name
{
    CMProductSpecificationAdditive *additive = [CMProductSpecificationAdditive new];
    additive.name = name;
    return additive;
}

@end

@implementation CMProductSpecification

@end
