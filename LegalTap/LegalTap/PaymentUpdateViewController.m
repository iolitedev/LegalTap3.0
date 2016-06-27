//
//  PaymentUpdateViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/5/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "PaymentUpdateViewController.h"
#import "ApplyCouponViewController.h"
#define kPayPalEnvironment PayPalEnvironmentProduction
//#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface PaymentUpdateViewController ()
{
    CDatePickerViewEx *datePicker;
    
}
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payFutureButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation PaymentUpdateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor colorWithRed:0/255.0f green:133/255.0f blue:198/255.0f alpha:1.0f]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @" LegalTap,LLC";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@privacy-policy/",CSAPIBaseURLString]];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@terms-of-use/#slogan",CSAPIBaseURLString]];
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    self.successView.hidden = YES;
    self.environment = kPayPalEnvironment;
    
    [self setAcceptCreditCards:NO];
    
    // Do any additional setup after loading the view.
    
    datePicker = [[CDatePickerViewEx alloc] init];
    datePicker.backgroundColor = [UIColor whiteColor];
    txt_ValidDate.inputView = datePicker;
    datePicker.dataDelegate = self;
    [datePicker selectToday];
    
    if ([self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
    {
        
    }
    else
    {
        self.navigationController.navigationBarHidden=NO;
        SkipBtn.hidden=YES;
        [self cardDetailUpdateInFields];
        //  OrLbl.hidden=YES;
        //rememberPassView.hidden=YES;
        [self GetPaymentMethod];
//        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PaymentType"]];
//        
//        if ([str isEqualToString:@"0"])
//        {
//            imageView_AgreeTandC.hidden = NO;
//            
//        }
    }
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
    viewList = [array firstObject];
    {
        CGRect rect = view_CardType.frame;
        rect.origin.y += view_CardType.superview.frame.origin.y;
        rect.origin.x += view_CardType.superview.frame.origin.x;
        
        viewList.frame = rect;
        [viewList layoutIfNeeded];
        [viewList loadList:@[@"Visa",@"Mastercard",@"Discover",@"Amex"]];
        
        viewList.backgroundColor = [UIColor clearColor];
        viewList.layer.cornerRadius=0;
        [viewList hideBackGround];

        
        //        viewList.lbl_Text.text
    }
    [scrollView_Detail addSubview:viewList];
    scrollView_Detail.contentSize = CGSizeMake(CGRectGetWidth(view_Detail.frame),
                                               CGRectGetHeight(view_Detail.frame));
    [view_CardType bringSubviewToFront:viewList];
    [self.view bringSubviewToFront:viewList];
    
    txt_CardNumber.layer.borderWidth=1.0;
    txt_CardNumber.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    txt_ValidDate.layer.borderWidth=1.0;
    txt_ValidDate.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    txt_CVV.layer.borderWidth=1.0;
    txt_CVV.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    txt_ZipCode.layer.borderWidth=1.0;
    txt_ZipCode.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    view_CardType.layer.borderWidth=1.0;
    view_CardType.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    txt_CardNumber.leftView = paddingView;
    txt_CardNumber.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    paddingView1.backgroundColor = [UIColor clearColor];
    txt_ValidDate.leftView = paddingView1;
    txt_ValidDate.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    paddingView2.backgroundColor = [UIColor clearColor];
    txt_CVV.leftView = paddingView2;
    txt_CVV.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    paddingView3.backgroundColor = [UIColor clearColor];
    txt_ZipCode.leftView = paddingView3;
    txt_ZipCode.leftViewMode = UITextFieldViewModeAlways;

//    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
//    paddingView4.backgroundColor = [UIColor clearColor];
//    txt_CardNumber.leftView = paddingView4;
//    txt_CardNumber.leftViewMode = UITextFieldViewModeAlways;


}
- (void)backBarButton
{
    //    [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
    
    isNavigationBarHidden = self.navigationController.navigationBarHidden;
    if ([self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
    {
        self.navigationController.navigationBarHidden = YES;
    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
        
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
    
    if ([self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Coupon"] isEqualToString:@"Valid"])
        {
            //            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            [NSTimer scheduledTimerWithTimeInterval:1.0
            //                                             target:self
            //                                           selector:@selector(PushToNextView:)
            //                                           userInfo:nil
            //                                            repeats:NO];
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"PaymentType"];
            PaymentMethodType=@"Cupon";
            [self SendPaymentTypeToServer];


            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You have successfully registered and entered your payment details!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            alert.tag=22;
            [alert show];
        }
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Coupon"] isEqualToString:@"Valid"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"PaymentType"];
            PaymentMethodType=@"Cupon";
            [self SendPaymentTypeToServer];


            imageView_AgreeTandC.hidden = YES;
            
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@"NotValid" forKey:@"Coupon"];
    
    
}

- (void)setPayPalEnvironment:(NSString *)environment
{
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

-(void)LetsPayWithPaypal
{
    //    // Optional: include multiple items
    //    PayPalItem *item1 = [PayPalItem itemWithName:@"Fare"
    //                                    withQuantity:1
    //                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"40"]
    //                                    withCurrency:@"USD"
    //                                         withSku:@"Hip-00037"];
    //
    //    NSArray *items = @[item1];
    //    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    //
    //    // Optional: include payment details
    //    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    //    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    //    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
    //                                                                               withShipping:shipping
    //                                                                                    withTax:tax];
    //
    //    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    //
    //    PayPalPayment *payment = [[PayPalPayment alloc] init];
    //    payment.amount = total;
    //    payment.currencyCode = @"USD";
    //    payment.shortDescription = @"LegalTap";
    //    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    //    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    //
    //    if (!payment.processable)
    //    {
    //        // This particular payment will always be processable. If, for
    //        // example, the amount was negative or the shortDescription was
    //        // empty, this payment wouldn't be processable, and you'd want
    //        // to handle that here.
    //    }
    //
    //    // Update payPalConfig re accepting credit cards.
    //    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    //0
    //    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
    //                                                                                                configuration:self.payPalConfig
    //                                                                                                     delegate:self];
    //    [self presentViewController:paymentViewController animated:YES completion:nil];
    
    //    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
    //    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
    
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success!");
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
}
//#pragma mark - Authorize Future Payments
//
//- (IBAction)getUserAuthorizationForFuturePayments:(id)sender {
//
//    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
//    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
//}


#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization
{
    NSLog(@"PayPal Future Payment Authorization Success!");
    [self showSuccess];
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    if ([self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
    //    {
    //    //Push to home view
    //    imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PaymentType"];
    //
    //
    //    [NSTimer scheduledTimerWithTimeInterval:1.0
    //                                     target:self
    //                                   selector:@selector(PushToNextView:)
    //                                   userInfo:nil
    //                                    repeats:NO];
    //    }
    //    else
    //    {
    //        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PaymentType"];
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
    //                                                        message:@"Your Payment Method has been Selected to Paypal"
    //                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //        [alert show];
    //        imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;
    //    }
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController
{
    NSLog(@"PayPal Future Payment Authorization Canceled");
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization
{
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
    
    NSString *AuthCode=[[authorization valueForKey:@"response"] valueForKey:@"code"];
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    [self SendAuthTokenToServer:AuthCode withUserId:userId];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CardIOUtilities preload];
}

- (IBAction)btnClicked_AgreeTandC:(UIButton *)sender
{
    if ([self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
    {
        //        imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PaymentType"];
        //
        //
        //        [NSTimer scheduledTimerWithTimeInterval:2.0
        //                                         target:self
        //                                       selector:@selector(PushToNextView:)
        //                                       userInfo:nil
        //                                        repeats:NO];
        PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
        [self presentViewController:futurePaymentViewController animated:YES completion:nil];
        
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PaymentType"]];
        
        if ([str isEqualToString:@"0"])
        {
            imageView_AgreeTandC.hidden = YES;
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"PaymentType"];
            
            PaymentMethodType=@"Skip";
            [self SendPaymentTypeToServer];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Payment Method Removed"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        
        PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
        [self presentViewController:futurePaymentViewController animated:YES completion:nil];
        
        //  OrLbl.hidden=YES;
        //rememberPassView.hidden=YES;
        //        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PaymentType"];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
        //                                                        message:@"Your Payment Method has been Selected to Paypal"
        //                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
        //        imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;
        
        
    }
    
}

- (IBAction)ApplyCuponCode:(id)sender
{
    [self PushToApplyCuponCode];
}

- (IBAction)SkipButtonAction:(id)sender
{
   PaymentMethodType=@"Skip";
    [self SendPaymentTypeToServer];
}

- (IBAction)BackBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SendPaymentTypeToServer
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    if ([PaymentMethodType isEqualToString:@"Skip"])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [SignInAndSignUpHelper SendPaymentMethodToServer:userId withMethodType:PaymentMethodType andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
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
                     if ([PaymentMethodType isEqualToString:@"Skip"])
                     {
                         [self pushToNextVC];
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
                     
                    // NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PaymentType"]];
                     
                     if ([PaymentMethod isEqualToString:@"Paypal"])
                     {
                         imageView_AgreeTandC.hidden = NO;
                         
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


-(void)PushToApplyCuponCode
{
    ApplyCouponViewController *CuponView = [self.storyboard instantiateViewControllerWithIdentifier:@"CuponView"];
    
    if ([self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
    {
        CuponView.ComingFromView=@"RegisterPayment";
    }
    else
    {
        CuponView.ComingFromView=@"RegisterPayment";
    }
    
    // [self.navigationController pushViewController:CuponView animated:YES];
    [self presentViewController:CuponView animated:YES completion:nil];
    
}


-(IBAction)PushToNextView:(id)sender
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self pushToNextVC];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PaymentToTabBar"])
    {
        {
            UITabBarController *tabBarController = [segue destinationViewController];
            
            NSArray *arraaa = tabBarController.viewControllers;
            
            NSArray *array = @[[arraaa objectAtIndex:0],[arraaa objectAtIndex:1],[arraaa objectAtIndex:2]];
            
            tabBarController.viewControllers = array;
            
            NSArray *arr = tabBarController.viewControllers;
            
            UINavigationController *myHomeNavigationController = [arr objectAtIndex:0];
            {
                UIImage *imageUnSell = [UIImage imageNamed:@"New_home_icon"];
                UIImage *imageSell = [UIImage imageNamed:@"New_home_icon"];
                
                imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                myHomeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"HOME" image:imageUnSell selectedImage:imageSell];
            }
            UINavigationController *myAppointmentNavigationController = [arr objectAtIndex:1];
            {
                UIImage *imageUnSell = [UIImage imageNamed:@"New_appointmant_icon"];
                UIImage *imageSell = [UIImage imageNamed:@"New_appointmant_icon"];
                
                imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                myAppointmentNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"APPOINTMENTS" image:imageUnSell selectedImage:imageSell];
            }
            UINavigationController *formPortalNavigationController = [arr objectAtIndex:2];
            {
                UIImage *imageUnSell = [UIImage imageNamed:@"New_formportal_icon"];
                UIImage *imageSell = [UIImage imageNamed:@"New_formportal_icon"];
                
                imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAutomatic];
                imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAutomatic];
                
                formPortalNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"FORM SHOP" image:imageUnSell selectedImage:imageSell];
            }
//            UINavigationController *settingsNavigationController = [arr objectAtIndex:3];
//            {
//                UIImage *imageUnSell = [UIImage imageNamed:@"New_settings_icon"];
//                UIImage *imageSell = [UIImage imageNamed:@"New_settings_icon"];
//                
//                imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                
//                settingsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SETTINGS" image:imageUnSell selectedImage:imageSell];
//            }
            myHomeNavigationController.navigationBar.tintColor = defColor_TOPBAR;
            myAppointmentNavigationController.navigationBar.tintColor = defColor_TOPBAR;
            formPortalNavigationController.navigationBar.tintColor = defColor_TOPBAR;
//            settingsNavigationController.navigationBar.tintColor = defColor_TOPBAR;
        }
    }
}

#pragma mark - CDatePickerViewEx Delegate
-(void)CDatePickerViewEx:(CDatePickerViewEx *)pickerView didSelectDate:(NSString *)selectDate
{
    //    NSLog(@"%@",selectDate);
    txt_ValidDate.text = selectDate;
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==txt_CardNumber)
    {
        //limit the size :
        int limit = 15;
        return !([textField.text length]>limit && [string length] > range.length);
        
    }
    if (textField==txt_CVV)
    {
        //limit the size :
        int limit = 3;
        return !([textField.text length]>limit && [string length] > range.length);
    }
    
    return YES;
}


#pragma mark - Actions

- (IBAction)btnClicked_ScanCard:(id)sender
{
    cardScanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:cardScanViewController animated:YES completion:^{
        
    }];
}

- (IBAction)btnClicked_Cancel:(id)sender
{
    //   // [self pushToNextVC];
    //    NSString *cardNumber = txt_CardNumber.text;
    //    NSString *cardDate = txt_ValidDate.text;
    //    NSString *zip = txt_ZipCode.text;
    //    NSString *Cvv = txt_CVV.text;
    //
    //
    //    if ([cardNumber isEqualToString:@""]
    //        && [cardDate isEqualToString:@""]
    //        && [zip isEqualToString:@""] && [Cvv isEqualToString:@""])
    //    {
    //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Enter Payment Info" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnClicked_SaveUpdate:(id)sender
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
    //                                                    message:@"Confirmed Payment Details Accepted!"
    //                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
    //    alert.tag=22;
    //    [alert show];
    
    [self SaveCardDetailOnServer];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==22)
    {
        if (buttonIndex==0)
        {
            // [self SaveCardDetailOnServer];
            [self pushToNextVC];
            
        }
    }
}

-(void)SaveCardDetailOnServer
{
    //imageView_AgreeTandC.hidden = YES;
    
    NSString *cardNumber = txt_CardNumber.text;
    NSString *cardDate = txt_ValidDate.text;
    NSString *zip = txt_ZipCode.text;
    NSString *CardType= viewList.lbl_Text.text;
    if ([CardType isEqualToString:@"Visa"])
    {
        CardType=@"visa";
    }
    else if ([CardType isEqualToString:@"Mastercard"])
    {
        CardType=@"MasterCard";
    }
    
    if (![cardNumber isEqualToString:@""]
        && ![cardDate isEqualToString:@""]
        && ![zip isEqualToString:@""]&&![txt_CVV.text isEqualToString:@""])
    {
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PamentHelper updateUserCardDetailWithUserId:user_Profile.userId
                                      withCardNumber:cardNumber
                                       withMonthYear:cardDate
                                         withZipCode:zip
                                             withCvv:txt_CVV.text
                                        withCardType:CardType
                              andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (!error && responseObject && strSuccess.integerValue)
             {
                 //                 [self pushToNextVC];
                 
                 //                 txt_CardNumber.text = @"";
                 //                 txt_ValidDate.text = @"";
                 //                 txt_ZipCode.text = @"";
                 txt_CVV.text = @"";
                 
                 imageView_AgreeTandC.hidden = YES;
                 [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"PaymentType"];
                 PaymentMethodType=@"Card";
                 [self SendPaymentTypeToServer];


                 
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"You have successfully registered and entered your payment details!"
                                                                delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                 alert.tag=22;
                 [alert show];
                 
             }
             else
             {
                 if (![self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:@"Invalid Credit Card Details"
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
             }
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps!"
                                                        message:@"Some Fields are missing"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)cardDetailUpdateInFields
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PamentHelper getserCardDetailWithUserId:user_Profile.userId
                      andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         NSString *strSuccess = [responseObject valueForKey:@"success"];
         
         if (!error && responseObject && strSuccess.integerValue)
         {
             NSDictionary *dict = [responseObject objectForKey:@"data"];
             
             //             data =     {
             //                 cardNumber = 54545;
             //                 id = 2;
             //                 monthYear = "04/20";
             //                 status = active;
             //                 userId = 19;
             //                 zipCode = 33333;
             //             };
             
             NSString *cardNumber = [CommonHelper replaceNullToBlankString:dict[@"cardNumber"]];
             NSString *cardDate = [CommonHelper replaceNullToBlankString:dict[@"monthYear"]];
             NSString *zip = [CommonHelper replaceNullToBlankString:dict[@"zipCode"]];
             
             txt_CardNumber.text = cardNumber;
             txt_ValidDate.text = cardDate;
             txt_ZipCode.text = zip;
         }
         else
         {
             txt_CardNumber.text = @"";
             txt_ValidDate.text = @"";
             txt_ZipCode.text = @"";
         }
     }];
}

-(void)pushToNextVC
{
    if ([self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
    {

        [self performSegueWithIdentifier:@"PaymentToTabBar" sender:self];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)SendAuthTokenToServer:(NSString *)AuthToken withUserId:(NSString *)UserId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper SendAuthTokenToServer:AuthToken withUserId:UserId
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
                         if ([self.identifierPaymentVC isEqualToString:@"SignUpToPayment"])
                         {
                             //Push to home view
                             imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;
                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                             [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PaymentType"];
                             
                             
                             //                             [NSTimer scheduledTimerWithTimeInterval:0.0
                             //                                                              target:self
                             //                                                            selector:@selector(PushToNextView:)
                             //                                                            userInfo:nil
                             //                                                             repeats:NO];
                             
                             PaymentMethodType=@"Paypal";
                             [self SendPaymentTypeToServer];


                             
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                             message:@"You have successfully registered and entered your payment details!"
                                                                            delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                             alert.tag=22;
                             [alert show];
                         }
                         else
                         {
                             [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PaymentType"];
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                             message:@"Your Payment Method has been Selected to Paypal"
                                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alert show];
                             imageView_AgreeTandC.hidden = !imageView_AgreeTandC.hidden;
                             
                             PaymentMethodType=@"Paypal";
                             [self SendPaymentTypeToServer];

                         }
                         
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

#pragma mark - Card IO Delegate
-(void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [cardScanViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)cardInfo inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", cardInfo.redactedCardNumber, (unsigned long)cardInfo.expiryMonth, (unsigned long)cardInfo.expiryYear, cardInfo.cvv);
    // Use the card info...
    NSString *CardType=[NSString stringWithFormat:@"%ld",(long)cardInfo.cardType];
    NSLog(@"%@",CardType);
    
    [cardScanViewController dismissViewControllerAnimated:YES completion:nil];
    
    txt_CardNumber.text = cardInfo.redactedCardNumber;
    
    txt_CVV.text = [NSString stringWithFormat:@"%@",cardInfo.cvv];
    
    
    NSString *selectMonth = [NSString stringWithFormat:@"%02lu",(unsigned long)cardInfo.expiryMonth];
    NSString *yearString = [NSString stringWithFormat:@"%lu",(unsigned long)cardInfo.expiryYear];
    if (yearString.length == 4)
    {
        yearString = [yearString substringWithRange:NSMakeRange(2, 2)];
    }
    txt_ValidDate.text = [NSString stringWithFormat:@"%@/%@",selectMonth,yearString];
}


@end
