//
//  accSettingViewController.h
//  BanCafe
//
//  Created by Pham Nghi on 9/5/15.
//  Copyright (c) 2015 Pham Nghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface accSettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *addressTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *changePassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *nametxt;
@property (weak, nonatomic) IBOutlet UITextField *sextxt;
@property (weak, nonatomic) IBOutlet UITextField *bloodType;
@property (weak, nonatomic) IBOutlet UITextField *identifyCard;
@property CLLocationCoordinate2D location;

- (IBAction)backBtn:(id)sender;
- (IBAction)updateInfoBtn:(id)sender;
- (IBAction)changePasswordPtn:(id)sender;

@end
