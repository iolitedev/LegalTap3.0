//
//  ForgotPasswordViewController.h
//  LegalTap
//
//  Created by Vikram on 16/04/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"
#import "ConformCodeViewController.h"


@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UITextField *EmailTextField;
    IBOutlet UITextField *PsswordTextField;
    IBOutlet UIImageView *EmailBg;
    IBOutlet UIImageView *PassBg;
    
}
- (IBAction)DoneButtonAction:(id)sender;

@end
