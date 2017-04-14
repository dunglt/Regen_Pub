//
//  CommonF.h
//  Social
//
//  Created by Pham Nghi on 11/5/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CommonF : NSObject

+(void) chageColorPlaceHolder:(UITextField*)text withColor:(UIColor*)color;
+(CLLocation*)findAddressCordinates:(NSString*)addressString;
+(NSString *)imageToNSString:(UIImage *)image;
+(UIImage *)stringToUIImage:(NSString *)string;

@end
