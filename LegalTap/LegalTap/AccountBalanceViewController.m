//
//  AccountBalanceViewController.m
//  LegalTap
//
//  Created by Nikhil Bansal on 4/30/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "AccountBalanceViewController.h"

@interface AccountBalanceViewController ()

@end

@implementation AccountBalanceViewController

- (void)viewDidLoad
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

    self.title=@"Account";
    
    [self GetAccountBalance];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)GetAccountBalance
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper GetAccountBalance:userId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
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
                     NSString *Balance=[responseObject valueForKey:@"balance"];
                     AccBalLabel.text=[NSString stringWithFormat:@"Your Account Balance is : %@%@",@"$",Balance];
                                     
                 }
                 else
                 {
//                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                     message:@""
//                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                     [alert show];
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                     NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:errorMsg
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //Error
          //   NSString *errorMsg = [responseObject valueForKey:@"message"];

             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             AccBalLabel.text=[NSString stringWithFormat:@"Your Account Balance is : %@%@",@"$",@"0"];

//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                             message:errorMsg
//                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            // [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
         
     }];
}

- (IBAction)BackBarButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
