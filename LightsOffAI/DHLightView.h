//
//  DHLightView.h
//  TurnOffTheLights
//
//  Created by DreamHack on 16-3-9.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DH_INLINE static inline

typedef struct _DHCoordinate {
    
    NSUInteger x;
    NSUInteger y;

} DHCoordinate;

DH_INLINE DHCoordinate DHCoordinateMake(NSUInteger x, NSUInteger y) {
    DHCoordinate coordinate;
    coordinate.x = x; coordinate.y = y;
    return coordinate;
}

DH_INLINE DHCoordinate DHCoordinateMakeWithCGPoint(CGPoint point) {
    DHCoordinate coordinate;
    coordinate.x = (NSUInteger)point.x;
    coordinate.y = (NSUInteger)point.y;
    return coordinate;
}


@interface DHLightView : UIControl

/**
 *  坐标，第几行第几列
 */
@property (nonatomic, assign) DHCoordinate coordinate;

/**
 *  默认关闭
 */
@property (nonatomic, assign) BOOL isOn;

- (void)startFocusAnimation;
- (void)stopFocusAnimation;



- (instancetype)initWithFrame:(CGRect)frame coordinate:(DHCoordinate)coordinate;
- (instancetype)initWithFrame:(CGRect)frame;

@end
