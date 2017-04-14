//
//  Macro.h
//  BaseProject
//
//  Created by Chung BD on 5/31/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#ifndef BaseProject_Macro_h
#define BaseProject_Macro_h

#define _session [Session currentSession]
#define _log(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define APP_SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
#define APP_SCREEN_WIDTH [[UIScreen mainScreen] applicationFrame].size.width
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.width-375)?NO:YES)
#define IS_IPHONE6PLUS (([[UIScreen mainScreen] bounds].size.width-414)?NO:YES)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 alpha:1.0]

/** String: System Version **/
#define SYSTEM_VERSION ( [[[UIDevice currentDevice ] systemVersion ] integerValue] )
#define IS_IOS8  (SYSTEM_VERSION >= 8)

#define IS_IOS7  (SYSTEM_VERSION >= 7 && SYSTEM_VERSION < 8)

#define IS_IOS6  (SYSTEM_VERSION < 7)

#pragma mark - key for User Data
#define kUserNameWhenLoginSuccess @"kUserNameWhenLoginSuccess"
#define kPasswordWhenLoginSuccess @"kPasswordWhenLoginSuccess"

typedef NS_ENUM(NSInteger, ErrorCodes) {
    //    ErrorCodesNotAuthorized        = 2,
    //    ErrorCodesTokenExpire          = -1,
    ErrorCodesServerResponseUnknow = -1,
    ErrorCodesRequestFault         = 0,
    ErrorCodesOk                   = 1,
    //    ErrorCodesNothingDownload      = 4,
    //    ErrorCodesUnknow               = 5
};

typedef void (^AuthenticationCallback)(BOOL success, id result, id message);
typedef void (^BooleanCallback)(BOOL success);
typedef void (^BoolAndValueCallback)(BOOL success, id result);
typedef void (^completionHandler)(ErrorCodes code, id result, id message);
#endif
