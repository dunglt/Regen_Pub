//
//  rootViewController.m
//  BaseProject
//
//  Created by Dat Duong on 8/21/15.
//  Copyright (c) 2015 Bui Chung. All rights reserved.
//

#import "rootViewController.h"
#import "leftViewController.h"

//NSArray *_listView;
@interface rootViewController ()

@end

@implementation rootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)awakeFromNib
{
    UIStoryboard *nghi=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    naviViewController *navi=[self.storyboard instantiateViewControllerWithIdentifier:@"naviViewController"];
    ViewController *offer=[nghi instantiateViewControllerWithIdentifier:@"ViewController"];
    navi.viewControllers=@[offer];
    self.contentViewController =navi;
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
