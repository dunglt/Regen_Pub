//
//  UserInfoVC.h
//  Social
//
//  Created by Pham Nghi on 11/11/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import <QuartzCore/QuartzCore.h>




@interface UserInfoVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblBloodType;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (nonatomic) UserData *userData;

- (IBAction)btnCall:(id)sender;

@end
