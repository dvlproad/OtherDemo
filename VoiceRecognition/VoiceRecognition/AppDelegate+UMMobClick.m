//
//  AppDelegate+UMMobClick.m
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/3.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "AppDelegate+UMMobClick.h"

@implementation AppDelegate (UMMobClick)

- (void)setupUMMobClick {
    //[MobClick startWithAppkey:@"53c7945356240bd36002dabe" reportPolicy:BATCH channelId:nil];
    
    UMConfigInstance.appKey = @"55d08cd367e58e154c000d0d";
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = E_UM_NORMAL; //仅适用于游戏场景，应用统计不用设置
    //…
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

@end
