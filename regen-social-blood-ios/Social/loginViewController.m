//
//  loginViewController.m
//  BanCafe
//
//  Created by Pham Nghi on 9/4/15.
//  Copyright (c) 2015 Pham Nghi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "loginViewController.h"
#import "UserData.h"
#import <SVProgressHUD.h>
#import <STPopupController.h>



@interface loginViewController () <UITextFieldDelegate,PopUpTextFieldDelegate>
{
    NSString *deviceToken;
    CGFloat keyBoardHeight;
    STPopupController *popupController;
    UserData *userData;
    long _tag;
    BOOL isFirstLoad;
}
@property (weak,atomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *pwText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCenterYLogo;



@end

@implementation loginViewController


#pragma mark - life view cycle
- (void) viewDidLayoutSubviews {
//    _imgLogo.translatesAutoresizingMaskIntoConstraints = YES ;
    if(isFirstLoad) {
        isFirstLoad = NO ;
        [NSThread sleepForTimeInterval:1.0];
        float space;
        UIView *view = [self.view viewWithTag:70];
        space = view.frame.origin.y/2;
        self.constCenterYLogo.constant = -space;
        
        [UIView animateWithDuration:1
                              delay:0.0
                        options: UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished){
                         [self hiddenAllWithFlag:FALSE];
                         [self changeAllWithAlpha:0];
                         
                         [UIView animateWithDuration:1 animations:^{
                             [self changeAllWithAlpha:1];
                         }];
                         
                     }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES ;
    [self hiddenAllWithFlag:TRUE];
    UserDataManager *user = [LibraryAPI getUserDataManager];
    deviceToken = [user getDeviceToken].deviceTokenID;
    userData = [[UserData alloc]init];
    userData = [user getUserModel];
    if (userData.didLogouted) {
        rootViewController *secondViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
        [self.navigationController pushViewController:secondViewController animated:YES];
    }
    _emailText.text = userData.email;
    //
    //_spaceOfLogo.constant = (self.view.frame.size.height - _imgLogo.frame.size.height) / 2 ;
    
    [CommonF chageColorPlaceHolder:_emailText withColor:[UIColor whiteColor]];
    [CommonF chageColorPlaceHolder:_pwText withColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"backgroundAnimate" withExtension:@"gif"];
    self.backgroundAnimate.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions

- (BOOL)isCorrectInput {
    NSString *email    = _emailText.text;
    NSString *password = _pwText.text;
    
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
    
    if (![Utils isValidEmail:_emailText.text]) {
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
    
    return  YES;
}

- (void) performLogin {
       [SVProgressHUD show];
    [LibraryAPI logInWithEmail:_emailText.text andPassword:_pwText.text callBack:^(BOOL success, id result, id message) {
        if (success) {
            UserData *user = [[UserData alloc]init];
            [user assignValueFromDictionary:result[0]];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                [realm deleteObjects:[UserData allObjects]];
                [realm addOrUpdateObject:user];
            }];
            UserDataManager *usermanager = [LibraryAPI getUserDataManager];
            deviceToken = [usermanager getDeviceToken].deviceTokenID;
            [LibraryAPI addDeviceToken:deviceToken withUserID:user.userId callBack:^(BOOL success, id result, id message) {
                if (success) {
                    NSLog(@"success");
                }
                else NSLog(@"fail");
            }];

                [SVProgressHUD dismiss];
            rootViewController *secondViewController =
            [self.storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
            [self.navigationController pushViewController:secondViewController animated:YES];

        }
        else
        {
            [SVProgressHUD dismiss];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


-(BOOL) prefersStatusBarHidden{
    return YES;
}

-(void) textFieldFirstResponeder {
    [_emailText resignFirstResponder];
    [_pwText resignFirstResponder];
}

-(void) hiddenAllWithFlag:(BOOL)flag{
    _emailText.hidden = flag;
    _pwText.hidden = flag;
    _btnLogIn.hidden = flag;
    _btnLostPW.hidden = flag;
    _btnSignIn.hidden = flag;
    _imgEmail.hidden = flag;
    _imgPassword.hidden = flag;
    _imgSologan.hidden = flag;
    _lblUnknown.hidden = flag;
    _btnTryIt.hidden = flag;
}

- (void) changeAllWithAlpha:(double)alpha{
    _emailText.alpha = alpha;
    _pwText.alpha = alpha;
    _btnLogIn.alpha = alpha;
    _btnSignIn.alpha = alpha;
    _btnLostPW.alpha = alpha;
    _imgSologan.alpha = alpha;
    _imgPassword.alpha = alpha;
    _imgEmail.alpha = alpha;
    _lblUnknown.alpha = alpha;
    _btnTryIt.alpha = alpha;
}

- (void) didPressReturnKey{
    [popupController dismiss];
}

-(void) didEndTyping{
    [popupController dismiss];
}

#pragma mark - IB Outlet Action
- (IBAction)loginBtn:(id)sender {
    if ([self isCorrectInput]) {
        [self performLogin];
    }
}

- (IBAction)btnTryIt:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Chú ý"
                                                                   message:@"Bạn không thể sử dụng đầy đủ chức năng của Regen bằng viêc dùng thử. Hãy trải nghiệm và đăng ký ngay."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self performTryIt];
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    PopUpTextField *field = [[NSBundle mainBundle] loadNibNamed:@"PopUpTextField" owner:self options:nil][0];
    field.myDelegate = self;
    field.txtField.delegate = field;
    field.Taget = textField;
    if (textField.tag==1||textField.tag==2) {
        field.txtField.secureTextEntry = YES;
    }
    field.txtField.text = textField.text;
    field.imgIcon.image = [UIImage imageNamed:CIcon[textField.tag]];
    field.imgIcon.contentMode = UIViewContentModeScaleAspectFit;
    [field.txtField becomeFirstResponder];
    popupController = [[STPopupController alloc] initWithRootViewController:field];
    [popupController setNavigationBarHidden:TRUE];
    [popupController presentInViewController:self];
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)keyboardWillShow:(NSNotification *)notification {
    keyBoardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

- (void) performTryIt{
    [SVProgressHUD show];
    [LibraryAPI logInWithEmail:@"demo@gmail.com" andPassword:@"demo123" callBack:^(BOOL success, id result, id message) {
        if (success) {
            UserData *user = [[UserData alloc]init];
            [user assignValueFromDictionary:result[0]];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                [realm deleteObjects:[UserData allObjects]];
                [realm addOrUpdateObject:user];
            }];
            [SVProgressHUD dismiss];
            rootViewController *secondViewController =
            [self.storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
            [self.navigationController pushViewController:secondViewController animated:YES];
            
        }
        else
        {
            [SVProgressHUD dismiss];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:MSG_ALERT_TITLE
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }

    }];
}



- (void) pushDeviceToken{
    }
@end
