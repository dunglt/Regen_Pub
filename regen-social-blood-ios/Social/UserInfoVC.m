//
//  UserInfoVC.m
//  Social
//
//  Created by Pham Nghi on 11/11/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "UserInfoVC.h"
#import "ViewController.h"
#import "UserData.h"
#import <Realm/Realm.h>
#import "CommonF.h"

@interface UserInfoVC ()
{
    
}

- (IBAction)btnBack:(id)sender;



@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    if (_userData.photoData != nil) {
        _imgAvatar.image = [CommonF stringToUIImage:_userData.photoData];
        
    }
    _lblBloodType.text = _userData.bloodType;
    if ([_userData.name isKindOfClass:[NSNull class]]) {
        self.lblName.text = _userData.email;
    }
    else self.lblName.text = _userData.name;
    _lblPhone.text = _userData.phone;

}
- (void) viewWillAppear:(BOOL)animated
{
    _imgAvatar.layer.cornerRadius = _imgAvatar.frame.size.height/2;
    _imgAvatar.clipsToBounds = YES;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCall:(id)sender {
    NSString *number = [NSString stringWithFormat: @"telprompt://%@",_lblPhone.text];
    
    number = [number stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:number];
    [[UIApplication sharedApplication] openURL:url];
    
}
@end
