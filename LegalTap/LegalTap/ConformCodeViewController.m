//
//  ConformCodeViewController.m
//  LegalTap
//
//  Created by Nikhil Bansal on 4/21/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "ConformCodeViewController.h"

@interface ConformCodeViewController ()

@end

@implementation ConformCodeViewController
@synthesize emailId,Password;

- (void)viewDidLoad
{
    EmailBg.layer.borderWidth=2.0;
    EmailBg.layer.cornerRadius=5.0;
    EmailBg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)DoneButton:(id)sender
{
    if ([codeTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Verification Code." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self ChangePassword];
    }
}

-(void)ChangePassword
{
    NSString *code=codeTextField.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper VerificationWithCodeWithEmail:emailId withToken:code withPassword:Password andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Your Password has been Changed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                     
                     
                 }
                 else
                 {
                     
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
//                 [alert show];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
}


#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [codeTextField resignFirstResponder];
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
