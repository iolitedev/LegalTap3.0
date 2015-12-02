//
//  ApplyCouponViewController.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/24/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "ApplyCouponViewController.h"

@interface ApplyCouponViewController ()

@end

@implementation ApplyCouponViewController
@synthesize ComingFromView;

- (void)viewDidLoad
{
    if ([ComingFromView isEqualToString:@"RegisterPayment"])
    {
        cancelBtn.hidden=NO;
    }
    else
    {
        self.navigationController.navigationBarHidden=NO;
        
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
    }
    
    StaticTextLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    CouponCodeView.layer.borderWidth=1.0;
    CouponCodeView.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnClicked_ApplyCoupon:(id)sender
{
    NSString *strCoupon = txt_Coupon.text;
    if (strCoupon.length)
    {
        [self ApplyCoupon];
    }
}

- (IBAction)CancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==40)
    {
        if (buttonIndex==0)
        {
            if ([ComingFromView isEqualToString:@"RegisterPayment"])
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"Valid" forKey:@"Coupon"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"NotValid" forKey:@"Coupon"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

-(void)ApplyCoupon
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *UserId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper ApplyCuponCode:UserId withCuponCode:txt_Coupon.text
                        andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if (responseObject && responseObject.count)
                 {
                     //  UserProfile *user_Profile = [[UserProfile alloc] initWithDictionary:detailUser];
                     if ([[responseObject valueForKey:@"success"] integerValue]==1)
                     {
                         NSString *DiscountAmount=[responseObject valueForKey:@"discount"];
                         
                         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@%@",@"Your Coupon Number Is Valid For $",DiscountAmount] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         alert.tag=40;
                         [alert show];
                         [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"PaymentType"];
                         [self SendPaymentTypeToServer];

                     }
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
             //    NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"This coupon has been already used."
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Try Again.."
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         
     }];
}
-(void)SendPaymentTypeToServer
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper SendPaymentMethodToServer:userId withMethodType:@"Cupon" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {

                 }
                 else
                 {
                     //                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //                                                                     message:@"Please Check Your Account Details For Payment"
                     //                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     //                     [alert show];
                 }
             }
             else
             {
                 //                 //Empty Response
                 //                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 //                 //    NSString *errorMsg = [responseObject valueForKey:@"message"];
                 //                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                 //                                                                 message:@"Please Check Your Account Details For Payment"
                 //                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 //                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //             //Error
             //             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             //             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
             //                                                             message:@"Please Check Your Account Details For Payment"
             //                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             //             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         
     }];
}
- (IBAction)BackBarButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==txt_Coupon)
    {
        //limit the size :
        int limit = 9;
        return !([textField.text length]>limit && [string length] > range.length);
        
    }
    
    return YES;
}


@end
