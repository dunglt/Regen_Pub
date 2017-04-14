//
//  LibraryAPI.m
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import "LibraryAPI.h"
#import <UIKit/UIKit.h>

static LibraryAPI *_staticLibrary;
UserData *userData;

@implementation LibraryAPI
{
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.network = [[NetworkManager alloc] init];
        self.model = [[ModelManager alloc] init];
        self.user = [[UserDataManager alloc] init];
    }
    return self;
}

#pragma mark - singleton
+ (LibraryAPI *)shareInstance{
    static LibraryAPI *shareInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        shareInstance = [[LibraryAPI alloc] init];
    }
                  );
    
    return shareInstance;
}

#pragma mark - get instance variable
+ (UserDataManager *)getUserDataManager {
    _staticLibrary = [LibraryAPI shareInstance];
    
    return _staticLibrary.user;
}

+ (UserData *)getUserData {
    return userData;
}



//Register

+(void)requestToRegisterWithEmail:(NSString *)email passWord:(NSString *)pw phone:(NSString *)phone bloodTypeId:(long)bloodType address:(NSString *)address location:(CLLocationCoordinate2D)location avatar:(NSString *)avatar callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"email" : email,
                             @"password" : pw,
                             @"mobile": phone,
                             @"bloodTypeId": [NSString stringWithFormat:@"%ld",bloodType],
                             @"address": address,
                             @"latitudeY": [NSString stringWithFormat:@"%f",location.latitude],
                             @"longitudeX": [NSString stringWithFormat:@"%f",location.longitude],
                             @"firstName": @" ",
                             @"lastName": @" ",
                             @"sex" : @"true",
                             @"identifyCard": @" ",
                             @"avatar":avatar
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_REGISTER parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

//Login

+(void)logInWithEmail:(NSString *)email andPassword:(NSString *)pw callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"email" : email,
                             @"password" : pw
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_LOGIN parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+ (void) requestToSettingProfileWithUserId:(int)userId passWord:(NSString*)pw name:(NSString*)name bloodTypeId:(long)bloodType sex:(BOOL)sex address:(NSString*)add phone:(NSString*)phone location:(CLLocationCoordinate2D)location identifyCard:(NSString*)identifyCard avatar:(NSString*)avatar callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"email":@"",
                             @"identifyCard":identifyCard,
                             @"lastName" : name,
                             @"firstName" : @"",
                             @"bloodTypeId" : [NSString stringWithFormat:@"%ld",bloodType],
                             @"sex" : sex?@"true":@"false",
                             @"address" : add,
                             @"mobile" : phone,
                             @"password":pw,
                             @"userID":[NSString stringWithFormat:@"%d",userId],
                             @"longitudeX":[NSString stringWithFormat:@"%f",location.longitude],
                             @"latitudeY":[NSString stringWithFormat:@"%f",location.latitude],
                             @"avatar":avatar
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_SETTING parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];

}
+(void)requestToUpdateStatusBloodDonationWithUserId:(int)userId andStatus:(BOOL)status callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%d",userId],
                             @"DonatingYN":status?@"true":@"false"
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_UPDATE_STATUS parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}
+ (void) requestToFindAllDonorAroundWithUserId:(int)userId location:(CLLocationCoordinate2D)location radius:(NSString*)radius bloodTypeID:(int)bloodTypeID callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%d",userId],
                             @"radius": radius,
                             @"longitudeX":[NSString stringWithFormat:@"%f",location.longitude],
                             @"latitudeY":[NSString stringWithFormat:@"%f",location.latitude],
                             @"bloodTypeID": [NSString stringWithFormat:@"%d",bloodTypeID]
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_FIND_AROUND parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];

}
+(void)requestToChangePassword:(int)userId passWord:(NSString *)pw callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%d",userId],
                             @"password": pw,
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_SETTING parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        } else
            cb(NO,result,message);
    }];
}
+(void)requestToUpdateUserFindBloodWithUserId:(int)userId location:(CLLocationCoordinate2D)location radius:(NSString*)radius callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%d",userId],
                             @"longitudeX":[NSString stringWithFormat:@"%f",location.longitude],
                             @"latitudeY":[NSString stringWithFormat:@"%f",location.latitude],
                             @"radius":radius
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_UPDATE_USER_FIND_BLOOD parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+(void)checkEmailWithmail:(NSString *)email callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"email":email
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_CHECK_EMAIL parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+(void)checkPhoneWithPhone:(NSString *)phone callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"phoneNumber":phone
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_CHECK_PHONE parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+(void)sendPasswordToEmail:(NSString *)email callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"email":email
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_SEND_PASSWORD_TO_EMAIL parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+(void)uploadImage:(NSString *)content callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"content":content
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_UPLOAD_IMAGE parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+(void)addDeviceToken:(NSString *)token withUserID:(long)userID callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"deviceTokenID":token,
                             @"userID":[NSString stringWithFormat:@"%ld",userID],
                             @"osType":@"IOS"
                            };
    [_staticLibrary.network requestToServicesWithURL:URL_ADD_DEVICE_TOKEN parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+(void)pushBadgeNumber:(long)badge withUserID:(long)userID callBack:(AuthenticationCallback)cb{
    _staticLibrary = [LibraryAPI shareInstance];
    NSDictionary *params = @{@"numBadge":[NSString stringWithFormat:@"%ld",badge],
                             @"userID":[NSString stringWithFormat:@"%ld",userID]
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_PUSH_NUMBER_BADGE parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+(void)pushNotificationWithUserID:(long)userID deviceToken:(NSString *)deviceToken location:(CLLocationCoordinate2D)location bloodTypeID:(long)bloodTypeID radius:(NSString*)radius callBack:(AuthenticationCallback)cb{
    NSDictionary *params = @{
                             @"userID":[NSString stringWithFormat:@"%ld",userID],
                             @"deviceToken":deviceToken,
                             @"longitudeX":[NSString stringWithFormat:@"%f",location.longitude],
                             @"latitudeY":[NSString stringWithFormat:@"%f",location.latitude],
                             @"bloodTypeID":[NSString stringWithFormat:@"%ld",bloodTypeID],
                             @"radius":radius
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_PUSH_NOTIFICATION parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

+(void)getUserInfoWithUserID:(long)userID callBack:(AuthenticationCallback)cb{
    NSDictionary *params = @{
                             @"userID":[NSString stringWithFormat:@"%ld",userID],
                            };
    [_staticLibrary.network requestToServicesWithURL:URL_GET_USER_INFO parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];

}
+(void)getNewsFeedWithUserID:(long)userID callBack:(AuthenticationCallback)cb{
    NSDictionary *params = @{
                             @"userID":[NSString stringWithFormat:@"%ld",userID],
                             };
    [_staticLibrary.network requestToServicesWithURL:URL_GET_NEWS_FEED parameter:params completion:^(ErrorCodes code, id result, id message) {
        if (code == ErrorCodesOk) {
            cb(YES,result,message);
        }
        else
            cb(NO,result,message);
    }];
}

@end
