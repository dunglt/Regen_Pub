//
//  UserManager.m
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import "UserDataManager.h"
#import "CommonModel.h"

@implementation  UserDataManager
{
    NSUserDefaults *_userDefault;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)saveUserNameWhenLoginSuccess:(NSString *)user {
    [_userDefault setObject:user forKey:kUserNameWhenLoginSuccess];
}
- (NSString *)getUserNameWhenLoginSuccess {
    return [_userDefault objectForKey:kUserNameWhenLoginSuccess];
}

- (void)savePasswordWhenLoginSuccess:(NSString *)pw {
    [_userDefault setObject:pw forKey:kPasswordWhenLoginSuccess];
}

- (NSString *)getPasswordWhenLoginSuccess {
    return [_userDefault objectForKey:kPasswordWhenLoginSuccess];
}

-(UserData *)getUserModel{
    RLMResults *_results = [UserData allObjects];
    UserData *user;
    user = [_results lastObject];
    return user;
}

-(int)getUserID{
    UserData *user = [self getUserModel];
    return user.userId;
}

-(DeviceContants *)getDeviceToken{
    RLMResults *_results = [DeviceContants allObjects];
    DeviceContants *deviceToken;
    deviceToken = [_results lastObject];
    return deviceToken;
}


@end
