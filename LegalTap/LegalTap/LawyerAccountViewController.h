//
//  LawyerAccountViewController.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/25/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"

@interface LawyerAccountViewController : UIViewController
{
    IBOutlet UIImageView *imageView_UserBGImage;
    IBOutlet UIImageView *imageView_UserImage;
    
    IBOutlet UILabel *lbl_Name;
    IBOutlet UILabel *lbl_LoginStatus;
    
    IBOutlet UISwitch *switch_LoginStatusChange;
    
}
- (IBAction)switchChangeStatusForUserLogin:(UISwitch *)sender;

@end
