//
//  SecondSignInVC.h
//  Social
//
//  Created by Pham Nghi on 11/10/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondSignInVC : UIViewController
- (IBAction)btnSkip:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtSex;
@property (weak, nonatomic) IBOutlet UITextField *txtIdentifyCard;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) NSString* password;
- (IBAction)btnAddInfo:(id)sender;
- (IBAction)btnChangeAvatar:(id)sender;



@end
