//
//  CMChecklistView.m
//  MB Sales
//
//  Created by Craig on 27/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import "CMChecklistView.h"

@interface CMChecklistButton : UIView

@property (nonatomic) BOOL checked;
@property (nonatomic) BOOL highlighted;
@property (nonatomic) BOOL useRadioStyle;
@property (nonatomic, retain) id<CMChecklistItem> item;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, strong) CALayer *checkLayer;
@property (nonatomic, retain) UIView *accessoryView;

@end

static const CGFloat kCMChecklistButtonSize = 20.f;
static const CGFloat kCMChecklistButtonSpacing = 13.f;
static const CGFloat kCMChecklistButtonFontSize = 13.f;
static const CGSize  kCMChecklistButtonCheckSize = (CGSize){ 24.f, 19.f};
static const CGFloat kCMChecklistButtonCheckScale = 0.5f;

@implementation CMSimpleChecklistItem

+ (instancetype)itemWithTitle:(NSString*)title {
    CMSimpleChecklistItem *item = [CMSimpleChecklistItem new];
    item.title = title;
    return item;
}

@end

@implementation CMChecklistButton

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:1.f].CGColor;
    self.layer.masksToBounds = YES;

    self.label = [UILabel new];
    self.label.font = [UIFont fontWithName:@"Gotham-Book" size:kCMChecklistButtonFontSize];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;

    self.checkLayer = [CALayer layer];
    self.checkLayer.contents = (__bridge id)([UIImage imageNamed:@"ic_checkmark_blue.png"].CGImage);
    self.checkLayer.position = CGPointMake(kCMChecklistButtonSize/2.f, kCMChecklistButtonSize/2.f);
    self.checkLayer.bounds = (CGRect){ CGPointZero, kCMChecklistButtonCheckSize};
    
    [self.layer addSublayer:self.checkLayer];

    self.checked = NO;

    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setItem:(id<CMChecklistItem>)item
{
    _item = item;

    self.label.text = [item title];
    self.accessoryView = [item respondsToSelector:@selector(accessoryView)] ? [item accessoryView] : nil;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;

    self.layer.borderColor = (checked ? [UIColor colorWithRed:0.309 green:0.745 blue:0.87 alpha:1] : [UIColor colorWithWhite:0.7f alpha:1.f]).CGColor;
    self.layer.borderWidth = checked ? 2.f : 1.f;

    CGFloat scale = checked ? kCMChecklistButtonCheckScale : 0.1f;
    self.checkLayer.transform = CATransform3DMakeScale(scale, scale, 1.f);
    self.checkLayer.opacity = checked ? 1.f : 0.f;
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    
    self.alpha = highlighted ? 0.5f : 1.f;
}

- (void)setUseRadioStyle:(BOOL)useRadioStyle
{
    self.layer.cornerRadius = useRadioStyle ? kCMChecklistButtonSize/2.f : 0.f;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(kCMChecklistButtonSize, kCMChecklistButtonSize);
}

@end

@interface CMChecklistView ()

@property (nonatomic, retain) NSMutableArray *buttons;

@end

@implementation CMChecklistView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return (self = [super initWithCoder:aDecoder]) ? [self commonInit] : nil;
}

- (id)initWithFrame:(CGRect)frame
{
    return (self = [super initWithFrame:frame]) ? [self commonInit] : nil;
}

- (id)commonInit
{
    self.buttons = [NSMutableArray new];
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;

    return self;
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;

    [self updateViews];
}

- (void)checkItem:(id<CMChecklistItem>)item
{
    [self checkItems:item ? @[ item ] : @[]];
}

- (void)checkItems:(NSArray *)items
{
    if (!items) {
        items = @[];
    }

    for (CMChecklistButton *button in self.buttons) {
        button.checked = [items containsObject:button.item];

        if ([button.item respondsToSelector:@selector(setEnabled:forAccessoryView:fromUser:)]) {
            [button.item setEnabled:button.checked forAccessoryView:button.accessoryView fromUser:NO];
        }
    }
}

- (void)setItems:(NSArray *)items
{
    _items = items;

    [self updateViews];
}

- (void)setOrientation:(CMChecklistOrientation)orientation
{
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];

    _orientation = orientation;

    [self updateViews];
}

- (NSArray*)checkedItems
{
    NSMutableArray *checkedItems = [NSMutableArray new];
    for (CMChecklistButton *button in self.buttons) {
        if (button.checked && button.item) {
            [checkedItems addObject:button.item];
        }
    }
    return checkedItems;
}

#pragma mark -

- (CGSize)intrinsicContentSize
{
    CGRect frames = CGRectZero;
    for (CMChecklistButton *button in self.buttons) {
        frames = CGRectUnion(CGRectUnion(frames, button.frame), button.label.frame);
        if (button.accessoryView) {
            frames = CGRectUnion(frames, button.accessoryView.frame);
        }
    }

    return CGSizeMake(CGRectGetMaxX(frames), CGRectGetMaxY(frames));
}

#pragma mark -

- (void)updateViews
{
    CMChecklistButton *previousButton = nil;
    CGFloat maximumLabelWidth = 0.f;

    NSMutableArray *buttonsWithAddedAccessoryViews = [NSMutableArray new];
    
    for (int i=0; i<self.items.count; i++) {
        CMChecklistButton *button;
        if (i < self.buttons.count) {
            button = self.buttons[i];
        } else {
            button = [CMChecklistButton new];
            [self.buttons addObject:button];
            [self addSubview:button];
            [self addSubview:button.label];

            button.item = self.items[i];

            if (button.accessoryView) {
                [self addSubview:button.accessoryView];
                [buttonsWithAddedAccessoryViews addObject:button]; // for setting constraints
            }

            switch (self.orientation) {
                case CMChecklistOrientationHorizontal:
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.f
                                                                      constant:0.f]];

                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.f
                                                                      constant:kCMChecklistButtonSize]];
                    
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button.label
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:button
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.f
                                                                      constant:kCMChecklistButtonSpacing]];
                    
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button.label
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:button
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.f
                                                                      constant:0.f]];
                    
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button.label
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:button
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.f
                                                                      constant:0.f]];

                    if (previousButton) {
                        [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:previousButton.label
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.f
                                                                          constant:kCMChecklistButtonSpacing*2.f]];
                        
                    } else {
                        [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.f
                                                                          constant:0.f]];
                    }
                    
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.f
                                                                      constant:kCMChecklistButtonSize]];

                    break;
                default:
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.f
                                                                      constant:0.f]];
                    
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.f
                                                                      constant:kCMChecklistButtonSize]];
                    
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button.label
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:button
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.f
                                                                      constant:kCMChecklistButtonSpacing]];
                    
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button.label
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:button
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.f
                                                                      constant:0.f]];
                    
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button.label
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:button
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.f
                                                                      constant:0.f]];

                    if (!button.accessoryView) {
                        [self addConstraint:[NSLayoutConstraint constraintWithItem:button.label
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.f
                                                                          constant:0.f]];
                    } else {
                        // Accessory views are aligned to the longest label; therefore we rely on label autosizing
                        maximumLabelWidth = fmaxf(maximumLabelWidth, [button.label intrinsicContentSize].width);
                    }
                    
                    if (previousButton) {
                        [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:previousButton.label
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.f
                                                                          constant:kCMChecklistButtonSpacing]];
                    } else {
                        [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.f
                                                                          constant:0.f]];
                    }

                    if (button.accessoryView) {
                        [self addConstraint:[NSLayoutConstraint constraintWithItem:button.accessoryView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:button
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.f
                                                                          constant:0.f]];
                    }

                    
                    break;
            }
        }

        button.useRadioStyle = !self.allowsMultipleSelection;

        previousButton = button;
    }
    
    for (CMChecklistButton *button in buttonsWithAddedAccessoryViews) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button.accessoryView
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.f
                                                          constant:kCMChecklistButtonSize + kCMChecklistButtonSpacing*2.f + maximumLabelWidth]];

        if ([button.item respondsToSelector:@selector(setEnabled:forAccessoryView:fromUser:)]) {
            [button.item setEnabled:button.checked forAccessoryView:button.accessoryView fromUser:NO];
        }
    }

    while (self.buttons.count > self.items.count) {
        id button = self.buttons.lastObject;
        [[button accessoryView] removeFromSuperview];
        [[button label] removeFromSuperview];
        [button removeFromSuperview];
    }

    [self invalidateIntrinsicContentSize];
}

#pragma mark -

- (CMChecklistButton*)buttonAtTouch:(UITouch*)touch
{
    CGPoint location = [touch locationInView:self];
    CGFloat touchInset = -kCMChecklistButtonSpacing/2.f;
    for (CMChecklistButton *button in self.buttons) {
        if (CGRectContainsPoint(CGRectInset(CGRectUnion(button.frame, button.label.frame), touchInset, touchInset), location)) {
            return button;
        }
    }
    return nil;
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self buttonAtTouch:[touches anyObject]].highlighted = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (CMChecklistButton *button in self.buttons) {
        button.highlighted = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL valueChanged = NO;
    CMChecklistButton *touchedButton = [self buttonAtTouch:[touches anyObject]];

    if (touchedButton.highlighted) {
        touchedButton.checked = !touchedButton.checked;
        if ([touchedButton.item respondsToSelector:@selector(setEnabled:forAccessoryView:fromUser:)]) {
            [touchedButton.item setEnabled:touchedButton.checked forAccessoryView:touchedButton.accessoryView fromUser:YES];
        }
        valueChanged = YES;
    }

    for (CMChecklistButton *button in self.buttons) {
        button.highlighted = NO;
        if ((touchedButton!=button) && !self.allowsMultipleSelection && touchedButton.checked && button.checked) {
            button.checked = NO;
            valueChanged = YES;
            if ([button.item respondsToSelector:@selector(setEnabled:forAccessoryView:fromUser:)]) {
                [button.item setEnabled:NO forAccessoryView:button.accessoryView fromUser:YES];
            }
        }
    }

    if (valueChanged) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
