//
//  InfoWindow.h
//  Social
//
//  Created by Pham Nghi on 11/11/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoWindow : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBloodType;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@end
