//
//  UpdateInformationViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/12/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "UpdateInformationViewController.h"

@interface UpdateInformationViewController ()

@end

@implementation UpdateInformationViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor colorWithRed:0/255.0f green:133/255.0f blue:198/255.0f alpha:1.0f]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    txt_Email.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    txt_CurrentPassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    txt_NewPassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    EMAIL_BG.layer.borderWidth=1.0;
    EMAIL_BG.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    
    currentPass_bg.layer.borderWidth=1.0;
    currentPass_bg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;

    NewPass_bg.layer.borderWidth=1.0;
    NewPass_bg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    
    [emailLbl setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    [currentPassLbl setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    [newPassLbl setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    
    [EMAIL_BG setBackgroundColor:[UIColor clearColor]];
    [currentPass_bg setBackgroundColor:[UIColor clearColor]];
    [NewPass_bg setBackgroundColor:[UIColor clearColor]];
    
    UIView *statusBarView;
    if (IS_IPHONE_6)
    {
        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 380, 22)];
        
    }
    else if (IS_IPHONE_6P)
    {
        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 420, 22)];
        
    }

    else
    {
        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 22)];
        
    }
    statusBarView.backgroundColor = [UIColor colorWithRed:70/255.0f green:130/255.0f blue:180/255.0f alpha:1.0f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    UIImage *navBarImg = [UIImage imageNamed:@"Navigation_bg_white"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

    
    [self showUserDetail];
}
- (void)backBarButton
{
    //    [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked_SaveUpdate:(id)sender
{
    NSString *strEmail = txt_Email.text;
    NSString *strCurrentPassword = txt_CurrentPassword.text;
    NSString *strNewPassword = txt_NewPassword.text;
    
    if (!strEmail.length)
    {
        //Empty Email
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Email Address is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!strCurrentPassword.length)
    {
        //Empty password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Current Password is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!strNewPassword.length)
    {
        //Empty Name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Current Password is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    if ([CommonHelper validEmail:strEmail])
    {
        NSString *pass = [CommonHelper getUserPassword];
        
        if ([pass isEqualToString:strCurrentPassword])
        {
            if (strNewPassword.length >= 8)
            {
                [self changePassword];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps!"
                                                                message:@"Please Enter at least 8 password"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps!"
                                                            message:@"Current Password don't match with old Password"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps!"
                                                        message:@"Please Enter the valid Email address"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)changePassword
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;

    NSString *strEmail = txt_Email.text;
    NSString *strUserId = user_Profile.userId;
    NSString *strCurrentPassword = txt_CurrentPassword.text;
    NSString *strNewPassword = txt_NewPassword.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper changePasswordWithEmailId:strEmail
                                          withUserId:strUserId
                                 withCurrentPassword:strCurrentPassword
                                     withNewPassword:strNewPassword
                                 withConformPassword:strNewPassword
                              andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *strSuccess = [responseObject valueForKey:@"success"];
        if (responseObject.count && strSuccess.integerValue)
        {
            [CommonHelper getUserPassword];
            
            user_Profile.email = strEmail;
            [CommonHelper saveUserId:user_Profile withUserPassword:strNewPassword withremember:[CommonHelper isRemember]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Email and Password is Updated."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            txt_CurrentPassword.text = @"";
            txt_NewPassword.text = @"";
        }
        else
        {
            NSString *strMsg = [responseObject valueForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:strMsg
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)btnClicked_Cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)BackBarButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showUserDetail
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    txt_Email.text = user_Profile.email;
    txt_Email.userInteractionEnabled = NO;
    
}
@end
