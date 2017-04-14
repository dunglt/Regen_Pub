//
//  NetworkManager.h
//  BaseProject
//
//  Created by Chung BD on 6/3/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Common.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@interface NetworkManager : NSObject
{
    NSURL *_url;
    NSMutableURLRequest *_request;
    NSString *_body;
    NSOperationQueue *_queue;
}

- (void) requestToServicesWithURL:(NSString*)url parameter:(NSDictionary *)para completion:(completionHandler)callback;
@end
