//
//  AppDelegate+IFly.m
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/4.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "AppDelegate+IFly.h"
#import <iflyMSC/iflyMSC.h>

//#define APPID_VALUE           @"55d0c2fb"
#define APPID_VALUE           @"56e005aa"

@implementation AppDelegate (IFly)

- (void)setupIFly {
//    <#!!!特别提醒：                                                                #>
//
//    <#  1、在集成讯飞语音SDK前请特别关注下面设置，主要包括日志文件设置、工作路径设置和appid设置。#>
//
//    <#2、在启动语音服务前必须传入正确的appid。#>
//
//    <#3、SDK运行过程中产生的音频文件和日志文件等都会保存在设置的工作路径下。#>
    
    /*
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    */
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    //NSString *initString = [NSString stringWithFormat:@"%@=%@", [IFlySpeechConstant APPID], kIFlyAppID];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

@end
