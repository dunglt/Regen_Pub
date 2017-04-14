//
//  signupViewController.h
//  BanCafe
//
//  Created by Pham Nghi on 9/4/15.
//  Copyright (c) 2015 Pham Nghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootViewController.h"
#import "CommonF.h"
#import "Common.h"
#import "SecondSignInVC.h"
#import "MapRegisterViewController.h"

@interface signupViewController : UIViewController
- (IBAction)btnSignIn:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *address;

@end
