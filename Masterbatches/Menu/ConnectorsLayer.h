//
//  ConnectorsLayer.h
//  MB Sales
//
//  Created by Craig on 09/03/2015.
//  Copyright (c) 2015 Clariant. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface LineConnectorLayer : CAShapeLayer

@property (nonatomic, weak) CALayer *fromLayer;
@property (nonatomic, weak) CALayer *toLayer;

@end

@interface ConnectorsLayer : CALayer

- (LineConnectorLayer*)addLayerConnecting:(CALayer*)fromLayer to:(CALayer*)toLayer;
- (LineConnectorLayer*)layerConnecting:(CALayer*)fromLayer to:(CALayer*)toLayer;

- (void)updateConnectorFrom:(CALayer*)fromLayer to:(CALayer*)toLayer;

- (void)updateConnectorsAnimated:(BOOL)animated;

@end
