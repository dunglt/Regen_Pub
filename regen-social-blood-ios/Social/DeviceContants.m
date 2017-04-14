//
//  DeviceContants.m
//  Social
//
//  Created by Pham Nghi on 1/12/16.
//  Copyright © 2016 Duong Tuan Dat. All rights reserved.
//

#import "DeviceContants.h"

@implementation DeviceContants

+ (NSString*)primaryKey {
    return @"deviceTokenID";
}

-(void)getDeviceTokenWithString:(NSString*)str{
    if (str) {
         _deviceTokenID = str;
    }
}

@end


