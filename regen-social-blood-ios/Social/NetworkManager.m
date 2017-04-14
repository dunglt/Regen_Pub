//
//  NetworkManager.m
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import "NetworkManager.h"


@implementation NetworkManager
- (void) requestToServicesWithURL:(NSString*)url parameter:(NSDictionary *)para completion:(completionHandler)callback {
    NSLog(@"url: %@",url);
    NSLog(@"Parameter: %@",para);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self verifyResponseWithData:responseObject callback:callback];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        callback(ErrorCodesRequestFault,nil,nil);
    }];
  
}

- (void) verifyResponseWithData:(NSDictionary*)response callback:(completionHandler)cb {
//    NSLog(@"response: %@",response);
    NSNumber *success = [response objectForKey:@"Success"];
    if([success intValue] == 1) {
        cb(ErrorCodesOk,response[@"Data"],response[@"Message"]);
    }
    else {
        cb(ErrorCodesRequestFault,response[@"Date"],response[@"Message"]);
    }
}

- (void) verifyResponeData:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error completion:(completionHandler)callback {
    if ([data length] >0 && error == nil){
        NSDictionary *serverRespone = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
        
        //        NSLog(@"data respone : %@",serverRespone);
        NSNumber *errorResponse = serverRespone[@"Status"];
        NSInteger errorCode = [errorResponse integerValue];
        if (errorCode == ErrorCodesOk) {
            callback(errorCode,serverRespone[@"data"],serverRespone[@"Message"]);
        }
        else if (errorCode == ErrorCodesServerResponseUnknow)
            callback(ErrorCodesServerResponseUnknow,nil,[NSString stringWithFormat:@"%@",serverRespone[@"Message"]]);
        else {
            callback(ErrorCodesRequestFault,nil, MSG_CHECK_INTERNET_CONNECTION);
        }
    }
    else if ([data length] == 0 && error == nil){
        NSLog(@"Nothing was downloaded.");
        callback(ErrorCodesRequestFault,nil,MSG_CHECK_INTERNET_CONNECTION);//MSG_ERROR_CODE_NOTHING_DOWNLOAD
    }
    else if (error != nil){
        NSLog(@"Error happened = %@", error);
        callback(ErrorCodesRequestFault,nil, MSG_CHECK_INTERNET_CONNECTION);//MSG_ERROR_CODE_UNKNOWN
    }
}

- (NSData*) convertToBodyRequestFromDictionary:(NSDictionary*)dic {
    NSMutableString *body = [NSMutableString new];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (body.length >0) {
            [body appendString:@"&"];
        }
        [body appendString:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *postData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return postData;
}
@end
