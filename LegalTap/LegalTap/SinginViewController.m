//
//  SinginViewController.m
//  LegalTap
//
//  Created by Apptunix on 2/27/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "SinginViewController.h"

@interface SinginViewController ()

@end

@implementation SinginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    txt_Email.layer.cornerRadius = 4.0;
    txt_Password.layer.cornerRadius = 4.0;
    EmailBg.layer.borderWidth=2.0;
    PasswordBg.layer.borderWidth=2.0;
    imageView_TickBackGround.layer.borderWidth=2.0;
    EmailBg.layer.cornerRadius=5.0;
    PasswordBg.layer.cornerRadius=5.0;


    EmailBg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
;
    PasswordBg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    imageView_TickBackGround.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;


    
    if (IS_IPHONE_4_OR_LESS)
    {
        EmailBackground.frame=CGRectMake(20, 140, 280, 50);
        PasswordBackground.frame=CGRectMake(20, 210, 280, 50);
        rememberPasswordBackground.frame=CGRectMake(55, 280, 210, 30);
        notRegistered.frame=CGRectMake(20, 310, 280, 30);
        forgotPassword.frame=CGRectMake(0, 345, 320, 34);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"HomeTabBar"])
    {
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        UITabBarController *tabBarController = [segue destinationViewController];
        
        if (user_Profile && [user_Profile.userType isEqualToString:@"user"])
        {
            {
                NSArray *arraaa = tabBarController.viewControllers;
                
                NSArray *array = @[[arraaa objectAtIndex:0],[arraaa objectAtIndex:1],[arraaa objectAtIndex:2]];
                
                tabBarController.viewControllers = array;
                
                NSArray *arr1 = tabBarController.viewControllers;
                
                UINavigationController *myHomeNavigationController = [arr1 objectAtIndex:0];
                {
                    UIImage *imageUnSell = [UIImage imageNamed:@"New_home_icon"];
                    UIImage *imageSell = [UIImage imageNamed:@"New_home_icon"];
                    
                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    myHomeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"HOME" image:imageUnSell selectedImage:imageSell];
                }
                UINavigationController *myAppointmentNavigationController = [arr1 objectAtIndex:1];
                {
                    UIImage *imageUnSell = [UIImage imageNamed:@"New_appointmant_icon"];
                    UIImage *imageSell = [UIImage imageNamed:@"New_appointmant_icon"];
                    
                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    myAppointmentNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"APPOINTMENTS" image:imageUnSell selectedImage:imageSell];
                }
                UINavigationController *formPortalNavigationController = [arr1 objectAtIndex:2];
                {
                    UIImage *imageUnSell = [UIImage imageNamed:@"New_formportal_icon"];
                    UIImage *imageSell = [UIImage imageNamed:@"New_formportal_icon"];
                    
                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    formPortalNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"FORM SHOP" image:imageUnSell selectedImage:imageSell];
                }
//                UINavigationController *settingsNavigationController = [arr1 objectAtIndex:3];
//                {
//                    UIImage *imageUnSell = [UIImage imageNamed:@"New_settings_icon"];
//                    UIImage *imageSell = [UIImage imageNamed:@"New_settings_icon"];
//                    
//                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                    
//                    settingsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SETTINGS" image:imageUnSell selectedImage:imageSell];
//                }
                
                myHomeNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                myAppointmentNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                formPortalNavigationController.navigationBar.tintColor = defColor_TOPBAR;
//                settingsNavigationController.navigationBar.tintColor = defColor_TOPBAR;
            }
        }
        else
        {
            UINavigationController *myAppointmentNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAppointmentNavigationController"];
            
//            UINavigationController *formPortalNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormPortalNavigationController"];
//            UIViewController *viewc = [self.storyboard instantiateViewControllerWithIdentifier:@"FormPortal"];//FormShopViewC
//            formPortalNavigationController = [[UINavigationController alloc]initWithRootViewController:viewc];
            
            UINavigationController *settingsNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigationController"];
            
            NSArray *array = @[myAppointmentNavigationController,settingsNavigationController];
            tabBarController.viewControllers = array;
            {
                //                NSArray *arr = tabBarController.viewControllers;
                
                //                UINavigationController *myAppointmentNavigationController = [arr objectAtIndex:0];
                {
                    UIImage *imageUnSell = [UIImage imageNamed:@"New_appointmant_icon"];
                    UIImage *imageSell = [UIImage imageNamed:@"New_appointmant_icon"];
                    
                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    myAppointmentNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"APPOINTMENTS" image:imageUnSell selectedImage:imageSell];
                }
                //                UINavigationController *formPortalNavigationController = [arr objectAtIndex:1];
//                {
//                    UIImage *imageUnSell = [UIImage imageNamed:@"New_formportal_icon"];
//                    UIImage *imageSell = [UIImage imageNamed:@"New_formportal_icon"];
//                    
//                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                    
//                    formPortalNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"FORM SHOP" image:imageUnSell selectedImage:imageSell];
//                }
                //                UINavigationController *settingsNavigationController = [arr objectAtIndex:2];
                {
                    UIImage *imageUnSell = [UIImage imageNamed:@"New_settings_icon"];
                    UIImage *imageSell = [UIImage imageNamed:@"New_settings_icon"];
                    
                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    settingsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:imageUnSell selectedImage:imageSell];
                }
                
                if (IS_IPHONE_6)
                {
                    UIImage *BlueBackground = [UIImage imageNamed:@"blueImage2"];
                    [[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
                    NSLog(@"aar appearance] setSelectionIndicator");
                    myAppointmentNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                    //                formPortalNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                    //                settingsNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                }
                else if (IS_IPHONE_6P)
                {
                    UIImage *BlueBackground = [UIImage imageNamed:@"blueImage3"];
                    [[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
                    NSLog(@"aar appearance] setSelectionIndicator");
                    myAppointmentNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                    //                formPortalNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                    //                settingsNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                }
                else if (IS_IPHONE_4_OR_LESS)
                {
                    UIImage *BlueBackground = [UIImage imageNamed:@"blueImage1"];
                    [[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
                    NSLog(@"aar appearance] setSelectionIndicator");
                    myAppointmentNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                    //                formPortalNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                    //                settingsNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                }
                else
                {
                    
                }
                
            }
        }
    }
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIButton Actions

- (IBAction)btnClicked_RememberPassword:(UIButton *)sender
{
    imageView_RememberPassword.hidden = !imageView_RememberPassword.hidden;
}

- (IBAction)btnClicked_SignIn:(UIButton *)sender
{
    NSString *strEmail = txt_Email.text;
    NSString *strPassword = txt_Password.text;
    
    NSString *deviceToken=[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"];
    if (deviceToken==nil)
    {
        deviceToken=@"temp";
    }
    
    if (!strEmail.length)
    {
        //Empty Email
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Email address is required."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!strPassword.length)
    {
        //Empty password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Password is required."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([CommonHelper validEmail:strEmail])
    {
        NSLog(@"detail%@",strEmail);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [SignInAndSignUpHelper userLoginWithUserEmail:strEmail
                                         withPassword:strPassword
                                       withDeviceType:@"iOS"
                                      withDeviceToken:deviceToken
                               andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (!error)
            {
                NSString *strSuccess = [responseObject valueForKey:@"success"];
                if (responseObject.count && strSuccess.integerValue)
                {
                    NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                    if (detailUser && detailUser.count)
                    {
                        UserProfile *user_Profile = [[UserProfile alloc] initWithDictionary:detailUser];
                        [SharedSingleton sharedClient].user_Profile = user_Profile;
                        [CommonHelper saveUserId:user_Profile withUserPassword:strPassword withremember:!imageView_RememberPassword.hidden];
                        
                        txt_Email.text = @"";
                        txt_Password.text = @"";
                        
                        NSString *cardType=[responseObject valueForKey:@"card"];
                        [[NSUserDefaults standardUserDefaults] setValue:cardType forKey:@"PaymentType"];
                        
                        // Later, you can get your instance with
                        Mixpanel *mixpanel = [Mixpanel sharedInstance];
                        [mixpanel track:@"Login" properties:@{
                                                                @"method": @"Login",
                                                                }];
                        [self performSegueWithIdentifier:@"HomeTabBar" sender:self];
                        
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"Try Again."
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
                else
                {
                    //Empty Response
                    NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                    
                  //  NSString *errorMsg = [responseObject valueForKey:@"message"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"Please enter valid username and password."
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
            else
            {
                //Error
                NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Login Error"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps!"
                                                        message:@"Please enter the valid email address."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)ForgotPasswordBtn:(id)sender
{
    ForgotPasswordViewController *ForgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPassword"];
    [self.navigationController pushViewController:ForgotPasswordVC animated:YES];
}

@end
