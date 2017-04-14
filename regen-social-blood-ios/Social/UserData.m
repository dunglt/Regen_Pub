//
//  UserData.m
//  Social
//
//  Created by Pham Nghi on 11/12/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "UserData.h"
#import "Constant.h"
#import "CommonF.h"

@implementation UserData

+ (NSString*)primaryKey {
    return @"email";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"name": @"",
             @"bloodType":@"Unknown",
             @"sex":@"nam",
             @"photoData": [CommonF imageToNSString:[UIImage imageNamed:@"avatarDefault"]],
             };
}

- (void) assignValueFromDictionary:(NSDictionary*)dic{
    if (dic[@"LastName"] == [NSNull null]) {
        self.name = @"ẩn danh";
    }
    else self.name = dic[@"LastName"];
    _address = dic[@"Address"];
    NSNumber* mapXNum = [dic valueForKey:@"BloodTypeID"];
    int i = [mapXNum intValue];
    _bloodType = BLOOD_TYPE[i];
    _email = dic[@"Email"];
    _phone = dic[@"Mobile"];
    _sex = dic[@"Sex"]?@"nam":@"nữ";
    NSNumber* ID = [dic valueForKey:@"UserID"];
    _userId = [ID intValue];
    _latitude = [dic[@"latitudeY"] doubleValue];
    _longitude = [dic[@"longitudeX"] doubleValue];
    if (!(dic[@"avatar"] == [NSNull null])) {
        NSString *urlString = [dic[@"avatar"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; ;
        NSURL *url =[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //Download image
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (image != nil) {
                weakSelf.photoData = [CommonF imageToNSString:image];
            }
        });
    }
    _didLogouted = YES;
}


@end

