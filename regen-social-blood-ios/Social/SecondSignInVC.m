//
//  SecondSignInVC.m
//  Social
//
//  Created by Pham Nghi on 11/10/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "SecondSignInVC.h"
#import "CommonVC.h"
#import "rootViewController.h"
#import "loginViewController.h"
#import "LibraryAPI.h"
#import "Constant.h"
#import <SVProgressHUD.h>
#import "PopUpTextField.h"
#import <STPopupController.h>
#import "TGViewController.h"

@interface SecondSignInVC ()<UITextFieldDelegate,PopUpTextFieldDelegate,TGViewControllerDelegate,UIPickerViewDelegate>
{
    UIButton *btnDone;
    UIView *inputAccView;
    NSString* avatarString;
    long bloodTypeId;
    CLLocationCoordinate2D location;
    UserData *_userData;
    STPopupController *popupController;
    UIPickerView *sexPickerView;
    
}

@end

@implementation SecondSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createInputAccessoryView];
    [_txtSex setInputAccessoryView:inputAccView];
    [CommonF chageColorPlaceHolder:_txtIdentifyCard withColor:[UIColor whiteColor]];
    [CommonF chageColorPlaceHolder:_txtName withColor:[UIColor whiteColor]];
    [CommonF chageColorPlaceHolder:_txtSex withColor:[UIColor whiteColor]];
     sexPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
     sexPickerView.delegate = self;
     sexPickerView.showsSelectionIndicator = YES;
     sexPickerView.hidden = NO;
     _txtSex.inputView = sexPickerView;
    UserDataManager *user = [LibraryAPI getUserDataManager];
    _userData = [user getUserModel];
    _imgAvatar.clipsToBounds = YES;
    location = CLLocationCoordinate2DMake(_userData.latitude, _userData.longitude);
    for (int i=0; i<BLOOD_TYPE.count; i++) {
        if (BLOOD_TYPE[i]==_userData.bloodType) {
            bloodTypeId = i;
            break;
        }
    }
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews {
    _imgAvatar.layer.cornerRadius = _imgAvatar.frame.size.width / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSkip:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnAddInfo:(id)sender {
    
    [SVProgressHUD show];
    location = CLLocationCoordinate2DMake(_userData.latitude, _userData.longitude);
    for (int i=0; i<BLOOD_TYPE.count; i++) {
        if (BLOOD_TYPE[i]==_userData.bloodType) {
            bloodTypeId = i;
            break;
        }
    }
    if (_txtSex.text==nil ) {
        _txtSex.text = _userData.sex;
    };
    if (_txtIdentifyCard.text ==nil){
        _txtIdentifyCard.text = @"";
    }
    if (_txtName.text==nil) {
        _txtName.text = @"";
    }
    if ([_imgAvatar.image isEqual:[UIImage imageNamed:@"avatarDefault"]]||[_imgAvatar.image isEqual:[UIImage imageNamed:@"addImage"]]) {
        avatarString = @"unknown";
    }
    if ([self isInvalidInput]) {
        [LibraryAPI requestToSettingProfileWithUserId:_userData.userId passWord:@"" name:_txtName.text bloodTypeId:bloodTypeId sex:[_txtSex.text isEqual:@"nam"] address:@"" phone:@"" location:location identifyCard:_txtIdentifyCard.text avatar:avatarString callBack:^(BOOL success, id result, id message) {
            if (success) {
                [SVProgressHUD dismiss];
                UserData *user = [[UserData alloc]init];
                user.email = _userData.email;
                NSString *urlString = [avatarString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; ;
                NSURL *url =[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                user.photoData = [CommonF imageToNSString:image];
                user.sex = _txtSex.text;
                user.name = _txtName.text;
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    [realm addOrUpdateObject:user];
                }];
                [SVProgressHUD dismiss];
                [self.navigationController popToRootViewControllerAnimated:YES];
                }
            else {
                NSLog(@"%@",result);
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [SVProgressHUD dismiss];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }];
    }
    else {

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thông báo"
                                                                       message:@"Xin hãy điền đầy đủ thông tin"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        [SVProgressHUD dismiss];
        
    }
    
}

- (IBAction)btnChangeAvatar:(id)sender {
    
    TGViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"TGViewController"];
    VC.myDelegate = self;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    PopUpTextField *field = [[NSBundle mainBundle] loadNibNamed:@"PopUpTextField" owner:self options:nil][0];
    field.myDelegate = self;
    field.txtField.delegate = field;
    field.Taget = textField;
    field.txtField.text = textField.text;
    if (textField.tag==1||textField.tag==2) {
        field.txtField.secureTextEntry = YES;
    }
    field.imgIcon.image = [UIImage imageNamed:CIcon[textField.tag]];
    field.imgIcon.contentMode = UIViewContentModeScaleAspectFit;
    [field.txtField becomeFirstResponder];
    popupController = [[STPopupController alloc] initWithRootViewController:field];
    [popupController setNavigationBarHidden:TRUE];
    [popupController presentInViewController:self];
    [self.view endEditing:YES];
    
}
- (void)didPressReturnKey{
    [popupController dismiss];
}

-(void)didEndTyping{
    [popupController dismiss];
}

-(void)didConfirmImage:(UIImage *)image url:(NSString*)url{
    _imgAvatar.image = image;
    avatarString = url;
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
    
    return 2;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString * title = nil;
    if (row ==0) {
        title = @"nam";
    }
    else title = @"nữ";
    return title;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
        _txtSex.text = row==0?@"nam":@"nữ";
    
}

-(void)doneTyping{
    
    // When the "done" button is tapped, the keyboard should go away.
    // That simply means that we just have to resign our first responder.
    [_txtSex resignFirstResponder];
    
}

-(BOOL)isInvalidInput{
    
    if (_txtSex.text==nil ) {
        return NO;
    };
    if (_txtIdentifyCard.text ==nil){
        return NO;
    }
    if (_txtName.text==nil) {
        return NO;
    }
    return YES;

}


@end
