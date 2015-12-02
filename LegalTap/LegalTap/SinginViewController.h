//
//  SinginViewController.h
//  LegalTap
//
//  Created by Apptunix on 2/27/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"
#import "ForgotPasswordViewController.h"

@interface SinginViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txt_Email;
    IBOutlet UITextField *txt_Password;
    
    IBOutlet UIImageView *imageView_TickBackGround;
    IBOutlet UIImageView *imageView_RememberPassword;
    IBOutlet UILabel *lbl_RememberPassword;
    IBOutlet UIView *EmailBackground;
    IBOutlet UIView *PasswordBackground;
    IBOutlet UIView *rememberPasswordBackground;
    IBOutlet UIImageView *EmailBg;
    IBOutlet UIImageView *PasswordBg;
    
    
    UIView *NotifView;
    NSMutableArray *arr;
    NSMutableArray *QuestionAnsArray;
    IBOutlet UIButton *notRegistered;
    IBOutlet UIButton *forgotPassword;

}

- (IBAction)btnClicked_RememberPassword:(UIButton *)sender;
- (IBAction)btnClicked_SignIn:(UIButton *)sender;
- (IBAction)ForgotPasswordBtn:(id)sender;

@end
