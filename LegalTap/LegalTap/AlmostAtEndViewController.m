//
//  AlmostAtEndViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/13/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "AlmostAtEndViewController.h"
#import "DropDownList.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface AlmostAtEndViewController ()
{
    DropDownList *dropDownLegalPractice;
    BOOL isNavigationBarHidden;
}

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payFutureButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation AlmostAtEndViewController

- (id) init
{
    self = [super init];
    if (!self) return nil;
        return self;
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    self.tabBarController.tabBar.hidden=NO;
//    [BlackView removeFromSuperview];
//    [timer invalidate];
     NSDictionary *userInfo = notification.userInfo;
     NSLog(@"%@",userInfo);
    RejectedCount=0;
}
- (void) receiveTestNotification1:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    RejectedCount=RejectedCount+1;
    NSInteger LawyersCount=[LawyerIdsArray count];
    if (LawyersCount == RejectedCount)
    {
        [timer invalidate];
        [self HideIndicator];
    }
}
- (void)viewDidLoad
{
    RejectedCount=0;
//    UIView *statusBarView;
//    if (IS_IPHONE_6)
//    {
//        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 380, 22)];
//        
//    }
//    else
//    {
//        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 22)];
//        
//    }
//    
//    statusBarView.backgroundColor = [UIColor colorWithRed:70/255.0f green:130/255.0f blue:180/255.0f alpha:1.0f];
//    [self.navigationController.navigationBar addSubview:statusBarView];
    
//    // Set up payPalConfig
//    _payPalConfig = [[PayPalConfiguration alloc] init];
//    _payPalConfig.acceptCreditCards = YES;
//    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
//    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
//    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
//    
//    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
//    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
//    self.successView.hidden = YES;
//    self.environment = kPayPalEnvironment;
//    
//    [self setAcceptCreditCards:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"YesFromLaywer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification1:)
                                                 name:@"NoFromLaywer"
                                               object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LawyerListArray=[[NSMutableArray alloc] init];
    lbl_SelectedLeagalTap.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"LawyerType"];
    {
        UIImage *imageLock = [UIImage imageNamed:@"Lock_Off"];
        UIImageView *imageViewLock = [[UIImageView alloc] init];
        imageViewLock.image = imageLock;
        imageViewLock.frame = CGRectMake(0, 0, imageLock.size.width, imageLock.size.height);
        UIView *viewImg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(txt_Duration.frame), CGRectGetHeight(txt_Duration.frame))];
        imageViewLock.center = CGPointMake(CGRectGetHeight(txt_Duration.frame)/2, CGRectGetHeight(txt_Duration.frame)/2);
        [viewImg addSubview:imageViewLock];
       // txt_Duration.rightView = viewImg;
        txt_Duration.rightViewMode = UITextFieldViewModeAlways;
    }
    {
        UIImage *imageLock = [UIImage imageNamed:@"Lock_Off"];
        UIImageView *imageViewLock = [[UIImageView alloc] init];
        imageViewLock.image = imageLock;
        imageViewLock.frame = CGRectMake(0, 0, imageLock.size.width, imageLock.size.height);
        UIView *viewImg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(txt_Duration.frame), CGRectGetHeight(txt_Duration.frame))];
        imageViewLock.center = CGPointMake(CGRectGetHeight(txt_Duration.frame)/2, CGRectGetHeight(txt_Duration.frame)/2);
        [viewImg addSubview:imageViewLock];
      //  txt_Fee.rightView = viewImg;
        txt_Fee.rightViewMode = UITextFieldViewModeAlways;
    }
    
    {
        UIImage *imageLock = [UIImage imageNamed:@"Lock_Off"];
        UIImageView *imageViewLock = [[UIImageView alloc] init];
        imageViewLock.image = imageLock;
        imageViewLock.frame = CGRectMake(0, 0, imageLock.size.width, imageLock.size.height);
        UIView *viewImg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(txt_Duration.frame), CGRectGetHeight(txt_Duration.frame))];
        imageViewLock.center = CGPointMake(CGRectGetHeight(txt_Duration.frame)/2, CGRectGetHeight(txt_Duration.frame)/2);
        [viewImg addSubview:imageViewLock];
       // txt_CardNumber.rightView = viewImg;
        txt_CardNumber.rightViewMode = UITextFieldViewModeAlways;
    }
    
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
        //198 38 140
         LetsLegalTapBtn.layer.cornerRadius=5.0;
        [LetsLegalTapBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [LetsLegalTapBtn setTitle:@"CONFIRM APPOINTMENT" forState:UIControlStateNormal];
        [LetsLegalTapBtn setBackgroundColor:[UIColor colorWithRed:(0/255.0) green:(133/255.0) blue:(198/255.0) alpha:1]];
        appointmentType=@"ConformAppointment";
    }
    else
    {
        appointmentType=@"LetsLegalTap";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    legalLbl.textColor =[UIColor blackColor];
    legalLbl.textAlignment = NSTextAlignmentLeft;
    legalLbl.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    durationLabel.textColor=[UIColor darkGrayColor];
    durationLabel.textAlignment = NSTextAlignmentLeft;
    durationLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    Fee.textColor=[UIColor blackColor];
    Fee.textAlignment = NSTextAlignmentLeft;
    Fee.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    Payment.textColor=[UIColor blackColor];
    Payment.textAlignment = NSTextAlignmentLeft;
    Payment.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    [super viewWillAppear:animated];
    isNavigationBarHidden = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = YES;
   // [self setUserImage];
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
 //   [self setPayPalEnvironment:self.environment];
    [self GetAccountBalance];
//    NSString *CardStatus=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PaymentType"]];
//    if ([CardStatus isEqualToString:@"0"])
//    {
//        txt_CardNumber.text=@"         Paypal";
//        
//    }
//    else if ([CardStatus isEqualToString:@"1"])
//    {
//        [self cardDetailUpdateInFields];
//    }
//    else
//    {
//        txt_CardNumber.text=@"   Account Balance";
//    }
    [self GetPaymentMethod];
}
- (void)setPayPalEnvironment:(NSString *)environment
{
     self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}
-(void)LetsPayWithPaypal
{
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Fare"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"40"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"LegalTap";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}
#pragma mark PayPalPaymentDelegate methods
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success!");
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setValue:@"Success" forKey:@"Payment"];
   // [self.navigationController popViewControllerAnimated:NO];
}
- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@"PayPal Payment Canceled");
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Proof of payment validation
- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment
{
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    // TransactionId=[[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"];
    //    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Your Payment has been sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //    [alert show];
    NSString *FavLawyerId=[[NSUserDefaults standardUserDefaults] valueForKey:@"FavoriteLawyerId"];
    if (FavLawyerId==nil)
    {
         [self setAppointment];
    }
    else
    {
         [self SetAppointmentForFavoriteLawyer:FavLawyerId];
    }
}
#pragma mark - Helpers
- (void)showSuccess
{
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = isNavigationBarHidden;
    
    self.tabBarController.tabBar.hidden=NO;
    [BlackView removeFromSuperview];
    [timer invalidate];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                    Balance=[[responseObject valueForKey:@"balance"] intValue];
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
           //  NSString *errorMsg = [responseObject valueForKey:@"message"];
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                             message:errorMsg
//                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//             [alert show];
             Balance=0;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
     }];
}

-(void)cardDetailUpdateInFields
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
  //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PamentHelper getserCardDetailWithUserId:user_Profile.userId
                      andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
        // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         NSString *strSuccess = [responseObject valueForKey:@"success"];
         if (!error && responseObject && strSuccess.integerValue)
         {
             NSDictionary *dict = [responseObject objectForKey:@"data"];
             NSString *cardNumber = [CommonHelper replaceNullToBlankString:dict[@"cardNumber"]];
             NSString *trimmedString=[cardNumber substringFromIndex:MAX((int)[cardNumber length]-4, 0)];
//             txt_CardNumber.text=[NSString stringWithFormat:@"%@%@",@"        ************",trimmedString];
             txt_CardNumber.text=trimmedString;
         }
         else
         {
         }
     }];
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
                     NSString *PaymentMethod=[responseObject valueForKey:@"data"];
                     if ([PaymentMethod isEqualToString:@"Skip"])
                     {
                           txt_CardNumber.text=@"No Payments";
                     }
                     else if ([PaymentMethod isEqualToString:@"Card"])
                     {
                         txt_CardNumber.text=@"Card";
                     }
                     else if ([PaymentMethod isEqualToString:@"Paypal"])
                     {
                          txt_CardNumber.text=@"   Paypal";
                     }
                     else if ([PaymentMethod isEqualToString:@"Cupon"])
                     {
                         txt_CardNumber.text=@"    Balance";
                     }
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
                 txt_CardNumber.text=@"No Payments";
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
- (IBAction)btnClicked_LetsLegalTap:(id)sender
{
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Lets Legal Tap" properties:@{
                                                       @"method": @"Lets Legal Tap",
                                                       }];
    [[NSUserDefaults standardUserDefaults] setValue:@"accept" forKey:@"call"];
    NSString *CardStatus=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PaymentType"]];
     if ([CardStatus isEqualToString:@"2"])
     {
         if (Balance<40)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"You have not sufficient Account Balance for call, Go to account settings and enter Payment details"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             return;
         }
     }
    if ([txt_CardNumber.text isEqualToString:@"No Payments"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please Select your payment method first from account settings."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    LawyerIdsArray=[[NSMutableArray alloc] init];
    NSString *FavLawyerId=[[NSUserDefaults standardUserDefaults] valueForKey:@"FavoriteLawyerId"];
    if (FavLawyerId==nil)
    {
        [self setAppointment];
    }
    else
    {
        [self SetAppointmentForFavoriteLawyer:FavLawyerId];

    }
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
    }
    else if ([_identifierPreviousVC isEqualToString:@"HomeTab"])
    {
        //Woring For Home tab
        [self AddConnectingViewInScreen];
        //Get List Of Lawyers
        [self GetListOfLawyers];
        //90 sec timer here
        timer = [NSTimer scheduledTimerWithTimeInterval:90
                                                      target: self
                                                    selector:@selector(HideIndicator)
                                                     userInfo: nil repeats:NO];
    }
}
-(void)CallToAllLawyers
{
    if (LawyerListArray.count>0)
    {
//    randomIndex = arc4random() % [LawyerListArray count];
//    NSLog(@"%lu",(unsigned long)randomIndex);
        for (int i=0; i<[LawyerListArray count]; i++)
        {
            NSString *LawyerId=[[LawyerListArray objectAtIndex:i] valueForKey:@"userId"];
            [LawyerIdsArray addObject:LawyerId];
        }
    [self CallToAllLawyers:LawyerIdsArray];
    OpponenntLawyerQBId=@"2603666";
    // [self VideoCallWithRandomUser];
    }
}

-(void)VideoCallWithRandomUser
{
    // Show Main controller
  //  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainViewController *MainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    {
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
            NSNumber *num = [NSNumber numberWithLongLong:OpponenntLawyerQBId.longLongValue];
            MainVC.opponentID = num;
    }
    //    [self presentViewController:MainVC animated:YES completion:nil];
    MainVC.ComingFromSide=@"Lawyer Side";
    [self.navigationController.tabBarController.navigationController pushViewController:MainVC animated:YES];
}

-(void)HideIndicator
{
    RejectedCount=0;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"There isn't a lawyer available right now. Would you like to schedule an appointment instead?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=1;
    [alert show];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.tabBarController.tabBar.hidden=NO;
    [BlackView removeFromSuperview];
    startTime=0;
    [CountDownTimer invalidate];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            [[NSUserDefaults standardUserDefaults] setValue:appointmentType forKey:@"CalendarTab"];
            [self.tabBarController setSelectedIndex:1];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

-(void)setUserImage
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *strUrl = user_Profile.imageURL;
    if (user_Profile.image)
    {
        imageView_UserImage.image = user_Profile.image;
       // imageView_UserBGImage.image = user_Profile.image;
        return;
    }
    if(![strUrl isEqualToString:@""])
    {
        NSString *imgStr = strUrl;
        NSURL *url = [NSURL URLWithString:imgStr];
        NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"image_placeholder"];
        __weak UIImageView *weakCell = imageView_UserImage;
        [weakCell setImageWithURLRequest:request1
                        placeholderImage:placeholderImage
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
        {
                                     weakCell.image = image;
                                     imageView_UserImage.image = image;
                                   //  imageView_UserBGImage.image = image;
                                     [weakCell setNeedsLayout];
                                 } failure:nil];
    }
}

-(void)setAppointment
{
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        NSString *strDate = @"";//(2015-03-15 22:55:22)
        {
            NSDateFormatter *dateFormatter= [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
            strDate = [dateFormatter stringFromDate:_appointmentDate];
        }
        NSArray *arrQuestions = _array_QuestionsList;
        NSArray *arrAns = _array_AnswersList;
        MBProgressHUD *obj = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        obj.labelText = @"Scheduling Your Appointment";
//[_strSelectedPractice lowercaseString]
        [AppointmentNetworkHelper makeAppointmentWithUserid:user_Profile.userId
                                                   withType:lbl_SelectedLeagalTap.text
                                               withDatetime:strDate
                                              withQuestions:arrQuestions
                                                withAnswers:arrAns
                                     andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (!error)
            {
                NSString *strSuccess = [responseObject valueForKey:@"success"];
                if (responseObject.count && strSuccess.integerValue)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"You have successfully scheduled your appointment!"
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [[NSUserDefaults standardUserDefaults] setValue:appointmentType forKey:@"CalendarTab"];

                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Appointment is not added"
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
    }
}
-(void)SetAppointmentForFavoriteLawyer:(NSString *)FavLawyerId
{
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        
        NSString *strUserDate = @"";
        NSString *strDate = @"";//(2015-03-15 22:55:22)
        {
            NSDateFormatter *dateFormatter= [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
            strDate = [dateFormatter stringFromDate:_appointmentDate];
            
            dateFormatter.timeZone = [NSTimeZone systemTimeZone];
            strUserDate = [dateFormatter stringFromDate:_appointmentDate];
        }
        NSArray *arrQuestions = _array_QuestionsList;
        NSArray *arrAns = _array_AnswersList;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //[_strSelectedPractice lowercaseString]
        [AppointmentNetworkHelper makeFavoriteAppointmentWithUserid:user_Profile.userId withType:@"All" withDatetime:strDate withLawyerId:FavLawyerId withQuestions:arrQuestions withAnswers:arrAns withUserDatetime:strUserDate andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (!error)
             {
                 NSString *strSuccess = [responseObject valueForKey:@"success"];
                 if (responseObject.count && strSuccess.integerValue)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"You have successfully scheduled your appointment!"
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:@"This lawyer is not available at this time."
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
    }
}

//-(void)makeAppointmentAtTheTimeCall
//{
//    if (![_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
//    {
//        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
//        NSString *strDate = @"";//(2015-03-15 22:55:22)
//        {
//            NSDateFormatter *dateFormatter= [NSDateFormatter new];
//            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//            strDate = [dateFormatter stringFromDate:_appointmentDate];
//            
//        }
//        NSArray *arrQuestions = _array_QuestionsList;
//        NSArray *arrAns = _array_AnswersList;
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//        //[_strSelectedPractice lowercaseString]
//        [AppointmentNetworkHelper makeAppointmentWithUserid:user_Profile.userId
//                                                   withType:@"All"
//                                               withDatetime:strDate
//                                              withQuestions:arrQuestions
//                                                withAnswers:arrAns
//                                     andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
//         {
//             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//             if (!error)
//             {
//                 NSString *strSuccess = [responseObject valueForKey:@"success"];
//                 if (responseObject.count && strSuccess.integerValue)
//                 {
//                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                     message:@"You have successfully scheduled your appointment!"
//                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                     [alert show];
//                     [self.navigationController popToRootViewControllerAnimated:YES];
//                 }
//                 else
//                 {
//                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                     message:@"Appointment is not added"
//                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                     [alert show];
//                 }
//                 
//             }
//             else
//             {
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                 message:@"Appointment is not added"
//                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                 [alert show];
//                 
//             }
//         }];
//
//    }
//}

-(void)AddConnectingViewInScreen
{
    startTime=90;
    CountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target: self
                                           selector:@selector(CountDownTimer)
                                           userInfo: nil repeats:YES];
    BlackView=[[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:BlackView];
    [self.view bringSubviewToFront:BlackView];
//    BlackView.backgroundColor=[UIColor colorWithRed:70/255.0f green:130/255.0f blue:180/255.0f alpha:1.0f];
    BlackView.backgroundColor=[UIColor whiteColor];
   // BlackView.alpha=0.7;
    self.tabBarController.tabBar.hidden=YES;
    UILabel *lbl;
    UIImageView *LogoImageView;
    if (IS_IPHONE_4_OR_LESS)
    {
        lbl=[[UILabel alloc] initWithFrame:CGRectMake(35, 190, 270, 20)];
        Timelabel=[[UILabel alloc] initWithFrame:CGRectMake(170, 30, 150, 20)];
        LogoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(70, 80, 165, 42)];
    }
    else if (IS_IPHONE_5)
    {
        Timelabel=[[UILabel alloc] initWithFrame:CGRectMake(180, 40, 150, 20)];
        lbl=[[UILabel alloc] initWithFrame:CGRectMake(20, 190, 285, 20)];
        LogoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(70, 80, 165, 42)];
    }
    else
    {
        lbl=[[UILabel alloc] initWithFrame:CGRectMake(60, 250, 280, 30)];
        Timelabel=[[UILabel alloc] initWithFrame:CGRectMake(220, 40, 150, 20)];
        LogoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(90, 90, 165, 42)];
    }
    Timelabel.text=[NSString stringWithFormat:@"%@%@",@"Time Left : ",@"90"];
    lbl.textColor=[UIColor blackColor];
    lbl.text=@"Connecting You With a Lawyer Now!";
    [BlackView addSubview:lbl];
    [LogoImageView setImage:[UIImage imageNamed:@"Logo"]];
    [BlackView addSubview:LogoImageView];
    [BlackView addSubview:Timelabel];
    UIImageView *ImageView;
    if (IS_IPHONE_4_OR_LESS)
    {
        ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(105, 235, 100, 100)];
    }
     else if (IS_IPHONE_5)
    {
        ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(105, 235, 100, 100)];
    }
    else
    {
        ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(135, 310, 100, 100)]; 
    }
    ImageView.image=[UIImage imageNamed:@"Indicator"];
    [BlackView addSubview:ImageView];
    [self runSpinAnimationOnView:ImageView duration:100 rotations:1 repeat:10];
}

-(void)CountDownTimer
{
    startTime=startTime-1;
    if (startTime==0)
    {
        startTime=0;
        [CountDownTimer invalidate];
    }
    Timelabel.text=[NSString stringWithFormat:@"%@%d",@"Time Left : ",startTime];
}

- (void) runSpinAnimationOnView:(UIImageView *)ImageView duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [ImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    [ImageView.layer removeAllAnimations];
}

-(void)GetListOfLawyers
{
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  //  DUI, PERSONAL INJURY, DIVORCE, TAX , EMPLOYMENT ,SMALL BUSINESS, REAL ESTATE, TRADEMARKS AND COPYRIGHTS, PATENTS, WILL, FAMILY, LGBT, OTHER
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *state=user_Profile.state;
    NSString *LawyerType=[[NSUserDefaults standardUserDefaults] valueForKey:@"LawyerType"];
    if ([LawyerType isEqualToString:@"Divorce"])
    {
        LawyerType=@"DIVORCE";
    }
    if ([LawyerType isEqualToString:@"Tax"])
    {
        LawyerType=@"TAX";
    }
    if ([LawyerType isEqualToString:@"Employment"])
    {
        LawyerType=@"EMPLOYMENT";
    }
    if ([LawyerType isEqualToString:@"Business"])
    {
        LawyerType=@"SMALL BUSINESS";
    }
    if ([LawyerType isEqualToString:@"TRADEMARKS & COPYRIGHTS"])
    {
        LawyerType=@"TRADEMARKS AND COPYRIGHTS";
    }
    if ([LawyerType isEqualToString:@"WILL AND TRUSTS"])
    {
        LawyerType=@"WILL";
    }
    [SignInAndSignUpHelper GetLawyersList:LawyerType withState:state
                         andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
        // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
                         LawyerListArray=[[responseObject valueForKey:@"lawyer"] mutableCopy];
                         NSLog(@"List of lawyers = = = %@",LawyerListArray);
                         //Call To All Lawyers
                         [self CallToAllLawyers];
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
//                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
//                 
//                 NSString *errorMsg = [responseObject valueForKey:@"message"];
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                 message:@"No Lawyer Is Online, Please Try Again Later"
//                                                                delegate:nil cancelButtonTitle:@"Thanks" otherButtonTitles:nil];
//                 [alert show];
//                 
//                 [BlackView removeFromSuperview];
//                 
//                 [timer invalidate];
                 [timer invalidate];
                 [self HideIndicator];
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

-(void)CallToAllLawyers:(NSMutableArray *)LawyerIds
{
    NSLog(@"Lawyer ids which i am calling = =  %@",LawyerIds);
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *UserId=user_Profile.userId;
    NSArray *arrQuestions = _array_QuestionsList;
    NSArray *arrAns = _array_AnswersList;
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper RandomCallToLawyer:LawyerIds withUserId:UserId WithQuestionArray:arrQuestions WithAnswerArray:arrAns andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
       //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
                        // UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        // [alert show];
                         NSLog(@"response=====%@",responseObject);
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

- (IBAction)BackArrowBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
