//
//  PopUpTextField.h
//  Social
//
//  Created by Pham Nghi on 11/6/15.
//  Copyright © 2015 Duong Tuan Dat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpTextFieldDelegate <NSObject>

-(void)didEndTyping;
-(void)didPressReturnKey;

@end

@interface PopUpTextField : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, atomic) IBOutlet UITextField *txtField;
@property (weak,atomic) UITextField *Taget;
@property (nonatomic,assign) id <PopUpTextFieldDelegate> myDelegate;

- (void)backgroundViewDidTap:(UITapGestureRecognizer *)recognizer;
@end
