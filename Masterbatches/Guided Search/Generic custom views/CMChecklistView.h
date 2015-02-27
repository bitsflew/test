//
//  CMChecklistView.h
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMChecklistItem <NSObject>
- (NSString*)title;
@end

@interface CMSimpleChecklistItem : NSObject

@property (nonatomic, copy) NSString *title;

+ (instancetype)itemWithTitle:(NSString*)title;

@end

@interface CMChecklistView : UIControl

@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, readonly) NSArray *checkedItems;

- (void)checkItem:(id<CMChecklistItem>)item;
- (void)checkItems:(NSArray*)items;

@end