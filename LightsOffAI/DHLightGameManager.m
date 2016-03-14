//
//  DHTOTLManager.m
//  TurnOffTheLights
//
//  Created by DreamHack on 16-3-9.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHLightGameManager.h"
#import "DHLightView.h"
#import "DHLightsOffAI.h"

static DHLightGameManager * manager_ = nil;
static const CGFloat size_ = 40;
static const CGFloat interval_ = 2;


@interface DHLightGameManager ()

@property (nonatomic, strong) UIView * mainView;
@property (nonatomic, strong) NSMutableArray * lightsOnCoordinate;
@property (nonatomic, strong) NSMutableArray * lightsViewContainer;

- (DHLightView *)_lightViewWithCoordinate:(DHCoordinate)coordinate;

@end

@implementation DHLightGameManager

#pragma mark - singleton

+ (DHLightGameManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager_ = [[self alloc] init];
    });
    return manager_;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!manager_) {
        manager_ = [super allocWithZone:zone];
    }
    return manager_;
}



#pragma mark - interface methods
- (void)forceDealloc
{
    [self.lightsViewContainer makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.lightsViewContainer = nil;
    [self.mainView removeFromSuperview];
    self.mainView = nil;
    self.lightsOnCoordinate = nil;
}

- (void)reset
{
    [self.lightsOnCoordinate removeAllObjects];
    [self.lightsViewContainer enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DHLightView * lightView = obj;
        lightView.isOn = arc4random()%2;
        [lightView stopFocusAnimation];
    }];
    [self.lightsViewContainer removeAllObjects];
}

- (void)layoutLightsWithRow:(NSUInteger)row column:(NSUInteger)column
{
    self.mainView.frame = CGRectMake(0, 0, column * size_ + (column - 1) * interval_, row * size_ + (row - 1) * interval_);
    [self reset];
    _row = row;
    _column = column;
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            DHLightView * lightView = [[DHLightView alloc] initWithFrame:CGRectMake(0, 0, size_, size_) coordinate:DHCoordinateMake(j, i)];
            lightView.center = CGPointMake(j * (size_ + interval_)+ size_/2, i * (size_ + interval_) + size_/2);
            [lightView addTarget:self action:@selector(onLight:) forControlEvents:UIControlEventTouchUpInside];
            [self.lightsViewContainer addObject:lightView];
            [self.mainView addSubview:lightView];
        }
    }
}

- (void)showResolveResultsWithFailureHandler:(void (^)(void))failure
{
    [self.lightsViewContainer makeObjectsPerformSelector:@selector(stopFocusAnimation)];

    [[DHLightsOffAI sharedAI] startResolveWithRow:_row column:_column lightsOnCoordinates:self.lightsOnCoordinate onQueue:nil completionHandler:^(NSArray *results, BOOL success) {
        
        if (success) {
            [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSValue * coordinateValue = (NSValue *)obj;
                DHCoordinate coordinate = DHCoordinateMakeWithCGPoint([coordinateValue CGPointValue]);
                DHLightView * lightView = [self _lightViewWithCoordinate:coordinate];
                [lightView startFocusAnimation];
                
            }];
        } else {
            if (failure) {
                failure();
            }
        }
        
    }];
}

#pragma mark - private methods
- (DHLightView *)_lightViewWithCoordinate:(DHCoordinate)coordinate
{
    // 根据总行数和当前坐标算出数组下标
    // 因为放进数组的顺序是一行一行的放的
    // 每行有_row个灯
    NSInteger index = coordinate.y * _column + coordinate.x;
    
    return self.lightsViewContainer[index];
}

#pragma mark - action
- (void)onLight:(DHLightView *)sender
{
    sender.isOn = !sender.isOn;
    CGPoint point = CGPointMake(sender.coordinate.x, sender.coordinate.y);
    if (sender.isOn) {
        [self.lightsOnCoordinate addObject:[NSValue valueWithCGPoint:point]];
    } else {
        [self.lightsOnCoordinate removeObject:[NSValue valueWithCGPoint:point]];
    }
}

#pragma mark - getter
- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _mainView;
}

- (NSMutableArray *)lightsOnCoordinate
{
    if (!_lightsOnCoordinate) {
        _lightsOnCoordinate = [NSMutableArray arrayWithCapacity:0];
    }
    return _lightsOnCoordinate;
}

- (NSMutableArray *)lightsViewContainer
{
    if (!_lightsViewContainer) {
        _lightsViewContainer = ({
            
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            array;
            
        });
    }
    return _lightsViewContainer;
}

@end


