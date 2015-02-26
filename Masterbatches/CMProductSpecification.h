//
//  CMProductSpecification.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMProductSpecificationSimpleNamedAttribute : NSObject // provides hash and equals: implementations

@property (nonatomic, copy) NSString *name;

- (id)initWithName:(NSString*)name;

@end

@interface CMProductSpecificationAdditive : CMProductSpecificationSimpleNamedAttribute

+ (instancetype)additiveWithName:(NSString*)name;

@end

@interface CMProductSpecificationResin : CMProductSpecificationSimpleNamedAttribute

+ (instancetype)resinWithName:(NSString*)name;

@end

@interface CMProductSpecificationProductType : CMProductSpecificationSimpleNamedAttribute

+ (instancetype)productTypeWithName:(NSString*)name;

@end


@interface CMProductSpecification : NSObject

@property (nonatomic, retain) NSArray *additives; // <CMProductSpecificationAdditive>
@property (nonatomic, retain) NSArray *resins;    // <CMProductSpecificationResin>
@property (nonatomic, retain) CMProductSpecificationProductType *productType;

- (void)setValue:(id)value forAdditionalQuestionKey:(NSString*)key;
- (id)valueForAdditionalQuestionKey:(NSString*)key;

@end
