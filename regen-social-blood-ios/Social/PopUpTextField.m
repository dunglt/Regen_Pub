//
//  PopUpTextField.m
//  Social
//
//  Created by Pham Nghi on 11/6/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import "PopUpTextField.h"
#import <STPopup.h>

@interface PopUpTextField()
{
    BOOL flag;
}

@end

@implementation PopUpTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    flag = false;
    self.contentSizeInPopup = CGSizeMake(280, 30);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.myDelegate didPressReturnKey];
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
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self assignDataAndDismissViewController];
}

- (void)backgroundViewDidTap:(UITapGestureRecognizer *)recognizer {
    [self assignDataAndDismissViewController]; 
}

- (void) assignDataAndDismissViewController {
    _Taget.text = self.txtField.text;
    if (flag==true) {
        [_myDelegate didEndTyping];
    }
    flag = true;
}
@end
