//
//  DHTOTLManager.h
//  TurnOffTheLights
//
//  Created by DreamHack on 16-3-9.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DHLightGameManager : NSObject<NSCopying>

@property (nonatomic, assign, readonly) NSUInteger row;
@property (nonatomic, assign, readonly) NSUInteger column;

/**
 *  主要负责显示的视图，需手动设置frame
 */
@property (nonatomic, strong, readonly) UIView * mainView;


+ (DHLightGameManager *)defaultManager;
- (id)copyWithZone:(NSZone *)zone;
+ (instancetype)allocWithZone:(struct _NSZone *)zone;

/**
 *  强制移除视图所占的内存
 */
- (void)forceDealloc;

/**
 *  重新开始游戏
 */
- (void)reset;

/**
 *  对所有的灯泡进行布局
 *
 *  @param row    灯泡的行数
 *  @param column 灯泡的列数
 */
- (void)layoutLightsWithRow:(NSUInteger)row column:(NSUInteger)column;

/**
 *  展示解法，解法将通过对需要点击的灯进行闪烁来展示
 *
 *  @param failure 如果没有解，将回调这个block
 */
- (void)showResolveResultsWithFailureHandler:(void(^)(void))failure;

@end



