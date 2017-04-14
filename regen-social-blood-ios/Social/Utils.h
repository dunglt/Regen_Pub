//
//  Utils.h
//  BaseProject
//
//  Created by Chung BD on 5/31/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utils : NSObject

+ (BOOL) isValidEmail:(NSString *)checkString;
+ (void)getInstanceFromServerSesponse:(NSDictionary *)dic withInstance:(id)instance;
+ (void) convertToNSNumberFor:(NSNumber *)atribute byString:(id) string;
+ (NSNumber *) convertString2Number :(NSString *) str_input ;
+ (void) roundedCornerForView:(UIView *)view;
+ (NSString *) clearDashStringWithInput:(NSString *)string;
+ (float)getWebViewContentHeightWith:(UIWebView *) wv;
@end
