//
//  lostPasswordVC.h
//  BanCafe
//
//  Created by Pham Nghi on 9/5/15.
//  Copyright (c) 2015 Pham Nghi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lostPasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
- (IBAction)retrievalPasswordBtn:(id)sender;
- (IBAction)backBtn:(id)sender;

@end
