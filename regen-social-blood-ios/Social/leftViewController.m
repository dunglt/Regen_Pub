//
//  leftViewController.m
//  BaseProject
//
//  Created by Dat Duong on 8/21/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import "leftViewController.h"
#import "accSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonVC.h"
#import "LibraryAPI.h"
#import "loginViewController.h"
#import <SVProgressHUD.h>

NSArray *_listView;
@interface leftViewController ()
{
    UserData *userData;
    NSArray *_listMenu;
    NSArray *_listImage;
    NSArray *_statusArray;
    long status;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@end

@implementation leftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserDataManager *user = [LibraryAPI getUserDataManager];
    userData = [user getUserModel];
    _isDemoUser = NO;
    if ([userData.email isEqualToString: @"demo@gmail.com"]) {
        _isDemoUser = YES;
    }
    _lblUserEmail.text = userData.email;
    _lblUserName.text = userData.name;
    _imgAvatar.image = [CommonF stringToUIImage:userData.photoData];
    // Do any additional setup after loading the view.
    [_table registerNib:[UINib nibWithNibName:@"leftTableViewCell" bundle:nil] forCellReuseIdentifier:@"leftTableViewCell"];
//    UserDataManager *user = [LibraryAPI getUserDataManager];
//    UserData* userData = [user getUserModel];
    status = 0;
    [LibraryAPI requestToUpdateStatusBloodDonationWithUserId:userData.userId andStatus:(status!=1) callBack:^(BOOL success, id result, id message) {
        if (success) {
            
            if (status==0) {
                status = 1;
            }
            else{
                status = 0;
            }
            [self setListMenu];
            [_table reloadData];
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD dismiss];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    _imgAvatar.clipsToBounds = YES;
    _statusArray = @[@"Bật trạng thái hiến máu",@"Tắt trạng thái hiến máu"];
    [self setListMenu];
}
-(void)viewDidLayoutSubviews {
    _imgAvatar.layer.cornerRadius = _imgAvatar.frame.size.width / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setListMenu
{
    _listMenu=@[
                @[_statusArray[status],@"Tìm người hiến máu"],
                @[@"Gửi thông báo khẩn"],
                @[@"Danh sách thông báo gần đây"],
                @[@"Về chúng tôi"]
                ];
    _listImage=@[
                @[@"Find User-100-2.png",@"Search-100-2.png"],
                @[@"Megaphone-100-2.png"],
                @[@"Google News Filled-100.png"],
                @[@"Info-100.png"],
                ];
}

#pragma UItableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listMenu.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_listMenu objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    leftTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"leftTableViewCell"];
    cell.label.text=_listMenu[indexPath.section][indexPath.row];
    cell.image.image=[UIImage imageNamed:_listImage[indexPath.section][indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    naviViewController *navi=[self.storyboard instantiateViewControllerWithIdentifier:@"naviViewController"];
    UIViewController * viewController;
    if(indexPath.section == 0) {
        if (indexPath.row == 0) {
            if(_isDemoUser){
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Chú ý"
                                                                               message:@"Tài khoản dùng thử không thể thay đối trạng thái hiến máu"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else{

            [SVProgressHUD show];
            [LibraryAPI requestToUpdateStatusBloodDonationWithUserId:userData.userId andStatus:(status==1) callBack:^(BOOL success, id result, id message) {
                if (success) {
                    
                    if (status==0) {
                        status = 1;
                    }
                    else{
                        status = 0;
                    }
                    [self setListMenu];
                    [_table reloadData];
                    [SVProgressHUD dismiss];
                }
                else {
                    [SVProgressHUD dismiss];
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                                   message:message
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
            
        }
        else {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            self.frostedViewController.contentViewController=navi;
            [self.frostedViewController hideMenuViewController];
        }
    }
    else if (indexPath.section == 1){
        if(_isDemoUser){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Chú ý"
                                                                           message:@"Tài khoản dùng thử không thể gửi thông báo khẩn cấp"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
        else{
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PushNotificationViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
    else if (indexPath.section == 2){
        if(_isDemoUser){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Chú ý"
                                                                           message:@"Tài khoản dùng thử không thể gửi thông báo khẩn cấp"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else{
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewFeedVC"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
    else if(indexPath.section == 3) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    if(viewController){
        //navi.viewControllers=@[viewController];
    }
    
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutBtn:(id)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        userData.didLogouted = NO;

    }];
    [LibraryAPI addDeviceToken:@"0" withUserID:userData.userId callBack:^(BOOL success, id result, id message) {
        if (success) {
            NSLog(@"thanh cong");
        }
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)accSettingBtn:(id)sender {
    if (_isDemoUser) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Chú ý"
                                                                       message:@"Tài khoản dùng thử không thể thiết lập thay đổi thông tin"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else{
        accSettingViewController *secondViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"accSettingViewController"];
        [self.frostedViewController hideMenuViewController];
        [self.navigationController pushViewController:secondViewController animated:YES];
    }
    
}

@end
