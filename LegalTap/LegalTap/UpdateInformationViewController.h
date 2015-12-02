//
//  UpdateInformationViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/12/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"

@interface UpdateInformationViewController : UIViewController
{
    IBOutlet UITextField *txt_Email;
    IBOutlet UITextField *txt_CurrentPassword;
    IBOutlet UITextField *txt_NewPassword;
    IBOutlet UIView *EMAIL_BG;
    IBOutlet UIView *currentPass_bg;
    IBOutlet UIView *NewPass_bg;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *currentPassLbl;
    IBOutlet UILabel *newPassLbl;
    
}
- (IBAction)btnClicked_SaveUpdate:(id)sender;
- (IBAction)btnClicked_Cancel:(id)sender;
- (IBAction)BackBarButton:(id)sender;


@end
