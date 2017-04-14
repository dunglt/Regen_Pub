//
//  UserManager.h
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "CommonModel.h"
#import "UserData.h"
#import "DeviceContants.h"


@interface UserDataManager : NSObject

- (void)saveUserNameWhenLoginSuccess:(NSString *)user;
- (NSString *)getUserNameWhenLoginSuccess;

- (void)savePasswordWhenLoginSuccess:(NSString *)pw;
- (NSString *)getPasswordWhenLoginSuccess;

- (int) getUserID;

- (UserData*) getUserModel;

- (DeviceContants*) getDeviceToken;

@end
