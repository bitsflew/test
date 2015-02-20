//
//  CMSearchDAO.h
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMProductSpecification.h"

typedef void(^CMSearchDAOCompletionBlock)(NSArray *results, NSError *error);

@interface CMSearchDAO : NSObject

+ (void)loadSearchResultsForProductSpecification:(CMProductSpecification*)productSpecification completion:(CMSearchDAOCompletionBlock)completion;

@end
