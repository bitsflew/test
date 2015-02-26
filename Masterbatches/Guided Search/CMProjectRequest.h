//
//  CMProjectRequest.h
//  MB Sales
//
//  Created by Craig on 24/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMProductSpecification.h"

@interface CMProjectRequest : NSObject

- (id)initWithProductSpecification:(CMProductSpecification*)productSpecification;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *company;

@property (nonatomic, strong) CMProductSpecification *productSpecification;

@end
