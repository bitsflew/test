//
//  CMChecklistView.h
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CMChecklistOrientation) {
    CMChecklistOrientationVertical = 0,
    CMChecklistOrientationHorizontal
};

@protocol CMChecklistItem <NSObject>

- (NSString*)title;

@optional
- (UIView*)accessoryView; // for example, a text field
- (void)setEnabled:(BOOL)enabled forAccessoryView:(UIView*)accessoryView fromUser:(BOOL)fromUser;

@end

@interface CMSimpleChecklistItem : NSObject

@property (nonatomic, copy) NSString *title;

+ (instancetype)itemWithTitle:(NSString*)title;

@end

@interface CMChecklistView : UIControl

@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, readonly) NSArray *checkedItems;
@property (nonatomic) CMChecklistOrientation orientation;

- (void)checkItem:(id<CMChecklistItem>)item;
- (void)checkItems:(NSArray*)items;

@end
