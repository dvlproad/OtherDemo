//
//  AppDelegate.m
//  PushDemo
//
//  Created by lichq on 8/14/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>//
#pragma mark - 推送会调用的方法
//推送——如果app成功注册通知后，会调用这个函数，并把deviceToken返回给应用。
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //注册成功，将deviceToken保存到应用服务器数据库中
    NSLog(@"register success:%@", deviceToken);
}

//推送——如果注册的时候失败，ios会调用这个方法，可以打印一些报错日志或者提醒用户通知不可用
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"register fail:%@", error);
}

//推送——处理推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInfo == %@", userInfo);
    
    NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSLog(@"收到推送消息为:%@", message);
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                message:message
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"取消", nil)
                      otherButtonTitles:NSLocalizedString(@"确认", nil), nil] show];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    
}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>//
#pragma mark - 注册push（推送的形式：标记，声音，提示）
    //    if(!application.enabledRemoteNotificationTypes){
    //        NSLog(@"Initiating remoteNoticationssAreActive1");
    //    }
    
    
    //registerForRemoteNotificationTypes: is not supported in iOS 8.0 and later.
    //"remote notifications are not supported in the simulator" 所以推送只能在真机上测试
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge |
          UIUserNotificationTypeSound |
          UIUserNotificationTypeAlert
                                           categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert];
    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
    

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
