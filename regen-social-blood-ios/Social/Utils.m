//
//  Utils.m
//  BaseProject
//
//  Created by Chung BD on 5/31/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import "Utils.h"
#import "Constant.h"

#define vCornerRadius 8.0f

@implementation Utils

+ (BOOL)validateWithString:(NSString *)string withPattern:(NSString *)pattern {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = NO;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;
    
    return didValidate;
}

+(BOOL) isValidEmail:(NSString *)checkString {
    //NSString *pattern = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self validateWithString:checkString withPattern:pattern];
}

+ (void)getInstanceFromServerSesponse:(NSDictionary *)dic withInstance:(id)instance {
    NSArray *allKeys = [dic allKeys];
    for (NSString *key in allKeys)
    {
        NSString *setterStr = [NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] capitalizedString], [key substringFromIndex:1]];
        if ([instance respondsToSelector:NSSelectorFromString(setterStr)]) {
            id value = dic[key];
            if ([value isKindOfClass:[NSString class]] &&
                ([key isEqualToString:@"id"] || [key isEqualToString:@"image_id"] || [key isEqualToString:@"sort_order"] || [key isEqualToString:@"type"] || [key isEqualToString:@"user_id"] || [key isEqualToString:@"is_expire"]) ) {
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *myNumber = [f numberFromString:(NSString*)value];
                [instance setValue:myNumber forKey:key];
                continue;
            }
            if ([value isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            if ([value isKindOfClass:[NSNull class]]){
                [instance setValue:@"" forKey:key];
                continue;
            }
            [instance setValue:value forKey:key];
        }
    }
}
+(NSNumber *) convertString2Number :(NSString *) str_input
{
    NSInteger  x = [str_input integerValue] ;
    NSNumber *numberrerurn = [NSNumber numberWithInteger:x] ;
    return numberrerurn ;
}

+ (void) convertToNSNumberFor:(NSNumber *)atribute byString:(id)string {
    if ([string isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        NSNumber *myNumber = [f numberFromString:(NSString*)string];
        atribute = myNumber;
//        atribute = [NSNumber numberWithLong:[string longValue]];
//        NSNumber *number =[NSNumber numberWithInt:[(NSString*)string intValue]];
//        atribute = number;
    }
    else
        atribute = string;
    
//    atribute = [Utils convertString2Number:string ] ;
//    
//    NSLog(@"Log attrubite : %@" , atribute ) ;
}


+ (void) roundedCornerForView:(UIView *)view {
    view.layer.cornerRadius = vCornerRadius;
}

+ (NSString *) clearDashStringWithInput:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+ (float)getWebViewContentHeightWith:(UIWebView *) wv {
    return [[wv stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
}

@end
