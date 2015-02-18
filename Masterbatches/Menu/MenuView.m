//
//  MenuView.m
//  Masterbatches
//
//  Created by Berik Visschers on 02-17.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "MenuView.h"
#import <UIKit/UIKit.h>

@interface MenuItemView : UIView
+ (instancetype)viewForMenuItem:(MenuModel *)item;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) MenuModel *menuItem;
@property (nonatomic, strong) UIView *line;
@end

@implementation MenuItemView

+ (instancetype)viewForMenuItem:(MenuModel *)item {
    MenuItemView *itemView = [[super alloc] initWithFrame:CGRectZero];
    itemView.menuItem = item;
    
    itemView.label = [UILabel new];
    [itemView addSubview:itemView.label];
    
    itemView.label.textColor = [UIColor blackColor];
    itemView.label.text = item.name;

    itemView.layer.borderColor = [UIColor blackColor].CGColor;
    itemView.layer.borderWidth = itemView.borderWidth;
    itemView.backgroundColor = [UIColor whiteColor];
    
    return itemView;
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
@property (nonatomic, strong) NSMutableArray *subItems;
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
    
    static CADisplayLink *displayLink = nil;
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)createSubviews {
    self.menu = [MenuModel readMenuFromFile];

    self.centerItem = [MenuItemView viewForMenuItem:self.menu];
    self.centerItem.value = 0.8;
    [self addSubview:self.centerItem];
    
    self.subItems = [NSMutableArray arrayWithCapacity:self.menu.subMenuItems.count];
    
    for (MenuModel *item in self.menu.subMenuItems) {
        MenuItemView *itemView = [MenuItemView viewForMenuItem:item];
        itemView.value = 0.2;
        [self.subItems addObject:itemView];
        [self insertSubview:itemView belowSubview:self.centerItem];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor blackColor];
        itemView.line = line;
        [self insertSubview:line atIndex:0];
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
    dispatch_resume(timer);

}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[MenuItemView class]]) {
            MenuItemView *menuItemView = (MenuItemView *)subView;
            [menuItemView sizeToFit];
            [self layoutMenuItemView:menuItemView];
        }
    }
}

- (void)layoutMenuItemView:(MenuItemView *)itemView {
    CGFloat xOffset = cos(-M_PI / 2 + itemView.menuItem.angle) * itemView.menuItem.distance;
    CGFloat yOffset = sin(-M_PI / 2 + itemView.menuItem.angle) * itemView.menuItem.distance;
    
    itemView.center = CGPointMake(self.center.x + xOffset, self.center.y + yOffset);
    
    if (itemView.line) {
        if (CGRectIsEmpty(itemView.line.frame)) {
            itemView.line.frame = CGRectMake(self.center.x + itemView.borderWidth / 2,
                                             self.center.y,
                                             itemView.borderWidth,
                                             itemView.menuItem.distance);
        }
        
        CGPoint offset = CGPointMake(itemView.line.frame.size.width / 2, itemView.line.frame.size.height / 2);
        CGAffineTransform transform = CGAffineTransformIdentity;
//        transform = CGAffineTransformTranslate(transform, -offset.x, -offset.y);
        transform = CGAffineTransformRotate(transform, -M_PI + itemView.menuItem.angle);
//        transform = CGAffineTransformTranslate(transform, offset.x, offset.y);
        
        
        itemView.line.transform = transform;
    }
}

@end
