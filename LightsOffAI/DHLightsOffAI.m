//
//  DHLightsOffAI.m
//  TurnOffTheLights
//
//  Created by rimi on 16/3/14.
//  Copyright © 2016年 DreamHack. All rights reserved.
//

#import "DHLightsOffAI.h"
#import <UIKit/UIKit.h>

static DHLightsOffAI * lightsOffAI_ = nil;

@interface DHLightsOffAI ()

@property (nonatomic, strong) NSMutableArray * results;
@property (nonatomic, strong) NSArray * lightsOnCoordinate;
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;

/**
 *  找到第一排灯的正确状态以确保在用最后一排的灯关掉倒数一排的灯后最后一排的灯直接全部处于关闭状态
 */
- (BOOL)_findFirstRowState;

/**
 *  模拟关掉C语言二维数组中坐标为x，y的那个元素
 *
 *  @param x x
 *  @param y y
 */
- (void)_turnLightAtX:(int)x y:(int)y forLights:(int **)lightStates;

@end

@implementation DHLightsOffAI

#pragma mark - singleton

+ (DHLightsOffAI *)sharedAI
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lightsOffAI_ = [[self alloc] init];
    });
    return lightsOffAI_;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!lightsOffAI_) {
        lightsOffAI_ = [super allocWithZone:zone];
    }
    return lightsOffAI_;
}



#pragma mark - interface methods
- (void)startResolveWithRow:(NSUInteger)row column:(NSUInteger)column lightsOnCoordinates:(NSArray *)coordinates onQueue:(dispatch_queue_t)queue completionHandler:(void(^)(NSArray * results, BOOL success))completion
{
    [self.results removeAllObjects];
    self.row = row;
    self.column = column;
    self.lightsOnCoordinate = coordinates;
    if (!queue) {
        queue = dispatch_get_global_queue(0, 0);
    }
    dispatch_async(queue, ^{
        BOOL state = [self _findFirstRowState];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(_results, state);
            });
        }
    });
}


#pragma mark - private methods
- (BOOL)_findFirstRowState
{
    // no表示无解
    BOOL state = NO;
    NSUInteger row = _row;
    NSUInteger column = _column;
    
    // 用一个C语言二维数组来代表每个灯的状态，0表示关，1表示开
    int ** stateArray = malloc(sizeof(int *) * row);
    
    for (int i = 0; i < row; i++) {
        stateArray[i] = malloc(sizeof(int) * column);
        memset(stateArray[i], 0, sizeof(int) * column);
    }
    
    [self.lightsOnCoordinate enumerateObjectsUsingBlock:^(NSValue * coordinateValue, NSUInteger idx, BOOL *stop) {
        
        CGPoint coordinate = [coordinateValue CGPointValue];
        
        NSUInteger x = coordinate.x;
        NSUInteger y = coordinate.y;
        stateArray[y][x] = 1;
    }];
    
    // 用一个column位的二进制数表示第一排灯按不按的状态，1表示按，0表示不按
    // firstLineState二进制表示的后column位是第一排灯按不按
    int firstLineState = 0;
    for (int i = 0; i < pow(2, column); i++) {
        
        
        // n = 1000...00, 1后面column-1个0
        int n = pow(2, column-1);
        
        // 比如resultArray里面的内容是 00101，则表示第一排第三个和第五个灯泡按一下
        int * resultArray = malloc(sizeof(int) * column);
        memset(resultArray, 0, sizeof(int) * column);
        
        for (int j = 0; j < column; j++) {
            
            int result = firstLineState & n;
            n = n >> 1;
            if (result) {
                resultArray[j] = 1;
            }
            
        }
        
        
        // 拷贝一份stateArray
        
        int ** temp = malloc(sizeof(int *) * row);
        
        for (int i = 0; i < row; i++) {
            temp[i] = malloc(sizeof(int) * column);
            memcpy(temp[i], stateArray[i], sizeof(int) * column);
        }
        
        // 根据resultArray关掉第一排
        for (int i = 0; i < column; i++) {
            if (resultArray[i]) {
                [self _turnLightAtX:i y:0 forLights:temp];
                [self.results addObject:[NSValue valueWithCGPoint:CGPointMake(i, 0)]];
            }
            
        }
        
        // 依次关掉后面的灯
        for (int i = 1; i < row; i++) {
            
            for (int j = 0; j < column; j++) {
                
                if (temp[i-1][j] == 1) {
                    [self _turnLightAtX:j y:i forLights:temp];
                    [self.results addObject:[NSValue valueWithCGPoint:CGPointMake(j, i)]];
                }
            }
        }
        // 看最后一行里面是不是全为0，如果全为0，则break
        int lastResult = 0;
        for (int i = 0; i < column; i++) {
            lastResult += temp[row - 1][i];
        }
        
        if (lastResult == 0) {
            free(resultArray);
            for (int i = 0; i < row; i++) {
                free(temp[i]);
            }
            free(temp);
            state = YES;
            NSLog(@"解法：%@",self.results);
            break;
        } else {
            [self.results removeAllObjects];
        }
        firstLineState++;
        free(resultArray);
        for (int i = 0; i < row; i++) {
            free(temp[i]);
        }
        free(temp);
    }
    
    for (int i = 0; i < row; i++) {
        free(stateArray[i]);
    }
    
    free(stateArray);
    return state;
}

- (void)_turnLightAtX:(int)x y:(int)y forLights:(int **)lightStates
{
    lightStates[y][x] = !lightStates[y][x];
    if (y-1 >= 0) {
        lightStates[y-1][x] = !lightStates[y-1][x];
    }
    if (x-1 >= 0) {
        lightStates[y][x-1] = !lightStates[y][x-1];
    }
    if (y+1 <  _row) {
        lightStates[y+1][x] = !lightStates[y+1][x];
    }
    if (x+1 <  _column) {
        lightStates[y][x+1] = !lightStates[y][x+1];
    }
}



#pragma mark - getter
- (NSMutableArray *)results
{
    if (!_results) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    return _results;
}



@end
