//
//  SignUpViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "SignUpViewController.h"
#import "PaymentUpdateViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
    dropDownState = [array firstObject];
    {
        view_State.layer.borderColor = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
        dropDownState.frame = view_State.frame;
        [dropDownState layoutIfNeeded];
        [dropDownState loadList:[CommonHelper stateList]];
        [dropDownState hideBackGround];
    }
    [view_State.superview addSubview:dropDownState];
    
    FirstNameFg.layer.borderWidth=2.0;
    FirstNameFg.layer.cornerRadius=5.0;
    FirstNameFg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    
    LastNameBg.layer.borderWidth=2.0;
    LastNameBg.layer.cornerRadius=5.0;
    LastNameBg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    
    EmailBg.layer.borderWidth=2.0;
    EmailBg.layer.cornerRadius=5.0;
    EmailBg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    
    PasswordBg.layer.borderWidth=2.0;
    PasswordBg.layer.cornerRadius=5.0;
    PasswordBg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    
    TickBg.layer.borderWidth=2.0;
    TickBg.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;

    [LTAPIClientManager sharedClient];

    btnTermandContitions.titleLabel.textAlignment = NSTextAlignmentRight;
    ScrollView.contentSize = CGSizeMake(ScrollView.frame.size.width, 630);
    
    if (IS_IPHONE_4_OR_LESS)
    {
        BgScroll.contentSize = CGSizeMake(300, 450);
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
    
    if ([segue.identifier isEqualToString:@"SignUpToPayment"])
    {
        PaymentUpdateViewController *paymentVC = segue.destinationViewController;
        paymentVC.identifierPaymentVC = @"SignUpToPayment";
    }
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Actions

- (IBAction)btnClicked_TermAndConditions:(id)sender
{
//    bgView.hidden=NO;
//    ScrollView.hidden=NO;
//    bgView.layer.cornerRadius=5.0;
//    bgView.layer.borderWidth=1.0;
//    
//    textViewOutLet.hidden=NO;
//    TOUTextView.hidden=YES;
//    privacyTextView.hidden=YES;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@attorney-terms-of-use/#slogan",CSAPIBaseURLString]]];

}

- (IBAction)btnClicked_AgreeTandC:(UIButton *)sender
{
    imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;
    TickImageView1.hidden = !TickImageView1.hidden;

}

- (IBAction)TermsOfServices:(id)sender
{
//    bgView.hidden=NO;
//    ScrollView.hidden=NO;
//    bgView.layer.cornerRadius=5.0;
//    bgView.layer.borderWidth=1.0;
//    
//    textViewOutLet.hidden=YES;
//    TOUTextView.hidden=NO;
//    privacyTextView.hidden=YES;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@terms-of-use/#slogan",CSAPIBaseURLString]]];
    
}

- (IBAction)PrivacyPolicy:(id)sender
{
//    bgView.hidden=NO;
//    ScrollView.hidden=NO;
//    bgView.layer.cornerRadius=5.0;
//    bgView.layer.borderWidth=1.0;
//    
//    textViewOutLet.hidden=YES;
//    TOUTextView.hidden=YES;
//    privacyTextView.hidden=NO;
    
    
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@privacy-policy/#slogan",CSAPIBaseURLString]]];

}

- (IBAction)CnclBtn:(id)sender
{
    bgView.hidden=YES;
    ScrollView.hidden=YES;
  
}


- (IBAction)AgreeBtn1:(id)sender
{
    TickImageView1.hidden = !TickImageView1.hidden;
    imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;

}

-(IBAction)CancelButton:(id)sender
{
    [BackgroundView removeFromSuperview];
}

#pragma mark - UIWeb View Delegates

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (IBAction)btnClicked_AddProfilePic:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Media Type"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose Existing Photo",nil];
    
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

//- (IBAction)btnClicked_SignUp:(UIButton *)sender
//{
//    
//    [self performSegueWithIdentifier:@"SignUpToPayment" sender:self];
//}

- (IBAction)btnClicked_SignUp:(UIButton *)sender
{
    NSString *strName = txt_Name.text;
    NSString *lastName = txt_Lastname.text;

    NSString *strEmail = txt_EmailAddress.text;
    NSString *strPassword = txt_Password.text;
    
    BOOL remember = !imageView_AgreeTandC.hidden;

    if (!strEmail.length)
    {
        //Empty Email
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Email Address is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!strPassword.length)
    {
        //Empty password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Password is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!strName.length)
    {
        //Empty Name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Name is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!lastName.length)
    {
        //Empty Name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Last Name is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    else if (![CommonHelper validEmail:strEmail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps!"
                                                        message:@"Please Enter the valid Email address"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!(strPassword.length >= 8))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps!"
                                                        message:@"Please Enter at least 8 password"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!remember)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"T&C are not Accepted"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([dropDownState.lbl_Text.text isEqualToString:@"Select State"])
    {
        //Empty Name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"State Field"
                                                        message:@"State is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
//    else if (!userImage)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Please Select the Profile Picture"
//                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper getQuickBoxTokenWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 stringToken = [responseObject valueForKey:@"token"];
                 
                 NSString *deviceToken=[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"];
                 if (deviceToken==nil)
                 {
                     deviceToken=@"temp";
                 }
                 
                 [SignInAndSignUpHelper upLoadImageForRegisterOfUserWithImage:userImage andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                  {
                      NSString *imageURl = @"";
                      if (!error)
                      {
                          NSString *strSuccess = [responseObject valueForKey:@"success"];
                          if (responseObject.count && strSuccess.integerValue)
                          {
                              imageURl = [responseObject objectForKey:@"image"];
                          }
                      }
                      else
                      {
                          imageURl = @"temp";
                      }
                      NSString *state = dropDownState.lbl_Text.text;
                      
                      //emailId,password,firstName,userType,deviceType,deviceToken,image
                      [SignInAndSignUpHelper registerUserWithEmailid:strEmail
                                                        withPassword:strPassword
                                                       withFirstName:strName
                                                           withToken:stringToken
                                                         withAddress:@""
                                                            withCity:@""
                                                           withState:state
                                                         withZipCode:@""
                                                         withCountry:@""
                                                   withContactNumber:@""
                                                        withUserType:@"user"
                                                      withDeviceType:@"iOS"
                                                     withDeviceToken:deviceToken
                                                           withImage:@"temp"
                                                           withLastName:lastName
                                              andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                       {
                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                           if (!error)
                           {
                               NSString *strSuccess = [responseObject valueForKey:@"success"];
                               if (responseObject.count && strSuccess.integerValue)
                               {
                                   NSString *userId = [CommonHelper replaceNullToBlankString:[responseObject objectForKey:@"userId"]];
                                   if (userId.length)
                                   {
                                       UserProfile *user_Profile = [[UserProfile alloc] init];
                                       user_Profile.userId = userId;
                                       user_Profile.name = strName;
                                       user_Profile.lastname = lastName;
                                       user_Profile.email = strEmail;
                                       user_Profile.imageURL = imageURl;
                                       user_Profile.userType = @"user";
                                       user_Profile.state =state;
                                       
                                       user_Profile.quickBlox_Id = [CommonHelper replaceNullToBlankString:[responseObject objectForKey:@"quickBloxId"]];
                                       user_Profile.quickBlox_UserName = [CommonHelper replaceNullToBlankString:[responseObject objectForKey:@"quickBloxUserName"]];

                                       
                                       user_Profile.address = @"";
                                       user_Profile.city = @"";
                                       user_Profile.mobileNumber = @"";

                                       [SharedSingleton sharedClient].user_Profile = user_Profile;
                                       [CommonHelper saveUserId:user_Profile withUserPassword:strPassword withremember:YES];
                                       
                                       // Later, you can get your instance with
                                       Mixpanel *mixpanel = [Mixpanel sharedInstance];
                                       [mixpanel track:@"Sign Up" properties:@{
                                                                             @"method": @"Sign Up",
                                                                             }];

                                       
                                       [self performSegueWithIdentifier:@"SignUpToPayment" sender:self];
                                   }
                                   else
                                   {
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                       message:@"Sign-Up Failed Try again."
                                                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                       [alert show];
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
//                                      [alert show];
                               }
                           }
                           else
                           {
                               //Error
                               NSString *errorMsg = [responseObject valueForKey:@"message"];
                               NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                               message:errorMsg
                                                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                               [alert show];

                           }
                           txt_EmailAddress.text = @"";
                           txt_Password.text = @"";
                           txt_Lastname.text=@"";
                           txt_Name.text = @"";
                           imageView_AddProfilePic.image = nil;
                           dropDownState.lbl_Text.text=@"Select State";
                           TickImageView1.hidden = !TickImageView1.hidden;
                           imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;

                       }];
                  }];
             }
             else
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"Sign-Up Failed Try again."
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }
         else
         {
             
             if ([error.localizedDescription isEqualToString:@"The request timed out."]) {
                 [self btnClicked_SignUp:sender];
             }else{
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"Sign-Up Failed Try again."
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];

             }
             
             
         }
     }];
}

#pragma mark - UIImagePickerController delegate methods
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100)
    {
        switch (buttonIndex)
        {
            case 0:
                [self takePhotoVideo];
                break;
            case 1:
                [self choosePhotoFromGalery];
                break;
            default:
                break;
        }
    }
}

-(void)takePhotoVideo
{
    UIImagePickerController *imgPickerBackgroundImage = [[UIImagePickerController alloc] init];
    imgPickerBackgroundImage.delegate = self;
    imgPickerBackgroundImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPickerBackgroundImage animated:true completion:nil];
}

-(void)choosePhotoFromGalery
{
    UIImagePickerController *imgPickerBackgroundImage = [[UIImagePickerController alloc] init];
    imgPickerBackgroundImage.delegate = self;
    imgPickerBackgroundImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPickerBackgroundImage animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:true completion:nil];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType] ;
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        imageView_AddProfilePic.image = [[info objectForKey:UIImagePickerControllerOriginalImage] copy];
        imageView_AddProfilePic.layer.cornerRadius = CGRectGetHeight(imageView_AddProfilePic.frame)/2;
        imageView_AddProfilePic.clipsToBounds = YES;
        imageView_AddProfilePic.contentMode = UIViewContentModeScaleAspectFill;
        
        userImage = imageView_AddProfilePic.image;
        
//     NSData *imageData = UIImagePNGRepresentation(imageView_AddProfilePic.image);
        
        
//     self settingUserImagewithUserId:str_UserId image:imageData];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}

@end
