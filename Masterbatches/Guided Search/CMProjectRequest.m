//
//  CMProjectRequest.m
//  MB Sales
//
//  Created by Craig on 24/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMProjectRequest.h"

@implementation CMProjectRequest

- (id)initWithProductSpecification:(CMProductSpecification*)productSpecification
{
    if (!(self = [super init])) {
        return nil;
    }
    self.productSpecification = productSpecification;
    return self;
}

@end
