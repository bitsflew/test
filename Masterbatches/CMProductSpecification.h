//
//  CMProductSpecification.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMProductSpecificationAdditive : NSObject

@property (nonatomic, copy) NSString *name;

+ (instancetype)additiveWithName:(NSString*)name;

@end

@interface CMProductSpecificationResin : NSObject

@property (nonatomic, copy) NSString *name;

+ (instancetype)resinWithName:(NSString*)name;

@end

@interface CMProductSpecification : NSObject

@property (nonatomic, retain) NSArray *additives; // <CMProductSpecificationAdditive>

@end
