//
//  AppDelegate.m
//  VoiceRecognition
//
//  Created by lichq on 8/15/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppStyle.h"
#import "AppDelegate+UMMobClick.h"
#import "AppDelegate+IFly.h"

#import "NoteListController.h"
#import "VNConstants.h"
/*#import "WXApi.h"*/
#import "VNNote.h"
#import "VNNoteManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"Document路径 = %@",documentsDirectory);
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self addInitFileIfNeeded];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NoteListController *controller = [[NoteListController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    [self customAppStyle];
    [self setupUMMobClick];
    [self setupIFly];
    
    
    return YES;
}


- (void)addInitFileIfNeeded
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"hasInitFile"]) {
        VNNote *note = [[VNNote alloc] initWithTitle:NSLocalizedString(@"AboutTitle", @"")
                                             content:NSLocalizedString(@"AboutText", @"")
                                         createdDate:[NSDate date]
                                          updateDate:[NSDate date]];
        [[VNNoteManager sharedManager] storeNote:note];
        [userDefaults setBool:YES forKey:@"hasInitFile"];
        [userDefaults synchronize];
    }
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
