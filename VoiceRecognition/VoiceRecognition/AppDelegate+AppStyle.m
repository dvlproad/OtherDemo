//
//  AppDelegate+AppStyle.m
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/3.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "AppDelegate+AppStyle.h"

#import "UIColor+VNHex.h"

@implementation AppDelegate (AppStyle)

- (void)customAppStyle {
    /* customize navigation style */
    [[UINavigationBar appearance] setBarTintColor:[UIColor systemColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
