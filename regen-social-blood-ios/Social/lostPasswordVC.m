//
//  lostPasswordVC.m
//  BanCafe
//
//  Created by Pham Nghi on 9/5/15.
//  Copyright (c) 2015 Pham Nghi. All rights reserved.
//

#import "lostPasswordVC.h"
#import "CommonF.h"
#import <AFNetworking.h>
#import "Constant.h"
#import "LibraryAPI.h"
#import <SVProgressHUD.h>

@interface lostPasswordVC ()

@end

@implementation lostPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CommonF chageColorPlaceHolder:_emailTxt withColor:[UIColor whiteColor]];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)retrievalPasswordBtn:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:URL_SEND_PASSWORD_TO_EMAIL parameters:@{@"email":_emailTxt.text} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                       message:responseObject[@"Data"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
                                                                       message:@"Email của bạn không tồn tại hoặc chưa đăng ký"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
