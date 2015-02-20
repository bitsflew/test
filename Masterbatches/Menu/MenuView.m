//
//  MenuView.m
//  Masterbatches
//
//  Created by Berik Visschers on 02-17.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "MenuView.h"
#import <UIKit/UIKit.h>
#import "UIView+Polarcoordinates.h"
#import "ClariantColors.h"

@class MenuItemView;

typedef void (^MenuItemSelectHandler)(MenuItemView *);

typedef NS_ENUM(NSInteger, MenuItemDisplayMode) {
    MenuItemDisplayModeDefault,
    MenuItemDisplayModeMain,
    MenuItemDisplayModeBack
};

@interface MenuItemView : UIView
+ (instancetype)viewForMenuItem:(MenuModel *)item;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MenuModel *menuItem;
@property (nonatomic, strong) MenuItemSelectHandler menuItemSelectHandler;
@property (nonatomic, assign) MenuItemDisplayMode displayMode;
@end

@implementation MenuItemView

+ (instancetype)viewForMenuItem:(MenuModel *)item {
    MenuItemView *itemView = [[super alloc] initWithFrame:CGRectZero];
    itemView.menuItem = item;
    
    itemView.label = [UILabel new];
    itemView.label.numberOfLines = -1;
    itemView.label.textAlignment = NSTextAlignmentCenter;
    [itemView addSubview:itemView.label];
    
    itemView.label.textColor = itemView.fontColor;
    itemView.label.text = item.name;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = itemView.frame;
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [button addTarget:itemView action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:itemView action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:itemView action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];

    itemView.button = button;
    [itemView addSubview:button];
    
    itemView.layer.borderColor = itemView.circleColor.CGColor;
    itemView.layer.borderWidth = itemView.borderWidth;
    itemView.backgroundColor = [ClariantColors menuBackgroundColor];
    
    return itemView;
}

- (void)select:(id)sender {
    [self.layer removeAllAnimations];
    if (self.menuItemSelectHandler) self.menuItemSelectHandler(self);
}

- (void)touchUpOutside:(id)sender {
    [self.layer removeAllAnimations];
}

- (void)touchDown:(id)sender {
    // Scaling the UIView in an animation causes the cirles to become a bit squarish
    // Insead, scaling the layer works fine
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.fromValue = @(1.0);
    animation.toValue = @(1.15);
    animation.duration = 0.15;
    
    [self.layer addAnimation:animation forKey:@"scale"];
}

- (void)setDisplayMode:(MenuItemDisplayMode)displayMode {
    _displayMode = displayMode;

    self.label.font = [self font];
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.circleColor.CGColor;
    self.label.textColor = self.fontColor;

    // Don't move the center while resizing
    CGPoint center = self.center;
    [self sizeToFit];
    self.center = center;
}

- (CGFloat)borderWidth {
    switch (self.displayMode) {
        case MenuItemDisplayModeDefault:
            return 1;
        case MenuItemDisplayModeMain:
        case MenuItemDisplayModeBack:
            return 2;
    }
}

- (CGFloat)margin {
    switch (self.displayMode) {
        case MenuItemDisplayModeDefault:
            return 50;
        case MenuItemDisplayModeMain:
            return 60;
        case MenuItemDisplayModeBack:
            return 35;
    }
}

- (UIFont *)font {
    switch (self.displayMode) {
        case MenuItemDisplayModeMain:
            return [UIFont fontWithName:@"Gotham-Bold" size:18];
        case MenuItemDisplayModeDefault:
        case MenuItemDisplayModeBack:
            return [UIFont fontWithName:@"Gotham-Book" size:15];
    }
}

- (UIColor *)fontColor {
    switch (self.displayMode) {
        case MenuItemDisplayModeMain:
            return [ClariantColors menuMainFontColor];
        case MenuItemDisplayModeDefault:
            return [ClariantColors menuDefaultFontColor];
        case MenuItemDisplayModeBack:
            return [ClariantColors menuBackFontColor];
    }
}

- (UIColor *)circleColor {
    switch (self.displayMode) {
        case MenuItemDisplayModeMain:
            return [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient.png"]];
        case MenuItemDisplayModeDefault:
            return [UIColor colorWithWhite:0.5 alpha:1];
        case MenuItemDisplayModeBack:
            return [UIColor colorWithWhite:0.2 alpha:1];
    }
}

- (void)layoutSubviews {
    self.label.center = [self convertPoint:self.center fromView:self.superview];
    // Fix off-pixel alignment
    self.label.frame = CGRectIntegral(self.label.frame);
    self.layer.cornerRadius = self.frame.size.width / 2;
}

- (void)sizeToFit {
    [super sizeToFit];
    
    // This causes some jumping of the titles
    CGRect frame = self.label.frame;
    frame.size.width = CGFLOAT_MAX;
    self.label.frame = frame;
    
    [self.label sizeToFit];
    
    CGFloat width = self.label.frame.size.width + self.margin + 2 * self.borderWidth;
    // Make this circle is layed-out on whole pixels
    width = ceil(width / 2) * 2;
    self.frame = CGRectIntegral(CGRectMake(self.frame.origin.x, self.frame.origin.y, width, width));
    
    [self layoutSubviews];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) return NO;
    MenuItemView *other = (MenuItemView *)object;
    return [other.menuItem isEqual:self.menuItem];
}

@end


@interface MenuView()
@property (nonatomic, strong) MenuItemView *centerItem;
@property (nonatomic, strong) MenuItemView *parentItem;
@property (nonatomic, strong) NSMutableDictionary *subItems;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation MenuView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup {
    self.subItems = [NSMutableDictionary new];

    [self createSubviews];

    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)createSubviews {
    // Stop the drawRect: while new items are being added and not yet layed-out
    self.displayLink.paused = YES;
    
    if (self.menu == nil) self.menu = [MenuModel readMenuFromFile];

    if (self.centerItem == nil) {
        self.centerItem = [self createViewForMenuItem:self.menu];
        self.centerItem.displayMode = MenuItemDisplayModeMain;
        [self.centerItem setIntegralPolarCoordinate:PolarCoordinateZero withCenter:self.center];
        [self addSubview:self.centerItem];
    }
    
    for (MenuModel *item in self.menu.subMenuItems) {
        
        MenuItemView *itemView = self.subItems[@(item.identifier)];
        if (itemView == nil) {
            itemView = [self createViewForMenuItem:item];
            itemView.displayMode = MenuItemDisplayModeDefault;
            [itemView setIntegralPolarCoordinate:PolarCoordinateZero withCenter:self.centerItem.center];
            self.subItems[@(item.identifier)] = itemView;
        }
        
        [self insertSubview:itemView belowSubview:self.centerItem];
    }
}

- (MenuItemView *)createViewForMenuItem:(MenuModel *)menuItem {
    MenuItemView *itemView = [MenuItemView viewForMenuItem:menuItem];
    itemView.menuItemSelectHandler = ^(MenuItemView *itemView) {
        [self selectMenuItem:itemView];
    };
    return itemView;
}

- (void)selectMenuItem:(MenuItemView *)itemView {
    if (itemView.menuItem.action.length) {
        if (self.menuActionHandler) self.menuActionHandler(itemView.menuItem.action);
        return;
    }
    
    if (itemView.menuItem.subMenuItems.count == 0) {
        // Skip empty items
        return;
    }

    if ([itemView isEqual:self.centerItem]) {
        return;
    }
    
    BOOL isSubItem = self.subItems[@(itemView.menuItem.identifier)] != nil;
    NSMutableArray *oldSubMenuItems = [self.subItems.allValues mutableCopy];
    MenuItemView *oldCenterItem = self.centerItem;
    
    if ([itemView isEqual:self.parentItem]) {
        self.parentItem = nil; // Help!
        [self.subItems removeAllObjects];
        self.subItems[@(self.centerItem.menuItem.identifier)] = self.centerItem;
    } else if (isSubItem) {
        [self.parentItem removeFromSuperview];
        self.parentItem = self.centerItem;
        [self.subItems removeAllObjects];
        [oldSubMenuItems removeObject:itemView];
    }

    self.menu = itemView.menuItem;
    self.centerItem = itemView;
    
    [self createSubviews];
    
    NSMutableArray *newMenuItems = [self.subItems.allValues mutableCopy];
    [newMenuItems removeObject:oldCenterItem];
    
    for (MenuItemView *item in self.subItems.allValues) {
        item.displayMode = MenuItemDisplayModeDefault;
    }
    
    for (MenuItemView *item in newMenuItems) {
        [item sizeToFit];
        item.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    }

    self.centerItem.displayMode = MenuItemDisplayModeMain;
    self.parentItem.displayMode = MenuItemDisplayModeBack;
    
    [UIView animateWithDuration:0.5 animations:^{

        self.centerItem.center = self.center;
        
        if (self.parentItem) {
            [self.parentItem setIntegralPolarCoordinate:PolarCoordinateMake(350, M_PI * 1.7) withCenter:self.center];
        }

        for (MenuItemView *item in self.subItems.allValues) {
            item.transform = CGAffineTransformIdentity;
            MenuModel *menuItem = item.menuItem;
            [item setIntegralPolarCoordinate:PolarCoordinateMake(menuItem.distance, menuItem.angle) withCenter:self.center];
        }
        
        for (MenuItemView *item in oldSubMenuItems) {
            [item setIntegralPolarCoordinate:PolarCoordinateZero withCenter:oldCenterItem.center];
            item.alpha = 0;
            item.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
        }
    } completion:^(BOOL finished) {
        [oldSubMenuItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.displayLink.paused = NO;

    self.centerItem.center = self.center;
    
    if (self.parentItem) {
        [self.parentItem setIntegralPolarCoordinate:PolarCoordinateMake(350, M_PI * 1.7) withCenter:self.center];
    }
    
    for (MenuItemView *subMenuItem in self.subItems.allValues) {
        [subMenuItem sizeToFit];
        MenuModel *menuItem = subMenuItem.menuItem;
        [subMenuItem setIntegralPolarCoordinate:PolarCoordinateMake(menuItem.distance, menuItem.angle) withCenter:self.center];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[ClariantColors menuBackgroundColor] setFill];
    CGContextFillRect(context, rect);
    
    [[ClariantColors menuLineColor] set];
    
    CGContextSetLineWidth(context, 1);
    NSArray *items = self.subItems.allValues;
    if (self.parentItem) {
        items = [items arrayByAddingObject:self.parentItem];
    }
    
    for (MenuItemView *item in items) {
        CALayer *itemLayer = (CALayer *)item.layer.presentationLayer;
        CALayer *centerItemLayer = (CALayer *)self.centerItem.layer.presentationLayer;
        
        CGContextMoveToPoint(context, centerItemLayer.position.x, centerItemLayer.position.y);
        CGContextAddLineToPoint(context, itemLayer.position.x, itemLayer.position.y);
    }
    
    CGContextStrokePath(context);
}



@end
