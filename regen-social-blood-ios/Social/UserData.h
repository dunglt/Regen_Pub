//
//  UserData.h
//  Social
//
//  Created by Pham Nghi on 11/12/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Realm/Realm.h>

@interface UserData : RLMObject

//@property UIImage *imgAvatar;
@property int userId;
@property NSString *name;
@property NSString *bloodType;
@property NSString *phone;
@property NSString *address;
@property NSString *email;
@property double latitude;
@property double longitude;
@property int status;
@property NSString *sex;
@property NSString *photoData;
@property BOOL didLogouted;
//@property NSDictionary* data;
- (void) assignValueFromDictionary:(NSDictionary*)dic;
@end




