//
//  CommonF.m
//  Social
//
//  Created by Pham Nghi on 11/5/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "CommonF.h"

@implementation CommonF

+ (void) chageColorPlaceHolder:(UITextField*)text withColor:(UIColor*)color{
    if(text.placeholder){
        text.attributedPlaceholder = [[NSAttributedString alloc]initWithString:text.placeholder attributes:@{NSForegroundColorAttributeName: color} ];
    }
}

+(CLLocation*)findAddressCordinates:(NSString*)addressString {
    
    CLLocation *location;
    addressString = [addressString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", addressString];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
    
    
    // Fail to get data from server
    if (nil == data) {
        
        NSLog(@"Error: Fail to get data");
    }
    else{
        // Parse the json data
        NSError *error;
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        // Check status of result
        NSString *resultStatus = [json valueForKey:@"status"];
        // If responce is valid
        if ( (nil == error) && [resultStatus isEqualToString:@"OK"] ) {
            NSDictionary *locationDict=[json objectForKey:@"results"] ;
            NSArray *temp_array=[locationDict valueForKey:@"geometry"];
            NSArray *temp_array2=[temp_array valueForKey:@"location"];
            NSEnumerator *enumerator = [temp_array2 objectEnumerator];
            id object;
            while ((object = [enumerator nextObject])) {
                double latitude=[[object valueForKey:@"lat"] doubleValue];
                double longitude=[[object valueForKey:@"lng"] doubleValue];
                location=[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                
                NSLog(@"CLLocation lat  is  %f  -------------& long   %f",location.coordinate.latitude, location.coordinate.longitude);
                
            }
        }
    }
    
    return location;
    
}

+(NSString *)imageToNSString:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+(UIImage *)stringToUIImage:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}



@end
