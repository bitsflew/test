//
//  CMGuidedSearchUnitSlider.h
//  MB Sales
//
//  Created by Craig on 26/02/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMGuidedSearchUnitSlider : UIView

@property (nonatomic, weak) IBOutlet UIView *thumbContainerView;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *unitSegmentedControl;

@property (nonatomic) CGFloat minimumValue;
@property (nonatomic) CGFloat maximumValue;

@property (nonatomic) CGFloat value;
@property (nonatomic) CGFloat thumbSize;

- (void)addUnitWithName:(NSString*)name formatString:(NSString*)formatString multiplier:(CGFloat)multiplier constant:(CGFloat)constant;

@end
