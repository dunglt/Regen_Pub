//
//  MarkerTableViewCell.h
//  Social
//
//  Created by Pham Nghi on 12/2/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBloodType;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@end
