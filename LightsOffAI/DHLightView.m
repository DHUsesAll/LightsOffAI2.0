//
//  DHLightView.m
//  TurnOffTheLights
//
//  Created by DreamHack on 16-3-9.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHLightView.h"

static NSString * const kDHLightViewFocusAnimationKey = @"kDHLightViewFocusAnimationKey";

@implementation DHLightView

- (instancetype)initWithFrame:(CGRect)frame coordinate:(DHCoordinate)coordinate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coordinate = coordinate;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.isOn = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame coordinate:DHCoordinateMake(0, 0)];
    return self;
}

#pragma mark - interface methods
- (void)startFocusAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"opacity";
    animation.fromValue = @1;
    animation.toValue = @0.1;
    animation.duration = 1;
    animation.autoreverses = YES;
    animation.repeatCount = CGFLOAT_MAX;
    
    [self.layer addAnimation:animation forKey:kDHLightViewFocusAnimationKey];
}

- (void)stopFocusAnimation
{
    [self.layer removeAnimationForKey:kDHLightViewFocusAnimationKey];
}


#pragma mark - setter
- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    if (isOn) {
        self.backgroundColor = [UIColor yellowColor];
    } else {
        self.backgroundColor = [UIColor darkGrayColor];
    }
}

@end
