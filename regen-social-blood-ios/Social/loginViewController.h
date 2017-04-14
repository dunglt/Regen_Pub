//
//  loginViewController.h
//  BanCafe
//
//  Created by Pham Nghi on 9/4/15.
//  Copyright (c) 2015 Pham Nghi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootViewController.h"
#import "UIImage+animatedGIF.h"
#import "CommonF.h"
#import "Common.h"

#import "Utils.h"
#import "LibraryAPI.h"

@interface loginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundAnimate;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgSologan;
@property (weak, nonatomic) IBOutlet UIButton *btnLostPW;
@property (weak, nonatomic) IBOutlet UILabel *lblUnknown;
@property (weak, nonatomic) IBOutlet UIButton *btnTryIt;

- (IBAction)btnTryIt:(id)sender;

@end
