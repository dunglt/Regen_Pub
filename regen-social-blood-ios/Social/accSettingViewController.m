//
//  accSettingViewController.m
//  BanCafe
//
//  Created by Pham Nghi on 9/5/15.
//  Copyright (c) 2015 Pham Nghi. All rights reserved.
//

#import "accSettingViewController.h"
#import "CommonF.h"
#import "Common.h"
#import "Constant.h"
#import "LibraryAPI.h"
#import "loginViewController.h"
#import "MapRegisterViewController.h"
#import <SVProgressHUD.h>
#import <STPopup.h>

@interface accSettingViewController ()<MapRegisterDelegate,PopUpTextFieldDelegate,UIPickerViewDelegate>
{
    int bloodTypeId;
    CLLocationCoordinate2D _userLocation;
    UserData *userData;
    STPopupController *popupController;
    UIButton *btnDone;
    UIView *inputAccView;
    UIPickerView *sexPickerView;
    UIPickerView *bloodTypePickerView;
}

@end

@implementation accSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserDataManager *user = [LibraryAPI getUserDataManager];
    userData = [user getUserModel];
    _addressTxt.text = userData.address;
    _phoneTxt.text =userData.phone;
    _nametxt.text = userData.name;
    _sextxt.text = userData.sex;
    _bloodType.text = userData.bloodType;
    [self createInputAccessoryView];
    [_sextxt setInputAccessoryView:inputAccView];
    sexPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    sexPickerView.delegate = self;
    sexPickerView.showsSelectionIndicator = YES;
    sexPickerView.hidden = NO;
    _sextxt.inputView = sexPickerView;
    [_bloodType setInputAccessoryView:inputAccView];
    bloodTypePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    bloodTypePickerView.delegate = self;
    bloodTypePickerView.showsSelectionIndicator = YES;
    bloodTypePickerView.hidden = NO;
    _bloodType.inputView = bloodTypePickerView;
    
    UIColor *color = [UIColor whiteColor];
    [CommonF chageColorPlaceHolder:_phoneTxt withColor:color];
    [CommonF chageColorPlaceHolder:_nametxt withColor:color];
    [CommonF chageColorPlaceHolder:_sextxt withColor:color];
    [CommonF chageColorPlaceHolder:_bloodType withColor:color];
    [CommonF chageColorPlaceHolder:_changePassword withColor:color];
    [CommonF chageColorPlaceHolder:_confirmPassword withColor:color];
    [CommonF chageColorPlaceHolder:_identifyCard withColor:color];
    [CommonF chageColorPlaceHolder:_addressTxt withColor:color];
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


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateInfoBtn:(id)sender {
    if ([_bloodType.text isEqual:@""]) {
        for (int i=0;i<BLOOD_TYPE.count; i++) {
            if ([userData.bloodType isEqualToString: BLOOD_TYPE[i]]) {
                bloodTypeId = i;
            }
        }
    }
    else {
        for (int i=0;i<BLOOD_TYPE.count; i++) {
            if ([_bloodType.text isEqualToString:BLOOD_TYPE[i]]) {
                bloodTypeId = i;
            }
        }

    }
    if ([_addressTxt.text isEqual:@""]) {
        _addressTxt.text = userData.address;
        _location = CLLocationCoordinate2DMake(userData.latitude, userData.longitude);
    }
    else _location = _userLocation;
    if ([_sextxt.text isEqual:@""]) {
        _sextxt.text = userData.sex;
    }
    //if ([self checkTextFieldIsNotNull]) {
//        [LibraryAPI checkPhoneWithPhone:_phoneTxt.text callBack:^(BOOL success, id result, id message) {
//            if ([result intValue] == 1) {
                   [SVProgressHUD show];
                [LibraryAPI requestToSettingProfileWithUserId:userData.userId passWord:@"" name:_nametxt.text bloodTypeId:bloodTypeId sex:[_sextxt.text isEqual:@"nam"] address:_addressTxt.text phone:_phoneTxt.text location:_location identifyCard:_identifyCard.text avatar:@"" callBack:^(BOOL success, id result, id message) {
                    if (success) {
                        [SVProgressHUD dismiss];
                        rootViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                    else{
                        [SVProgressHUD dismiss];
                    }
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                                   message:message
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];

                }];
//            }
//            else
//            {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
//                                                                               message:@"Số điện thoại này đã được sử dụng"
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action) {}];
//                
//                [alert addAction:defaultAction];
//                [self presentViewController:alert animated:YES completion:nil];
//
//            }
//        }];
    
   // }
}


- (IBAction)changePasswordPtn:(id)sender {
    if([self checkPassword])
    {
    for (int i=0;i<BLOOD_TYPE.count; i++) {
        if ([userData.bloodType isEqualToString: BLOOD_TYPE[i]]) {
            bloodTypeId = i;
        }
    }
    _location = CLLocationCoordinate2DMake(userData.latitude, userData.longitude);
    [LibraryAPI requestToSettingProfileWithUserId:userData.userId passWord:_changePassword.text name:_nametxt.text bloodTypeId:bloodTypeId sex:[_sextxt.text isEqual:@"nam"] address:_addressTxt.text phone:_phoneTxt.text location:_location identifyCard:@"" avatar:@"" callBack:^(BOOL success, id result, id message) {
     if (success) {
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                        message:@"Đổi mật khẩu thành công!"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {}];
         
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];

        }
        else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                           message:@"Đổi mật khẩu thất bại"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    ];
    }
}

- (BOOL) checkPassword{
    if (![_changePassword.text isEqualToString:_confirmPassword.text]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                       message:@"Mật khẩu xác nhận không khớp"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return  FALSE;

    }
    if ([_changePassword.text isEqual:@""]||[_confirmPassword.text isEqual:@""]) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                       message:@"Chưa điền hết thông tin"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return  FALSE;
    }
    else {
        
        return TRUE;
    }
}



- (BOOL) checkTextFieldIsNotNull{
    if ([_phoneTxt.text isEqual:@""]||[_identifyCard.text isEqual:@""]||[_nametxt.text isEqual:@""]||[_bloodType.text isEqual:@""]||[_sextxt.text isEqual:@""]) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                       message:@"Chưa điền hết thông tin"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return  FALSE;
    }
    else {
        
        return TRUE;
    }
}



#pragma TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _addressTxt) {
        MapRegisterViewController *secondViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"MapRegisterViewController"];
        secondViewController.myDelegate = self;
        [self.navigationController pushViewController:secondViewController animated:YES];
        [self.view endEditing:YES];
    }
    else{
            PopUpTextField *field = [[NSBundle mainBundle] loadNibNamed:@"PopUpTextField" owner:self options:nil][0];
            if (textField.tag==1||textField.tag==2) {
                field.txtField.secureTextEntry = YES;
            }
            field.myDelegate = self;
            field.txtField.delegate = field;
            field.Taget = textField;
            field.txtField.text = textField.text;
            field.imgIcon.image = [UIImage imageNamed:CIcon[textField.tag]];
            field.imgIcon.contentMode = UIViewContentModeScaleAspectFit;
            [field.txtField becomeFirstResponder];
            popupController = [[STPopupController alloc] initWithRootViewController:field];
            [popupController setNavigationBarHidden:TRUE];
            [popupController presentInViewController:self];
            [self.view endEditing:YES];
    }
}
- (void)didPressReturnKey{
    [popupController dismiss];
}

- (void) didFindAddress:(NSString *)address andLocation:(CLLocationCoordinate2D)location{
    _addressTxt.text = address;
    _userLocation = location;
    
}

-(void)didEndTyping{
    [popupController dismiss];
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
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == sexPickerView) {
        return 2;
    }
    else return BLOOD_TYPE.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    if (pickerView == sexPickerView) {
        if (row ==0) {
            title = @"nam";
        }
        else title = @"nữ";
    }
    else title = [BLOOD_TYPE objectAtIndex:row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == sexPickerView) {
         _sextxt.text = row==0?@"nam":@"nữ";
    }
    else _bloodType.text = [BLOOD_TYPE objectAtIndex:row];
    
}

-(void)doneTyping{
    // When the "done" button is tapped, the keyboard should go away.
    // That simply means that we just have to resign our first responder.
    
    [_sextxt resignFirstResponder];
    [_bloodType resignFirstResponder];
}
@end
