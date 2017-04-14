//
//  TGViewController.m
//  Social
//
//  Created by Pham Nghi on 12/13/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "TGViewController.h"
#import "LibraryAPI.h"
#import <SVProgressHUD.h>
#import "CommonF.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "Constant.h"



@implementation TGViewController


- (IBAction)takePhotoTapped
{
    TGCameraNavigationController *navigationController =
    [TGCameraNavigationController newWithCameraDelegate:self];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL
{
    // When this method is implemented, an image will be saved on the user's device
    NSLog(@"%s album path: %@", __PRETTY_FUNCTION__, assetURL);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    _photoView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    _photoView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)chooseExistingPhotoTapped
{
    UIImagePickerController *pickerController =
    [TGAlbum imagePickerControllerWithDelegate:self];
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _photoView.image = [TGAlbum imageWithMediaInfo:info];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)btnConfirm:(id)sender {
    [SVProgressHUD show];
    NSString *encodedString = [CommonF imageToNSString:_photoView.image];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:URL_UPLOAD_IMAGE parameters:@{@"content":encodedString} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        [_myDelegate didConfirmImage:_photoView.image url:responseObject[@"Data"]];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    [SVProgressHUD dismiss];
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
                                                                                   message:@"Lỗi tải ảnh"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
        
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
        
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];

    }];
    [self.navigationController popViewControllerAnimated:YES];
    //    [SVProgressHUD show];
//    [LibraryAPI uploadImage:encodedString callBack:^(BOOL success, id result, id message) {
//        if (success) {
//            NSLog(@"response:....%@",result);
//            [SVProgressHUD dismiss];
//            [_myDelegate didConfirmImage:_photoView.image url:result];
//        }
//        else{
//            [SVProgressHUD dismiss];
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
//                                                                           message:message
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {}];
//            
//            [alert addAction:defaultAction];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    }];
//    [self.navigationController popViewControllerAnimated:YES];
}

@end