//
//  CMProductSpecification+ChecklistItem.m
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMProductSpecification+ChecklistItem.h"

@implementation CMProductSpecificationSimpleNamedAttribute (ChecklistItem)

- (NSString*)title
{
    return self.name;
}


@end
