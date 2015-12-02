//
//  TutorialViewController.h
//  LegalTap
//
//  Created by Apptunix on 2/26/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTPageControl.h"
#import "SignInAndSignUpHelper.h"

@interface TutorialViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIImageView *imageView_Logo;
    
    IBOutlet UIScrollView *scrollView_Main;
    IBOutlet UIView *view_FirstTut;
    IBOutlet UIView *view_SecondTut;
    IBOutlet UIView *view_ThirdTut;
    IBOutlet UIView *view_FourthTut;
    
    
    IBOutlet UIImageView *imageView_BackGround;
    IBOutlet UILabel *lbl_Title;
    
    IBOutlet UIView *view_LoginSIgnUpButtons;
    IBOutlet UIButton *btn_Login;
    IBOutlet UIButton *btn_Signup;
    
    IBOutlet UIButton *btn_GetStarted;
    IBOutlet LTPageControl *pageControl;
    
    UITabBarController *tabBarController;
}
@end
