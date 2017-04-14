//
//  LibraryAPI.h
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "UserDataManager.h"
#import "ModelManager.h"
#import "UserData.h"

@class NetworkManager;
@interface LibraryAPI : NSObject
@property (nonatomic, retain) NetworkManager *network;
@property (nonatomic, retain) ModelManager *model;
@property (nonatomic, retain) UserDataManager *user;


+ (LibraryAPI*) shareInstance;

+ (UserData *)getUserData;

+ (UserDataManager *)getUserDataManager;

+ (void) logInWithEmail:(NSString*)email andPassword:(NSString*)pw callBack:(AuthenticationCallback)cb;

+ (void) requestToRegisterWithEmail:(NSString*)email passWord:(NSString*)pw phone:(NSString*)phone bloodTypeId:(long)bloodType address:(NSString*)address location:(CLLocationCoordinate2D)location avatar:(NSString*)avatar callBack:(AuthenticationCallback)cb;

+ (void) requestToSettingProfileWithUserId:(int)userId passWord:(NSString*)pw name:(NSString*)name bloodTypeId:(long)bloodType sex:(BOOL)sex address:(NSString*)add phone:(NSString*)phone location:(CLLocationCoordinate2D)location identifyCard:(NSString*)identifyCard avatar:(NSString*)avatar  callBack:(AuthenticationCallback)cb;

+ (void) requestToUpdateStatusBloodDonationWithUserId:(int)userId andStatus:(BOOL)status callBack:(AuthenticationCallback)cb;

+ (void) requestToFindAllDonorAroundWithUserId:(int)userId location:(CLLocationCoordinate2D)location radius:(NSString*)radius bloodTypeID:(int)bloodTypeID callBack:(AuthenticationCallback)cb;

+ (void) requestToChangePassword:(int)userId passWord:(NSString*)pw callBack:(AuthenticationCallback)cb;

+ (void) requestToUpdateUserFindBloodWithUserId:(int)userId location:(CLLocationCoordinate2D)location radius:(NSString*)radius callBack:(AuthenticationCallback)cb;

+ (void) checkEmailWithmail:(NSString*)email callBack:(AuthenticationCallback)cb;

+ (void) checkPhoneWithPhone:(NSString*)phone callBack:(AuthenticationCallback)cb;

+ (void) sendPasswordToEmail:(NSString*)email callBack:(AuthenticationCallback)cb;

+ (void) uploadImage:(NSString*)content callBack:(AuthenticationCallback)cb;

+ (void) addDeviceToken:(NSString*)token withUserID:(long)userID callBack:(AuthenticationCallback)cb;

+ (void) pushBadgeNumber:(long)badge withUserID:(long)userID callBack:(AuthenticationCallback)cb;

+ (void) pushNotificationWithUserID:(long)userID deviceToken:(NSString*)deviceToken location:(CLLocationCoordinate2D)location bloodTypeID:(long)bloodTypeID radius:(NSString*)radius callBack:(AuthenticationCallback)cb;

+ (void) getUserInfoWithUserID:(long)userID callBack:(AuthenticationCallback)cb;

+ (void) getNewsFeedWithUserID:(long)userID callBack:(AuthenticationCallback)cb;

@end