//
//  TGViewController.h
//  Social
//
//  Created by Pham Nghi on 12/13/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGCameraViewController.h"


@protocol TGViewControllerDelegate <NSObject>

-(void)didConfirmImage:(UIImage*)image url:(NSString*)url;

@end

@interface TGViewController : UIViewController <TGCameraDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *photoView;

- (IBAction)takePhotoTapped;
- (IBAction)chooseExistingPhotoTapped;
@property (assign,nonatomic) id <TGViewControllerDelegate> myDelegate;

- (IBAction)btnConfirm:(id)sender;

@end
