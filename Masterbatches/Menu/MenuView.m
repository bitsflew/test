//
//  MenuView.m
//  Masterbatches
//
//  Created by Berik Visschers on 02-17.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "MenuView.h"
#import <UIKit/UIKit.h>

@class MenuItemView;

typedef void (^MenuItemSelectHandler)(MenuItemView *);

typedef struct {
    CGFloat radius;
    CGFloat angle;
} PolarCoordinate;

PolarCoordinate PolarCoordinateZero = (PolarCoordinate){0, 0};

PolarCoordinate PolarCoordinateMake(CGFloat radius, CGFloat angle) {
    return (PolarCoordinate){radius, angle};
}

@interface UIView (Polar)
- (void)setPolarCoordinate:(PolarCoordinate)polar withCenter:(CGPoint)center;
- (PolarCoordinate)polarCoordinateWithCenter:(CGPoint)center;
@end

@implementation UIView (Polar)

#define RotateToTop (-M_PI / 2)

- (PolarCoordinate)polarCoordinateWithCenter:(CGPoint)center {
    CGFloat dx = self.center.x - center.x;
    CGFloat dy = self.center.y - center.y;

    return (PolarCoordinate){
        sqrt(dx * dx + dy * dy),
        atan2(dy, dx) - RotateToTop
    };
}

- (void)setPolarCoordinate:(PolarCoordinate)polar withCenter:(CGPoint)center {
    CGFloat dx = cos(polar.angle + RotateToTop) * polar.radius;
    CGFloat dy = sin(polar.angle + RotateToTop) * polar.radius;

    self.center = (CGPoint){
        center.x + dx,
        center.y + dy
    };
}

@end

@interface MenuItemView : UIView
+ (instancetype)viewForMenuItem:(MenuModel *)item;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MenuModel *menuItem;
@property (nonatomic, strong) MenuItemSelectHandler menuItemSelectHandler;
@end

@implementation MenuItemView

+ (instancetype)viewForMenuItem:(MenuModel *)item {
    MenuItemView *itemView = [[super alloc] initWithFrame:CGRectZero];
    itemView.menuItem = item;
    
    itemView.label = [UILabel new];
    [itemView addSubview:itemView.label];
    
    itemView.label.textColor = [UIColor blackColor];
    itemView.label.text = item.name;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = itemView.frame;
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [button addTarget:itemView action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    itemView.button = button;
    [itemView addSubview:button];
    
    itemView.layer.borderColor = [UIColor blackColor].CGColor;
    itemView.layer.borderWidth = itemView.borderWidth;
    itemView.backgroundColor = [UIColor whiteColor];
    
    return itemView;
}

- (void)select:(id)sender {
    if (self.menuItemSelectHandler) self.menuItemSelectHandler(self);
}

- (void)setValue:(CGFloat)value {
    _value = value;
    
    self.label.font = [UIFont systemFontOfSize:[self fontSize]];
    [self sizeToFit];
}

- (CGFloat)borderWidth {
    return 2;
}

- (CGFloat)margin {
    return 15 + self.value * 4;
}

- (CGFloat)fontSize {
    return self.value * 100;
}

- (void)layoutSubviews {
    self.label.center = [self convertPoint:self.center fromView:self.superview];
    self.layer.cornerRadius = self.frame.size.width / 2;
}

- (void)sizeToFit {
    [super sizeToFit];
    [self.label sizeToFit];
    CGFloat width = self.label.frame.size.width + self.margin + 2 * self.borderWidth;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, width);
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
    [self createSubviews];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)createSubviews {
    if (self.menu == nil) self.menu = [MenuModel readMenuFromFile];

    if (self.centerItem == nil) {
        self.centerItem = [self createViewForMenuItem:self.menu];
        [self.centerItem setPolarCoordinate:PolarCoordinateZero withCenter:self.center];
        [self addSubview:self.centerItem];
    }
    
    self.centerItem.value = 0.3;
    
    self.subItems = [NSMutableDictionary dictionaryWithCapacity:self.menu.subMenuItems.count];
    
    for (MenuModel *item in self.menu.subMenuItems) {
        
        MenuItemView *itemView = self.subItems[@(item.identifier)];
        if (itemView == nil) {
            itemView = [self createViewForMenuItem:item];
            self.subItems[@(item.identifier)] = itemView;
        }
        
        [self createViewForMenuItem:item];
        [itemView setPolarCoordinate:PolarCoordinateZero withCenter:self.centerItem.center];
        itemView.value = 0.2;
        [self insertSubview:itemView belowSubview:self.centerItem];
    }
    
    CGFloat interval = 1;
    
    static dispatch_source_t timer = nil;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
    dispatch_source_set_event_handler(timer, ^{
        [UIView animateWithDuration:0.5 animations:^{
            for (MenuModel *item in self.menu.subMenuItems) {
                item.angle = item.angle + M_PI / 5;
            }
            [self layoutSubviews];
            [self setNeedsDisplay];
        }];
    });
//    dispatch_resume(timer);

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
    
    if ([itemView isEqual:self.parentItem]) {
        self.parentItem = nil; // Help!
        self.subItems[@(self.centerItem.menuItem.identifier)] = self.centerItem;
    } else if (isSubItem) {
        self.parentItem = self.centerItem;
        [self.subItems removeObjectForKey:@(itemView.menuItem.identifier)];
    }
    
    self.menu = itemView.menuItem;
    self.centerItem = itemView;
    
    NSArray *subItems = self.subItems.allValues;
    
    [self createSubviews];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutSubviews];
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        for (MenuItemView *item in subItems) {
            CGPoint center = self.parentItem ? self.parentItem.center : self.center;
            [item setPolarCoordinate:PolarCoordinateZero withCenter:center];
            item.alpha = 0;
        }
    } completion:^(BOOL finished) {
        [subItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.centerItem.center = self.center;
    
    if (self.parentItem) {
        [self.parentItem setPolarCoordinate:PolarCoordinateMake(350, M_PI * 1.7) withCenter:self.center];
    }
    
    for (MenuItemView *subMenuItem in self.subItems.allValues) {
        [subMenuItem sizeToFit];
        MenuModel *menuItem = subMenuItem.menuItem;
        [subMenuItem setPolarCoordinate:PolarCoordinateMake(menuItem.distance, menuItem.angle) withCenter:self.center];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    [[UIColor blackColor] set];
    
    CGContextSetLineWidth(context, 2);
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
