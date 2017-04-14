//
//  leftViewController.h
//  BaseProject
//
//  Created by Dat Duong on 8/21/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "leftTableViewCell.h"
#import "naviViewController.h"
#import <REFrostedViewController.h>
extern NSArray *_listView;
@interface leftViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
- (IBAction)logoutBtn:(id)sender;
- (IBAction)accSettingBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserEmail;
@property BOOL isDemoUser;


@end
