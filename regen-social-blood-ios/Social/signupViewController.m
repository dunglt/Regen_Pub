//
//  signupViewController.m
//  BanCafe
//
//  Created by Pham Nghi on 9/4/15.
//  Copyright (c) 2015 Pham Nghi. All rights reserved.
//
#import "LibraryAPI.h"
#import "signupViewController.h"
#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import <STPopup.h>
#import "Utils.h"

@import GoogleMaps;

@interface signupViewController ()<UITextFieldDelegate,MapRegisterDelegate,PopUpTextFieldDelegate,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UITextField *bloodType;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (retain, nonatomic) GMSPlace *place;
@end

@implementation signupViewController {
    STPopupController *popupController;
    CLLocationCoordinate2D _location;
    long bloodTypeId;
    UIView *inputAccView;
    UIPickerView *bloodTypePickerView;
    UIButton *btnDone;
}

#pragma mark - View life cycle
- (void) viewWillAppear:(BOOL)animated {
    [self createInputAccessoryView];
    [_bloodType setInputAccessoryView:inputAccView];
    bloodTypePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 150)];
    bloodTypePickerView.delegate = self;
    bloodTypePickerView.showsSelectionIndicator = YES;
    bloodTypePickerView.hidden = NO;
    _bloodType.inputView = bloodTypePickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self changeColorPlaceHolder];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void) changeColorPlaceHolder {
    UIColor *color = [UIColor whiteColor];
    [CommonF chageColorPlaceHolder:_email withColor:color];
    [CommonF chageColorPlaceHolder:_password withColor:color];
    [CommonF chageColorPlaceHolder:_passwordAgain withColor:color];
    [CommonF chageColorPlaceHolder:_address withColor:color];
    [CommonF chageColorPlaceHolder:_bloodType withColor:color];
    [CommonF chageColorPlaceHolder:_address withColor:color];
    [CommonF chageColorPlaceHolder:_phone withColor:color];
}

- (void)didPressReturnKey{
    [popupController dismiss];
}

- (BOOL) checkTextFieldIsNotNull{
    if ([_email.text isEqual:@""]||[_password isEqual:@""]||[_passwordAgain.text isEqual:@""]||[_phone.text isEqual:@""]||[_bloodType.text isEqual:@""]) {
        
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

- (BOOL) checkPasswordEqual{
    if ([_password.text isEqual:_passwordAgain.text]) {
        return TRUE;
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                       message:@"Mật khẩu không trùng khớp;"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return FALSE;
        
    }
}
- (void) performSignIn{
    [SVProgressHUD show];
    for (int i=0; i<BLOOD_TYPE.count; i++) {
        if ([BLOOD_TYPE[i] isEqualToString: _bloodType.text]) {
            bloodTypeId = i;
        }
    }
    [LibraryAPI checkPhoneWithPhone:_phone.text callBack:^(BOOL success, id result, id message) {
        if ([result intValue]==1) {
            [LibraryAPI checkEmailWithmail:_email.text callBack:^(BOOL success, id result, id message) {
                if ([result intValue]==1) {
                    NSString *addressStr;
                    CLLocationCoordinate2D locationCLL;
                    if ([_address.text isEqualToString:@""]) {
                        locationCLL = CLLocationCoordinate2DMake(14.058324, 108.277199);
                        addressStr = @"Vietnam";
                    }
                    else {
                        locationCLL = _location;
                        addressStr = _address.text;
                    }
                    [LibraryAPI requestToRegisterWithEmail:_email.text passWord:_password.text phone:_phone.text bloodTypeId:bloodTypeId address:addressStr location:locationCLL avatar:@"" callBack:^(BOOL success, id result, id message) {
                        if (success) {
                            [LibraryAPI logInWithEmail:_email.text andPassword:_password.text callBack:^(BOOL success, id result, id message) {
                                if (success) {
                                    //0x1062f2238
                                    //Save successfull login state
                                    UserData *user = [[UserData alloc]init];
                                    [user assignValueFromDictionary:result[0]];
                                    RLMRealm *realm = [RLMRealm defaultRealm];
                                    [realm transactionWithBlock:^{
                                        [realm deleteObjects:[UserData allObjects]];
                                        [realm addOrUpdateObject:user];
                                    }];
                                    [SVProgressHUD dismiss];
                                    SecondSignInVC *secondViewController =
                                    [self.storyboard instantiateViewControllerWithIdentifier:@"SecondSignInVC"];
                                    [self.navigationController pushViewController:secondViewController animated:YES];
                                }}
                             ];
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
                else{
                    [SVProgressHUD dismiss];
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Lỗi"
                                                                                   message:@"email này đã được sử dụng!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                }
            }];
        }
        else{
            [SVProgressHUD dismiss];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Lỗi"
                                                                           message:@"Số điện thoại này đã được sử dụng"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        
    }];
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

- (BOOL)isCorrectInput {
    NSString *email    = _email.text;
    NSString *password = _password.text;
    NSString *passwordAgain = _passwordAgain.text;
    
    if (email.length < 1) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
                                                                       message:MSG_NEED_ENTER_EMAIL
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (![Utils isValidEmail:_email.text]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
                                                                       message:MSG_WRONG_EMAIL_AT_LOGIN
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (password.length < 1) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
                                                                       message:MSG_NEED_ENTER_PASSWORD
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    if ([_passwordAgain.text isEqual:@""]) {
        [self showAlert:@"Chưa xác nhận lại mật khẩu"];
        return  NO;
    }
    if (![password isEqual:passwordAgain]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
                                                                       message:MSG_PASSWORD_DOESNT_MATCH
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
//    if ([_email.text isEqual:@""]) {
//        [self showAlert:@"Chưa nhập địa chỉ mail"];
//        return  NO;
//    }
    if ([_password.text isEqual:@""]){
        [self showAlert:@"Chưa nhập mật khẩu"];
        return NO;
    }

    if ([_phone.text isEqual:@""]) {
        [self showAlert:@"Chưa nhập số điện thoại"];

        return  NO;
    }
    
    return  YES;
}

- (void) showAlert:(NSString*) alertString{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                   message:alertString
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)doneTyping{
    // When the "done" button is tapped, the keyboard should go away.
    // That simply means that we just have to resign our first responder.
    [_bloodType resignFirstResponder];
}

-(void)dismissKeyboard{
    [_bloodType endEditing:YES];
}

-(void)didEndTyping{
    [popupController popViewControllerAnimated:YES];
}
#pragma mark - Public Methods

#pragma mark - IB Outlet Action
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSignIn:(id)sender {
    if ([self isCorrectInput]) {
        [self performSignIn];
    }
}

#pragma mark -


#pragma mark - TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _address) {
        [_bloodType resignFirstResponder];
        [inputAccView removeFromSuperview];
        [bloodTypePickerView removeFromSuperview];
        MapRegisterViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapRegisterViewController"];
        secondViewController.myDelegate = self;

        if (self.place) {
            secondViewController.placeSelected = self.place;
        }
        
        [self.navigationController pushViewController:secondViewController animated:YES];
        [self.view endEditing:YES];
    } else {
        PopUpTextField *field = [[NSBundle mainBundle] loadNibNamed:@"PopUpTextField" owner:self options:nil][0];
        field.myDelegate = self;
        field.txtField.delegate = field;

        field.txtField.secureTextEntry = textField.secureTextEntry;
        field.txtField.keyboardType = textField.keyboardType;

        field.Taget = textField;
        field.txtField.text = textField.text;
        field.imgIcon.image = [UIImage imageNamed:CIcon[textField.tag]];
        field.imgIcon.contentMode = UIViewContentModeScaleAspectFit;
        [field.txtField becomeFirstResponder];
        popupController = [[STPopupController alloc] initWithRootViewController:field];
        [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:field action:@selector(backgroundViewDidTap:)]];
        [popupController setNavigationBarHidden:TRUE];
        [popupController presentInViewController:self];
        [self.view endEditing:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _email) {
    }
}

#pragma mark - MapRegisterDelegate
- (void) didFindAddress:(NSString *)address andLocation:(CLLocationCoordinate2D)location{
    _address.text = address;
    _location = location;
}

- (void) didFindAddressWithPlace:(GMSPlace *)place {
    self.place = place;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPickerViewDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [BLOOD_TYPE count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    title = [BLOOD_TYPE objectAtIndex:row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _bloodType.text = [BLOOD_TYPE objectAtIndex:row];
}

@end
