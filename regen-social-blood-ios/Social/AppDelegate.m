//
//  AppDelegate.m
//  Social
//
//  Created by Duong Tuan Dat on 10/19/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import "DeviceContants.h"
#import <Realm/Realm.h>
#import "UserData.h"
#import "UserDataManager.h"
#import "LibraryAPI.h"
#import "loginViewController.h"
#import "PushNotificationViewController.h"
#import "NewFeedVC.h"
#import "AGPushNoteView.h"
@import GoogleMaps;

@interface AppDelegate ()

@property UserData *userData;
@property long userID;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:GoogleMapAPI];
//    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(
                                                                                         UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    

    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Step 1
    NSLog(@"In here") ;
    [application registerForRemoteNotifications];
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Step 2
    
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    device = [device stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Devicetoken :%@" , device) ;
    UserDataManager *user = [[UserDataManager alloc]init];
    _userData = [user getUserModel];
    _userID = _userData.userId;
    DeviceContants *myDeviceToken = [[DeviceContants alloc] init];
    [myDeviceToken getDeviceTokenWithString:device];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:[DeviceContants allObjects]];
        [realm addOrUpdateObject:myDeviceToken];
    }];
    
    // gui len server cua invipi  device token
    //Type: Add registration_id for GCM service
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)]) {
        appState = application.applicationState;
    }
    application.applicationIconBadgeNumber = 0;
    if (appState != UIApplicationStateActive) {
        
        loginViewController *navigationController = (loginViewController *)self.window.rootViewController;
        UINavigationController *nav = (UINavigationController *)navigationController;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        NewFeedVC *controller = (NewFeedVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"NewFeedVC"];
        [nav pushViewController:controller animated:YES];
        
    }

    [LibraryAPI pushBadgeNumber:0 withUserID:_userID callBack:^(BOOL success, id result, id message) {
        if (success) {
            NSLog(@"success");
        }
        else NSLog(@"fail");
    }];

//  NSString *pushString= [userInfo description] ;
//    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"Hello" message:pushString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil] ;
//    [alertView show];

    if (application.applicationState == UIApplicationStateActive ) {
        NSLog(@"%@",[userInfo description]);
        [AGPushNoteView showWithNotificationMessage:[NSString stringWithFormat:@"%@",userInfo[@"aps"][@"alert"]]];
        [AGPushNoteView setMessageAction:^(NSString *message) {
            UINavigationController *naviController = (UINavigationController*)_window.rootViewController;
            //We then call the push view controller code
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            NewFeedVC *controller = (NewFeedVC*)[mainStoryboard instantiateViewControllerWithIdentifier: @"NewFeedVC"];
            [naviController pushViewController:controller animated:YES];
        }];

    }
    //self.textView.text = [userInfo description];
    // We can determine whether an application is launched as a result of the user tapping the action
    // button or whether the notification was delivered to the already-running application by examining
    // the application state.
    
    //    if (application.applicationState == UIApplicationStateActive)
    //    {
    //        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification" message:[NSString stringWithFormat:@"Your App name received this notification while it was running:\n%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //
    //        [alertView show];
    //    }
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UserDataManager *user = [[UserDataManager alloc]init];
    _userData = [user getUserModel];
    _userID = _userData.userId;
    DeviceContants *myDeviceToken = [[DeviceContants alloc]init];
    [myDeviceToken getDeviceTokenWithString:@"0"];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:[DeviceContants allObjects]];
        [realm addOrUpdateObject:myDeviceToken];
    }];
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@", error);
    
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
