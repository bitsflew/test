//
//  CMSearchDAO.m
//  Masterbatches
//
//  Created by Craig on 20/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMSearchDAO.h"

@import UIKit;

@implementation CMSearchDAO

+ (void)loadSearchResultsForProductSpecification:(CMProductSpecification*)productSpecification completion:(CMSearchDAOCompletionBlock)completion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // TODO! For realsies!
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSMutableArray *results = [NSMutableArray new];
        for (int i=0; i<arc4random_uniform(128); i++) {
            [results addObject:@"X"];
        }
        completion(results, nil);
    });
}

@end
