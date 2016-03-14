//
//  DHLightsOffAI.h
//  TurnOffTheLights
//
//  Created by rimi on 16/3/14.
//  Copyright © 2016年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHLightsOffAI : NSObject <NSCopying>

+ (DHLightsOffAI *)sharedAI;
- (id)copyWithZone:(NSZone *)zone;
+ (instancetype)allocWithZone:(struct _NSZone *)zone;


/**
 *  使用AI寻找一局关灯游戏的解法
 *
 *  @param row         要解决的这局关灯游戏灯的行数
 *  @param column      要解决的这局关灯游戏灯的列数
 *  @param coordinates 要解决的这局关灯游戏中当前哪些灯是亮着的，传入它们的坐标数组，数组中的元素是由NSValue对象代表的CGPoint
 *  @param queue       解决这局关灯游戏是异步进行的，这个参数指定了异步操作的队列。如果传入nil，则表示是默认的全局队列
 *  @param completion  解决完成后的回调block，results参数表示找到的解法，元素是由NSValue对象代表的CGPoint，success表示此局游戏是否有解
 */
- (void)startResolveWithRow:(NSUInteger)row
                     column:(NSUInteger)column
        lightsOnCoordinates:(NSArray *)coordinates
                    onQueue:(dispatch_queue_t)queue
          completionHandler:(void(^)(NSArray * results, BOOL success))completion;

@end