//
//  NewFeedTableViewCell.h
//  Social
//
//  Created by Pham Nghi on 1/14/16.
//  Copyright © 2016 Duong Tuan Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBloodType;

@end
