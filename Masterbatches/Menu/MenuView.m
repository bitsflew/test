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

@interface UIView (Polar)
- (void)setPolarCoordinate:(PolarCoordinate)polar withCenter:(CGPoint)center;
- (PolarCoordinate)polarCoordinateWithCenter:(CGPoint)center;
@end

@implementation UIView (Polar)

- (PolarCoordinate)polarCoordinateWithCenter:(CGPoint)center {
    CGFloat dx = self.center.x - center.x;
    CGFloat dy = self.center.y - center.y;

    return (PolarCoordinate){
        sqrt(dx * dx + dy * dy),
        atan2(dy, dx)
    };
}

- (void)setPolarCoordinate:(PolarCoordinate)polar withCenter:(CGPoint)center {
    CGFloat dx = cos(polar.angle) * polar.radius;
    CGFloat dy = sin(polar.angle) * polar.radius;

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

@end


@interface MenuView()
@property (nonatomic, strong) MenuItemView *centerItem;
@property (nonatomic, strong) MenuItemView *parentItem;
@property (nonatomic, strong) NSMutableArray *subItems;
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
    
    self.subItems = [NSMutableArray arrayWithCapacity:self.menu.subMenuItems.count];
    
    for (MenuModel *item in self.menu.subMenuItems) {
        MenuItemView *itemView = [self createViewForMenuItem:item];
        [itemView setPolarCoordinate:PolarCoordinateZero withCenter:self.centerItem.center];
        itemView.value = 0.2;
        [self.subItems addObject:itemView];
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

    if ([itemView isEqual:self.centerItem]) {
        return;
    }
    
    if ([itemView isEqual:self.parentItem]) {
        self.parentItem = nil; // Help!
        
        
    } else if ([self.subItems containsObject:itemView]) {
        self.parentItem = self.centerItem;
        
        [self.subItems removeObject:itemView];
    }
    
    self.menu = itemView.menuItem;
    self.centerItem = itemView;
    
    NSArray *subItems = self.subItems;
    
    [self createSubviews];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutSubviews];
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        for (MenuItemView *item in subItems) {
            [item setPolarCoordinate:PolarCoordinateZero withCenter:self.parentItem.center];
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
        [self layoutMenuItemView:self.parentItem atDistance:400 withAngle:M_PI * 1.7];
    }
    
    for (MenuItemView *subMenuItem in self.subItems) {
        [subMenuItem sizeToFit];
        [self layoutMenuItemView:subMenuItem
                      atDistance:subMenuItem.menuItem.distance
                       withAngle:subMenuItem.menuItem.angle];
    }
}

- (void)layoutMenuItemView:(MenuItemView *)itemView atDistance:(CGFloat)distance withAngle:(CGFloat)angle {
    CGFloat xOffset = cos(-M_PI / 2 + angle) * distance;
    CGFloat yOffset = sin(-M_PI / 2 + angle) * distance;
    
    itemView.center = CGPointMake(self.center.x + xOffset, self.center.y + yOffset);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    [[UIColor blackColor] set];
    
    CGContextSetLineWidth(context, 2);
    NSArray *items = self.subItems;
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
