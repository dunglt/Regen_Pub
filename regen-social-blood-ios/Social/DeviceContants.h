//
//  DeviceContants.h
//  Social
//
//  Created by Pham Nghi on 1/12/16.
//  Copyright © 2016 Duong Tuan Dat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface DeviceContants : RLMObject

@property NSString* deviceTokenID;

-(void)getDeviceTokenWithString:(NSString*)str;

@end
