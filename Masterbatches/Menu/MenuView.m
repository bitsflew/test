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
#import <AudioToolbox/AudioServices.h>
#import "ConnectorsLayer.h"

@class MenuItemView;

@interface MenuView ()
@property (nonatomic, strong) MenuItemView *centerItem;
@property (nonatomic, strong) MenuItemView *parentItem;
@property (nonatomic, strong) NSMutableArray *parentStash;
@property (nonatomic, strong) ConnectorsLayer *connectorsLayer;
@end

typedef void (^MenuItemSelectHandler)(MenuItemView *);

typedef NS_ENUM(NSInteger, MenuItemDisplayMode) {
    MenuItemDisplayModeDefault,
    MenuItemDisplayModeMain,
    MenuItemDisplayModeBack
};

#define CGTransformScale CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5)
#define AnimationDuration 0.5

#define ParentItemRadius 300
#define ParentItemAngle (M_PI * 1.7)

static SystemSoundID audioEffectMenuTouch = 0;
static SystemSoundID audioEffectMenuSelect = 0;

@interface MenuItemView : UIView
+ (instancetype)viewForMenuItem:(MenuModel *)item;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MenuModel *menuItem;
@property (nonatomic, strong) MenuItemSelectHandler menuItemSelectHandler;
@property (nonatomic, assign) MenuItemDisplayMode displayMode;
@property (nonatomic, strong) NSMutableDictionary *subItems;
@property (nonatomic, weak) CALayer *connectorLayer;
@end

@implementation MenuItemView

+ (void)load {
    NSString *pathMenuSelect = [[NSBundle mainBundle] pathForResource:@"slide-metal" ofType:@"aif"];
    NSString *pathMenuTouch = [[NSBundle mainBundle] pathForResource:@"tap-smallest" ofType:@"aif"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:pathMenuSelect], &audioEffectMenuSelect);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:pathMenuTouch], &audioEffectMenuTouch);
}

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
    
    itemView.subItems = [NSMutableDictionary new];
    
    return itemView;
}

- (void)select:(id)sender {
    [self.layer removeAllAnimations];
    if (self.menuItemSelectHandler) self.menuItemSelectHandler(self);
    AudioServicesPlaySystemSound(audioEffectMenuSelect);
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
    
    AudioServicesPlaySystemSound(audioEffectMenuTouch);
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

- (void)animateKeyPathsToValues:(NSDictionary*)keyPathsAndValues
{
    __block CAAnimation *animation = nil;

    if (keyPathsAndValues.count > 1) {
        animation = [CAAnimationGroup animation];
    }

    [keyPathsAndValues enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL *stop) {
        CABasicAnimation *innerAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
        innerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        innerAnimation.fillMode = kCAFillModeForwards;
        innerAnimation.removedOnCompletion = NO;
        innerAnimation.duration = AnimationDuration;
        innerAnimation.fromValue = [self.layer valueForKeyPath:keyPath];
        innerAnimation.toValue = value;
        [self.layer setValue:value forKey:keyPath];
        if ([animation isKindOfClass:[CAAnimationGroup class]]) {
            ((CAAnimationGroup*)animation).animations = [(((CAAnimationGroup*)animation).animations ?: @[])
                                                         arrayByAddingObject:innerAnimation];
        } else {
            animation = innerAnimation;
        }
    }];

    [self.layer addAnimation:animation forKey:@"animation"];
}

@end

@implementation MenuView

static UIMotionEffectGroup *centerItemMotionEffect = nil;
static UIMotionEffectGroup *parentItemMotionEffect = nil;
static UIMotionEffectGroup *subItemMotionEffect = nil;

+(void)load {
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    verticalMotionEffect.minimumRelativeValue = @(10);
    verticalMotionEffect.maximumRelativeValue = @(-10);
    horizontalMotionEffect.minimumRelativeValue = @(10);
    horizontalMotionEffect.maximumRelativeValue = @(-10);
    
    centerItemMotionEffect = [UIMotionEffectGroup new];
    centerItemMotionEffect.motionEffects = @[verticalMotionEffect, horizontalMotionEffect];
    
    verticalMotionEffect = [verticalMotionEffect copy];
    horizontalMotionEffect = [horizontalMotionEffect copy];
    
    verticalMotionEffect.minimumRelativeValue = @(-100);
    verticalMotionEffect.maximumRelativeValue = @(100);
    horizontalMotionEffect.minimumRelativeValue = @(-100);
    horizontalMotionEffect.maximumRelativeValue = @(100);
    
    subItemMotionEffect = [UIMotionEffectGroup new];
    subItemMotionEffect.motionEffects = @[verticalMotionEffect, horizontalMotionEffect];

    verticalMotionEffect = [verticalMotionEffect copy];
    horizontalMotionEffect = [horizontalMotionEffect copy];
    
    verticalMotionEffect.minimumRelativeValue = @(100);
    verticalMotionEffect.maximumRelativeValue = @(-100);
    horizontalMotionEffect.minimumRelativeValue = @(100);
    horizontalMotionEffect.maximumRelativeValue = @(-100);
    
    parentItemMotionEffect = [UIMotionEffectGroup new];
    parentItemMotionEffect.motionEffects = @[verticalMotionEffect, horizontalMotionEffect];
}

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
    self.parentStash = [NSMutableArray new];

    self.connectorsLayer = [ConnectorsLayer layer];
    [self.layer addSublayer:self.connectorsLayer];
    
    [self createSubviews];
}

- (void)createSubviews {
    // Stop the drawRect: while new items are being added and not yet layed-out
    if (self.menu == nil) self.menu = [MenuModel readMenuFromFile];

    if (self.centerItem == nil) {
        self.centerItem = [self createViewForMenuItem:self.menu];
        self.centerItem.displayMode = MenuItemDisplayModeMain;
        [self.centerItem setIntegralPolarCoordinate:PolarCoordinateZero withCenter:self.center];
        [self addSubview:self.centerItem];
        self.centerItem.motionEffects = @[centerItemMotionEffect];
    }
    
    for (MenuModel *item in self.menu.subMenuItems) {
        
        MenuItemView *itemView = self.centerItem.subItems[@(item.identifier)];
        if (itemView == nil) {
            itemView = [self createViewForMenuItem:item];
            itemView.displayMode = MenuItemDisplayModeDefault;
            [itemView setIntegralPolarCoordinate:PolarCoordinateZero withCenter:self.centerItem.center];
            self.centerItem.subItems[@(item.identifier)] = itemView;
        }

        if (![self.connectorsLayer layerConnecting:self.centerItem.layer to:itemView.layer]) {
            [self.connectorsLayer addLayerConnecting:self.centerItem.layer to:itemView.layer];
        }

        itemView.motionEffects = @[subItemMotionEffect];
        
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
    
    BOOL isSubItem = self.centerItem.subItems[@(itemView.menuItem.identifier)] != nil;
    NSMutableArray *oldSubMenuItems = [self.centerItem.subItems.allValues mutableCopy];
    MenuItemView *oldCenterItem = self.centerItem;
    
    if ([itemView isEqual:self.parentItem]) {
        MenuItemView *parentItem = [self.parentStash lastObject];
        self.parentItem = parentItem;
        parentItem.motionEffects = @[parentItemMotionEffect];
        if (parentItem) {
            [self.parentStash removeLastObject];
            [self insertSubview:parentItem belowSubview:itemView];
            parentItem.transform = CGTransformScale;
            parentItem.alpha = 0;
            [UIView animateWithDuration:AnimationDuration animations:^{
                parentItem.transform = CGAffineTransformIdentity;
                parentItem.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
    } else if (isSubItem) {
        if (self.parentItem) {
            MenuItemView *parentItem = self.parentItem;
            [self.parentStash addObject:parentItem];
            [UIView animateWithDuration:AnimationDuration animations:^{
                parentItem.transform = CGTransformScale;
                parentItem.alpha = 0;
            } completion:^(BOOL finished) {
                [parentItem removeFromSuperview];
            }];
        }
        self.parentItem = self.centerItem;
        self.parentItem.motionEffects = @[parentItemMotionEffect];
        [oldSubMenuItems removeObject:itemView];
    }

    self.menu = itemView.menuItem;
    self.centerItem = itemView;
    itemView.motionEffects = @[centerItemMotionEffect];
    [self bringSubviewToFront:itemView];
    
    [self createSubviews];
    
    NSMutableArray *newMenuItems = [itemView.subItems.allValues mutableCopy];
    [newMenuItems removeObject:oldCenterItem];
    
    for (MenuItemView *item in itemView.subItems.allValues) {
        item.displayMode = MenuItemDisplayModeDefault;
        item.motionEffects = @[subItemMotionEffect];
    }
    
    for (MenuItemView *item in newMenuItems) {
        [item sizeToFit];
        item.transform = CGTransformScale;
    }

    self.centerItem.displayMode = MenuItemDisplayModeMain;
    self.parentItem.displayMode = MenuItemDisplayModeBack;

    [self.connectorsLayer updateConnectorsAnimated:NO];

    [CATransaction begin];
    [CATransaction setAnimationDuration:AnimationDuration];

    [CATransaction setCompletionBlock:^{
        for (UIView *oldSubMenuItem in oldSubMenuItems) {
            [[self.connectorsLayer layerConnecting:oldCenterItem.layer to:oldSubMenuItem.layer] removeFromSuperlayer];
        }

        [oldSubMenuItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];

    [self.centerItem animateKeyPathsToValues:@{ @"position" : [NSValue valueWithCGPoint:self.center] }];
    
    if (self.parentItem) {
        [self.parentItem animateKeyPathsToValues:@{ @"position" :
                                                        [NSValue valueWithCGPoint:[self.parentItem positionForPolarCoordinate:PolarCoordinateMake(ParentItemRadius, ParentItemAngle)
                                                                                                                   withCenter:self.center]] }];
    }

    for (MenuItemView *item in itemView.subItems.allValues) {
        item.transform = CGAffineTransformIdentity;
        item.alpha = 1;
        MenuModel *menuItem = item.menuItem;        
        [item animateKeyPathsToValues:@{ @"position" : [NSValue valueWithCGPoint:[item positionForPolarCoordinate:PolarCoordinateMake(menuItem.distance, menuItem.angle)
                                                                                                       withCenter:self.center]] }];
    }

    for (MenuItemView *item in oldSubMenuItems) {
        [item animateKeyPathsToValues:@{ @"position" : [NSValue valueWithCGPoint:[item positionForPolarCoordinate:PolarCoordinateZero
                                                                                                       withCenter:oldCenterItem.center]],
                                         @"opacity": @(0.f) }];
        [self.connectorsLayer updateConnectorFrom:oldCenterItem.layer to:item.layer];
        item.transform = CGTransformScale;
    }
    
    [self.connectorsLayer updateConnectorsAnimated:YES];

    [CATransaction commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.centerItem.center = self.center;
    
    if (self.parentItem) {
        [self.parentItem setIntegralPolarCoordinate:PolarCoordinateMake(ParentItemRadius, ParentItemAngle) withCenter:self.center];
    }
    
    for (MenuItemView *subMenuItem in self.centerItem.subItems.allValues) {
        [subMenuItem sizeToFit];
        MenuModel *menuItem = subMenuItem.menuItem;
        [subMenuItem setIntegralPolarCoordinate:PolarCoordinateMake(menuItem.distance, menuItem.angle) withCenter:self.center];
    }
    
    if (!CGRectEqualToRect(self.connectorsLayer.frame, self.bounds)) {
        self.connectorsLayer.frame = self.bounds;
        [self.connectorsLayer updateConnectorsAnimated:NO];
    }
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//        
//    [[ClariantColors menuLineColor] set];
//    
//    CGContextSetLineWidth(context, 1);
//    
//    for (UIView *view in self.subviews) {
//        if ([view isKindOfClass:[MenuItemView class]]) {
//            MenuItemView *itemView = (MenuItemView *)view;
//            [itemView drawLinesToSubItemsInContext:context];
//        }
//    }
//    
//    CGContextStrokePath(context);
//}



@end
