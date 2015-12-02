//
//  ConformCodeViewController.h
//  LegalTap
//
//  Created by Nikhil Bansal on 4/21/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"


@interface ConformCodeViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString *emailId;
    NSString *Password;
    IBOutlet UITextField *codeTextField;
    IBOutlet UIView *EmailBg;
}

@property(nonatomic,retain) NSString *emailId;
@property(nonatomic,retain) NSString *Password;
- (IBAction)DoneButton:(id)sender;


@end
