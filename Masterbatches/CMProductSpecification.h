//
//  CMProductSpecification.h
//  Masterbatches
//
//  Created by Craig on 16/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CMProductSpecificationSimpleNamedAttribute : NSObject // provides hash and equals: implementations

@property (nonatomic, copy) NSString *name;

+ (instancetype)attributeWithName:(NSString*)name;

- (id)initWithName:(NSString*)name;

@end

@interface CMProductSpecificationAdditive : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationResin : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationProductType : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationRegulatoryType : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationIndustryType : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationLightSource : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationMatchAccuracy : CMProductSpecificationSimpleNamedAttribute

@property (nonatomic) BOOL isColorCoding;

@end

@interface CMProductSpecificationPhysicalForm : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationOpacity : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationPartFinish : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecificationExposure : CMProductSpecificationSimpleNamedAttribute

@end

@interface CMProductSpecification : NSObject

@property (nonatomic, retain) NSArray *additives; // <CMProductSpecificationAdditive>
@property (nonatomic, retain) NSArray *resins;    // <CMProductSpecificationResin>
@property (nonatomic, retain) CMProductSpecificationProductType *productType;
@property (nonatomic, retain) CMProductSpecificationIndustryType *industryType;
@property (nonatomic, retain) NSArray *regulatoryTypes;

@property (nonatomic) CGFloat temperatureInCentrigrade;
@property (nonatomic) CGFloat thicknessInMillimeters;

- (void)setValue:(id)value forAdditionalQuestionKey:(NSString*)key;
- (id)valueForAdditionalQuestionKey:(NSString*)key;

@end
