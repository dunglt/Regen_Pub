//
//  NewFeedVC.m
//  Social
//
//  Created by Pham Nghi on 1/14/16.
//  Copyright © 2016 Duong Tuan Dat. All rights reserved.
//

#import "NewFeedVC.h"
#import "NewFeedTableViewCell.h"
#import "LibraryAPI.h"
#import "UserInfoVC.h"

@interface NewFeedVC ()<UITableViewDataSource,UITableViewDelegate>

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *lblKoTimThay;
@property NSArray *NewFeedArray;
@property UserData* userData;

@end

@implementation NewFeedVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lblKoTimThay.hidden = YES;
    _table.hidden = YES;
    UserDataManager *user = [LibraryAPI getUserDataManager];
    _userData = [user getUserModel];
    [_table registerNib:[UINib nibWithNibName:@"NewFeedTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewFeedTableViewCell"];
    _table.delegate = self;
    _table.dataSource = self;
    [LibraryAPI getNewsFeedWithUserID:_userData.userId callBack:^(BOOL success, id result, id message) {
        if (success) {
            _NewFeedArray = result;
            if (_NewFeedArray.count == 0) {
                _lblKoTimThay.hidden = NO;
                _table.hidden = YES;
            }
            else{
                _lblKoTimThay.hidden = YES;
                _table.hidden = NO;
                [_table reloadData];
            }
        }
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _NewFeedArray.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewFeedTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NewFeedTableViewCell"];
    if (_NewFeedArray[indexPath.row][@"LastName"] == [NSNull null]) {
        cell.lblName.text = @"Ẩn danh";
    }
    else cell.lblName.text = _NewFeedArray[indexPath.row][@"LastName"];
    cell.lblTime.text = _NewFeedArray[indexPath.row][@"pushTime"];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 74;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfoVC *secondViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoVC"];
    NSNumber* mapXNum = [_NewFeedArray[indexPath.row] valueForKey:@"UserID"];
    int i = [mapXNum intValue];
    [LibraryAPI getUserInfoWithUserID: i callBack:^(BOOL success, id result, id message) {
        if (success) {
            NSLog(@"result------------\n%@",result);
            UserData *userData = [[UserData alloc]init];
            [userData assignValueFromDictionary:result[0]];
            secondViewController.userData = userData;
        }
    }];
    [self.navigationController pushViewController:secondViewController animated:YES];
    
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
-(BOOL)prefersStatusBarHidden{
    
    return YES;
    
}
- (IBAction)btnBack:(id)sender {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
