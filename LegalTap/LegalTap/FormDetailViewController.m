//
//  FormDetailViewController.m
//  LegalTap
//
//  Created by Praveen on 9/22/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//
#import "FormDetailViewController.h"

@interface FormDetailViewController ()

@end

@implementation FormDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // self.lbl_FormName.text = obj_FormShop.bundles_name;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor colorWithRed:0/255.0f green:133/255.0f blue:198/255.0f alpha:1.0f]];
    [self.navigationItem setLeftBarButtonItem:backButton];

    if (_type == FormShopsDetailView1)
    {
        form_Type = @"bundle";
        NSString *str_Forms = @"Bundle";
        NSString *main_String = [_obj_FormShop.bundle_Categorie capitalizedString];
        
        str_Forms = [[main_String stringByAppendingString:@" "] stringByAppendingString:str_Forms];
        
        self.navigationItem.title = str_Forms;
    }
        else
    {
        form_Type  = @"form";
        
        NSString *str_Forms = @"Form";
        NSString *main_String = [_obj_FormShop.bundle_Categorie capitalizedString];
        NSString *shortString;
        if ([_obj_FormShop.bundle_Categorie isEqualToString:@"TRADEMARKS AND COPYRIGHTS"]) {
            
            shortString = @"Trademarks";
            
            str_Forms = [[shortString stringByAppendingString:@" "] stringByAppendingString:str_Forms];
        }
        else
        {
            str_Forms = [[main_String stringByAppendingString:@" "] stringByAppendingString:str_Forms];
        }
        
        
        self.navigationItem.title = str_Forms;
        
    }
    
    // NSLog(@"%@",self.formDataArray);
    
    
    // NSLog(@"%@",self.obj_FormShop.bundle_Amount);
    
    strPayment_Amout = self.obj_FormShop.bundle_Amount;
    strFormID = self.obj_FormShop.bundles_id;
    
    self.imageView_FormDetail.image = [UIImage imageNamed:@"bundle_dark.png"];
    self.imageView_FormDetail.layer.cornerRadius = 5.0;
    
    UIFont *font = [UIFont  fontWithName:@"OpenSans" size: 17.0f];
    UIFont  *font2 = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0f];
    
    NSMutableAttributedString *mainString = [[NSMutableAttributedString alloc] initWithString:_obj_FormShop.bundles_name attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0]}];
    NSMutableAttributedString *objNewLine = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    
    NSMutableAttributedString *appendString = [[NSMutableAttributedString alloc] initWithString:[_obj_FormShop.bundle_Categorie capitalizedString] attributes:@{NSFontAttributeName:font2,NSForegroundColorAttributeName:[UIColor grayColor]}];
    [mainString appendAttributedString:objNewLine];
    [mainString appendAttributedString:appendString];
    
    _lbl_FormName.attributedText = mainString;
    _lbl_FormName.adjustsFontSizeToFitWidth = YES;
    _lbl_FormName.numberOfLines = 3;
    _lbl_FormName.minimumScaleFactor = 0.5;
    
    //    _lbl_FormName.text = _obj_FormShop.bundles_name;
    
    //    _lbl_FormDetailCategory.text = [_obj_FormShop.bundle_Categorie capitalizedString];
    _textView_FormDescription.text = _obj_FormShop.bundles_description;
    
    NSString *str_Doller = @"$";
    NSString *main_String = strPayment_Amout;
   
   
    if ([main_String containsString:@"$"])
    {
        _lbl_FormPrice.text = main_String;
        
    } else
    {
        str_Doller = [str_Doller stringByAppendingString:main_String];
        _lbl_FormPrice.text = str_Doller;
    }
    
}
- (void)backBarButton
{
    //[CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
        [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)viewWillAppear:(BOOL)animated
{
    UIImage *navBarImg = [UIImage imageNamed:@"Navigation_bg_white"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    
    
    [self GetPaymentMethod];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyNowButtonClick:(id)sender
{
    if (PaymentMethod == nil)
    {
        //Empty Response
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please Check Your Account Details For Payment"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else if ([PaymentMethod isEqualToString:@"Skip"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Select Payment Method First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if ([PaymentMethod isEqualToString:@"Card"])
    {
        [self DirectPayment];
    }
    else if ([PaymentMethod isEqualToString:@"Paypal"])
    {
        [self PaymentThroughPaypal];
    }
    else if ([PaymentMethod isEqualToString:@"Cupon"])
    {
        [self PaymentThroughCoupons];
    }
}

-(void)GetPaymentMethod
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper GetPaymentMethod:userId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
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
                     PaymentMethod=[responseObject valueForKey:@"data"];
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
                 //                                  //Empty Response
                 //                                  NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 //                                  //    NSString *errorMsg = [responseObject valueForKey:@"message"];
                 //                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                 //                                                                                  message:@"Please Check Your Account Details For Payment"
                 //                                                                                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 //                                  [alert show];
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




-(void)PurchaseFormByClient
{
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Purchase Form" properties:@{
                                                  @"method": @"Purchase Form",
                                                  }];
    
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *ClientId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper PurchaseFormByClient:ClientId withFormId:strFormID
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
                         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"You have successfully requested a LegalTap form. Check your email shortly to see the status of your request." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         alert.tag=20;
                         [alert show];
                         //  [dropDownListB1 setTitle:@"Select Legal Practice Area" forState:UIControlStateNormal];
                         // [dropDownListB2 setTitle:@"Select an Available Form" forState:UIControlStateNormal];
                         // textView_Info.text=@"";
                         //[self textViewChangeText:textView_Info];
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
                 
                 NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:errorMsg
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


-(void)DirectPayment
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL isForm;
    if (self.type == FormShopsDetailView2)
    {
        isForm = YES;
    }
    else
    {
        isForm = NO;
    }

    [SignInAndSignUpHelper DirectPayWithCard:userId
                                  withAmount:strPayment_Amout
                                    withtype:form_Type
                                  withFormId:isForm?strFormID:nil
                                withBundleId:isForm?nil:strFormID
                                withLawyerId:@""
                      andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     [self PurchaseFormByClient];
                     UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
                     if ([ComingFrom isEqualToString:@"Lawyer Side"])
                         
                         
                     {
                         
                         [AppointmentNetworkHelper checkAppointmentStatus:user_Profile.userId withAppointmentId:[[NSUserDefaults standardUserDefaults] valueForKey:@"appID"] withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                          {
                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              if (!error)
                              {
                                  NSString *strSuccess = [responseObject valueForKey:@"success"];
                                  if (responseObject.count && strSuccess.integerValue)
                                  {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                      message:@"Appointment Status Updated"
                                                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                      [alert show];
                                  }
                                  else
                                  {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                      message:@"Error while updating status"
                                                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                      [alert show];
                                  }
                                  
                              }
                              else
                              {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"Appointment is not added"
                                                                                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
                                  
                              }
                          }];
                         
                     }
                     else
                     {
                         
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:@"Payment Deducted"
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                     
                     
                     
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Please Check Your Account Details For Payment"
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
                                                                 message:@"Please Check Your Account Details For Payment"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Please Check Your Account Details For Payment"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         
     }];
}

-(void)PaymentThroughPaypal
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL isForm;
    if (self.type == FormShopsDetailView2)
    {
        isForm = YES;
    }
    else
    {
        isForm = NO;
    }

    
    [SignInAndSignUpHelper PayWithPaypal:userId
                              withAmount:strPayment_Amout
                                withtype:form_Type
                              withFormId:isForm?strFormID:nil
                            withBundleId:isForm?nil:strFormID
                            withLawyerId:@""
                  andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     [self PurchaseFormByClient];
                     
                     UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
                     if ([ComingFrom isEqualToString:@"Lawyer Side"])
                     {
                         
                         [AppointmentNetworkHelper checkAppointmentStatus:user_Profile.userId withAppointmentId:[[NSUserDefaults standardUserDefaults] valueForKey:@"appID"] withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                          {
                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              if (!error)
                              {
                                  NSString *strSuccess = [responseObject valueForKey:@"success"];
                                  if (responseObject.count && strSuccess.integerValue)
                                  {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                      message:@"Appointment Status Updated"
                                                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                      [alert show];
                                  }
                                  else
                                  {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                      message:@"Error while updating status"
                                                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                      [alert show];
                                  }
                                  
                              }
                              else
                              {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"Appointment is not added"
                                                                                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
                                  
                              }
                          }];
                         
                     }
                     else
                     {
                         
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:@"Payment Deducted"
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                     
                     
                     
                     
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Please Check Your Account Details For Payment"
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
                                                                 message:@"Please Check Your Account Details For Payment"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Please Check Your Account Details For Payment"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
         
     }];
}

-(void)PaymentThroughCoupons
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL isForm;
    if (self.type == FormShopsDetailView2)
    {
        isForm = YES;
    }
    else
    {
        isForm = NO;
    }
    
    
    [SignInAndSignUpHelper PayWithCoupons:userId
                               withAmount:strPayment_Amout
                                 withtype:form_Type
                               withFormId:isForm?strFormID:nil
                             withBundleId:isForm?nil:strFormID
                             withLawyerId:@""
                   andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     [self PurchaseFormByClient];
                     
                     UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
                     if ([ComingFrom isEqualToString:@"Lawyer Side"])
                     {
                         
                         [AppointmentNetworkHelper checkAppointmentStatus:user_Profile.userId withAppointmentId:[[NSUserDefaults standardUserDefaults] valueForKey:@"appID"] withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                          {
                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              if (!error)
                              {
                                  NSString *strSuccess = [responseObject valueForKey:@"success"];
                                  if (responseObject.count && strSuccess.integerValue)
                                  {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                      message:@"Appointment Status Updated"
                                                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                      [alert show];
                                  }
                                  else
                                  {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                      message:@"Error while updating status"
                                                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                      [alert show];
                                  }
                                  
                              }
                              else
                              {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"Appointment is not added"
                                                                                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
                                  
                              }
                          }];
                         
                     }
                     else
                     {
                         
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:@"Payment Deducted"
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                       [alert show];
                     }
                     
                     
                     
                     
                     
                     
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Please Check Your Account Details For Payment"
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
                                                                 message:@"Please Check Your Balance For Payment"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Please Check Your Account Details For Payment"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
         
     }];
}




@end
