//
//  MenuModel.m
//  Masterbatches
//
//  Created by Berik Visschers on 02-17.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

+ (instancetype)readMenuFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    NSDictionary *menuDict = [NSDictionary dictionaryWithContentsOfFile:path];
    return [self parseMenu:menuDict];
}

+ (instancetype)parseMenu:(NSDictionary *)menuDict {
    MenuModel *menu = [self new];
    menu.name = menuDict[@"Name"];
    menu.angle = [menuDict[@"Angle"] doubleValue];
    menu.distance = [menuDict[@"Distance"] doubleValue];
    menu.action = menuDict[@"Action"];
    
    NSMutableArray *subMenuItems = [NSMutableArray arrayWithCapacity:[menuDict[@"Items"] count]];
    for (NSDictionary *item in menuDict[@"Items"]) {
        [subMenuItems addObject:[self parseMenu:item]];
    }
    menu.subMenuItems = subMenuItems;

    return menu;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<MenuItem %@ angle: %f distance: %f>", self.name, self.angle, self.distance];
}

@end
