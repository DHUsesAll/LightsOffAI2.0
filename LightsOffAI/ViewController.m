//
//  ViewController.m
//  LightsOffAI
//
//  Created by rimi on 16/3/14.
//  Copyright © 2016年 武良威. All rights reserved.
//

#import "ViewController.h"
#import "DHLightGameManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DHLightGameManager * manager = [DHLightGameManager defaultManager];
    [manager layoutLightsWithRow:6 column:5];
    [self.view addSubview:manager.mainView];
    manager.mainView.center = self.view.center;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[DHLightGameManager defaultManager] showResolveResultsWithFailureHandler:^{
        
        NSLog(@"无解");
        
    }];
}



@end
