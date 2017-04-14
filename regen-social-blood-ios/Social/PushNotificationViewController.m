//
//  PushNotificationViewController.m
//  Social
//
//  Created by Pham Nghi on 11/6/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "PushNotificationViewController.h"
#import "Constant.h"
#import "LibraryAPI.h"
#import "UserData.h"
#import <SVProgressHUD.h>
#import "CommonF.h"


@interface PushNotificationViewController ()<UIPickerViewDelegate>
{
    CLLocationManager *locationManager;
    UIButton *btnDone;
    UIView *inputAccView;
    NSArray *bloodTypeData;
    NSArray *radiusData;
    NSMutableArray *userArray;
    UIPickerView *bloodTypePickerView;
    UIPickerView *radiusPickerView;

}
- (IBAction)btnPushNotification:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtBloodType;
@property (weak, nonatomic) IBOutlet UITextField *txtRadius;
@property UserData *userData;
@property NSString *deviceToken;

@end

@implementation PushNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createInputAccessoryView];
    [CommonF chageColorPlaceHolder:_txtRadius withColor:[UIColor whiteColor]];
    [CommonF chageColorPlaceHolder:_txtBloodType withColor:[UIColor whiteColor]];
    [_txtRadius setInputAccessoryView:inputAccView];
    [_txtBloodType setInputAccessoryView:inputAccView];
    UserDataManager *user = [LibraryAPI getUserDataManager];
    _deviceToken = [user getDeviceToken].deviceTokenID;
    _userData = [user getUserModel];
    bloodTypePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150)];
    radiusPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    bloodTypePickerView.delegate = self;
    bloodTypePickerView.showsSelectionIndicator = YES;
    radiusPickerView.delegate = self;
    radiusPickerView.showsSelectionIndicator = YES;
    bloodTypePickerView.hidden = NO;
    radiusPickerView.hidden = NO;
    _txtBloodType.inputView = bloodTypePickerView;
    _txtRadius.inputView = radiusPickerView;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
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
#pragma mark - Function

- (void) performPushNotification{
        int i;
        for (i=0; i<BLOOD_TYPE.count; i++) {
            if([BLOOD_TYPE[i] isEqual:_txtBloodType.text])
                break;
        }
    [SVProgressHUD show];
    [LibraryAPI pushNotificationWithUserID:_userData.userId deviceToken:_deviceToken location:CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude) bloodTypeID:i radius:[_txtRadius.text substringToIndex:[_txtRadius.text length] - 2] callBack:^(BOOL success, id result, id message) {
        if (success) {
            [SVProgressHUD dismiss];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                           message:@"Bạn đã gửi thông báo thành công"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
        else{
            [SVProgressHUD dismiss];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Lỗi"
                                                                           message:@"Hệ thống xảy ra lỗi. Gửi thông báo thất bại."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }

    }];

}

- (BOOL) isInvalidInput{
    if (![_txtRadius.text isEqual:@""]&&![_txtBloodType.text isEqual:@""]) {
        return YES;
    }
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                       message:@"Bạn hãy nhập đầy đủ thông tin."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
}

- (IBAction)btnBack:(id)sender {
    UIViewController *secondViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
    [self.navigationController pushViewController:secondViewController animated:YES];
}
- (IBAction)btnPushNotification:(id)sender {
    if ([self isInvalidInput]) {
        [self performPushNotification];
    }

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == bloodTypePickerView) {
        return [BLOOD_TYPE count];
    }
    else return [RADIUS count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    if (pickerView == bloodTypePickerView) {
        title = [BLOOD_TYPE objectAtIndex:row];
    }
    else title = [RADIUS objectAtIndex:row];
    return title;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _txtBloodType) {
        _txtBloodType.text = @"Unknown";
    }
    else _txtRadius.text = @"1km";
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == bloodTypePickerView) {
        _txtBloodType.text = [BLOOD_TYPE objectAtIndex:row];
    }
    else
        _txtRadius.text = [RADIUS objectAtIndex:row];
    
}
-(void)createInputAccessoryView{
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    
    // Set the view’s background color. We’ ll set it here to gray. Use any color you want.
    [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    // We can play a little with transparency as well using the Alpha property. Normally
    // you can leave it unchanged.
    [inputAccView setAlpha: 0.8];
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-70, 0.0f, 80.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor clearColor]];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:btnDone];
    
    
}
-(void)doneTyping{
    // When the "done" button is tapped, the keyboard should go away.
    // That simply means that we just have to resign our first responder.
    [_txtBloodType resignFirstResponder];
    [_txtRadius resignFirstResponder];
}

@end
