//
//  FormPortalViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/16/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "FormPortalViewController.h"
#import "DropDownList.h"
#import "PaypalViewController.h"

#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface FormPortalViewController ()
{
    DropDownList *dropDownList1;
    DropDownList *dropDownList2;
    UIButton *dropDownListB1;
    UIButton *dropDownListB2;
    UIButton *dropDownListB3;
    IBOutlet UIView *PickerBgView;
}
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payFutureButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@end

@implementation FormPortalViewController
@synthesize ComingFrom;
- (void)viewDidLoad
{
    //    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    //    self.navigationController.navigationBar.alpha = 0.6;
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Form Shop" properties:@{
                                              @"method": @"Form Shop",
                                              }];
    //    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    //    self.navigationController.navigationBar.alpha = 0.6;
    // https://developer.paypal.com/docs/integration/direct/accept-credit-cards/
    // Set up payPalConfig
    //    _payPalConfig = [[PayPalConfiguration alloc] init];
    //    _payPalConfig.acceptCreditCards = YES;
    //    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    //    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    //    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    //    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    //    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    //    self.successView.hidden = YES;
    //    self.environment = kPayPalEnvironment;
    //
    //    [self setAcceptCreditCards:NO];
    if (IS_IPHONE_6)
    {
        scrollView.frame=CGRectMake(scrollView.frame.origin.x, 240, scrollView.frame.size.width, scrollView.frame.size.height);
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(view_SeletionArea.frame), CGRectGetHeight(view_SeletionArea.frame)+45);
    }
    else if (IS_IPHONE_6P)
    {
        scrollView.frame=CGRectMake(scrollView.frame.origin.x, 240, scrollView.frame.size.width, scrollView.frame.size.height);
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(view_SeletionArea.frame), CGRectGetHeight(view_SeletionArea.frame)+45);
    }
    _array_List = [[CommonHelper formShopList] mutableCopy];
    // [_array_List removeObjectAtIndex:0];
    // Connect data
    PickerView.dataSource = self;
    PickerView.delegate = self;
    PickerBgView.layer.cornerRadius=5.0;
    doneBtn.layer.cornerRadius=5.0;
    //    PickerView.layer.borderWidth=1.0;
    //    PickerView.layer.borderColor=[UIColor grayColor].CGColor;
    //    recommendforms.php
    //    userId, lawyerId, formId, description
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([ComingFrom isEqualToString:@"CallView"])
    {
        [barButton_Home setImage:[UIImage imageNamed:@""]];
        barButton_Home.title=@"< Back";
    }
    if ([[SharedSingleton sharedClient].user_Profile.userType isEqualToString:@"lawyer"])
    {
        [nextBtn setTitle:@"SUGGEST FORM" forState:UIControlStateNormal];
        view_SeletionArea.frame = CGRectMake(0, 0, CGRectGetWidth(view_SeletionArea.frame), 476);
        [view_SeletionArea layoutIfNeeded];
        selectClientLabel.hidden=NO;
        dropDownListB3 = [[UIButton alloc] init];
        {
            dropDownListB3.frame = view_DropDownList3.frame;
            [dropDownListB3 setTitle:@"Choose Client" forState:UIControlStateNormal];
            //  [dropDownListB3 setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
            [dropDownListB3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [dropDownListB3 addTarget:self action:@selector(selectClient:) forControlEvents:UIControlEventTouchUpInside];
            dropDownListB3.layer.cornerRadius=5.0;
            dropDownListB3.layer.borderWidth=1.0;
            dropDownListB3.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
            //[dropDownListB3 setFont:[UIFont fontWithName:@"OpenSans-Light" size:18]];
            dropDownListB3.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
        }
        [view_SeletionArea addSubview:dropDownListB3];
        //        lbl_TextClient.hidden = YES;
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Welcome to the Form Shop! Select a legal practice area and the list of available forms for your state will show up! Click on the Form Request button and an email will be sent to a LegalTap representative.We will get back to you within two hours and help you fill out that form! All forms are $25!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        selectClientRightArrow.hidden=YES;
        [nextBtn setTitle:@"FORM REQUEST" forState:UIControlStateNormal];
        //        textViewBgView.frame=CGRectMake(35, 230, 280, 128);
        //        nextBtn.frame=CGRectMake(35, 400, 280, 44);
        selectClientLabel.hidden=YES;
        //        textView_Info.frame=CGRectMake(10, 200, 260, 108);
        //        NSArray *array2 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
        //        dropDownList2 = [array2 firstObject];
        //        {
        //            dropDownList2.frame = view_DropDownList2.frame;
        //            [dropDownList2 layoutIfNeeded];
        //
        //            NSArray *arrayList = [CommonHelper legalPracticeList];
        //            [dropDownList2 loadList:arrayList];
        //        }
        //        [view_SeletionArea addSubview:dropDownList2];
        //Button
    }
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(view_SeletionArea.frame), CGRectGetHeight(view_SeletionArea.frame));
    //    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
    //    dropDownList1 = [array1 firstObject];
    //    {
    //        dropDownList1.frame = view_DropDownList1.frame;
    //        [dropDownList1 layoutIfNeeded];
    //
    //        NSArray *arrayList = [CommonHelper legalPracticeList];
    //        [dropDownList1 loadList:arrayList];
    //    }
    //    [view_SeletionArea addSubview:dropDownList1];
    dropDownListB2 = [[UIButton alloc] init];
    {
        dropDownListB2.frame = view_DropDownList2.frame;
        [dropDownListB2 setTitle:@"Select an Available Form" forState:UIControlStateNormal];
        dropDownListB2.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        //        [dropDownListB2 setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
        [dropDownListB2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [dropDownListB2 addTarget:self action:@selector(selectFormFromList:) forControlEvents:UIControlEventTouchUpInside];
        dropDownListB2.layer.cornerRadius=5.0;
        dropDownListB2.layer.borderWidth=1.0;
        dropDownListB2.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
        [dropDownListB2 setFont:[UIFont fontWithName:@"OpenSans-Light" size:18]];
    }
    [view_SeletionArea addSubview:dropDownListB2];
    dropDownListB1 = [[UIButton alloc] init];
    {
        dropDownListB1.frame = view_DropDownList1.frame;
        [dropDownListB1 setTitle:@"Select Legal Practice Area" forState:UIControlStateNormal];
        dropDownListB1.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        // [dropDownListB1 setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
        [dropDownListB1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        dropDownListB1.layer.cornerRadius=5.0;
        dropDownListB1.layer.borderWidth=1.0;
        dropDownListB1.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
        [dropDownListB1 addTarget:self action:@selector(selectFormFromtype:) forControlEvents:UIControlEventTouchUpInside];
        [dropDownListB1 setFont:[UIFont fontWithName:@"OpenSans-Light" size:18]];
    }
    [view_SeletionArea addSubview:dropDownListB1];
    textView_Info.layer.cornerRadius=5.0;
    textView_Info.layer.borderWidth=1.0;
    textView_Info.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    legalPractice.textColor=[UIColor blackColor];
    legalPractice.textAlignment = NSTextAlignmentLeft;
    legalPractice.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
    SelectClient.textColor=[UIColor blackColor];
    SelectClient.textAlignment = NSTextAlignmentLeft;
    SelectClient.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
    ChooseForm.textColor=[UIColor blackColor];
    ChooseForm.textAlignment = NSTextAlignmentLeft;
    ChooseForm.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
    FormDesc.textColor=[UIColor blackColor];
    FormDesc.textAlignment = NSTextAlignmentLeft;
    FormDesc.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
    UIImage *navBarImg = [UIImage imageNamed:@"Navigation_bg"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    // self.navigationController.navigationBarHidden=YES;
    // self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    // self.navigationController.navigationBar.alpha = 0.5;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Payment"] isEqualToString:@"Success"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Payment"];
        [self PurchaseFormByClient];
    }
    [super viewWillAppear:YES];
    //    if (IS_IPHONE_6)
    //    {
    //        scrollView.frame=CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y+50,scrollView.frame.size.width,scrollView.frame.size.height);
    //    }
    
    // Preconnect to PayPal early
    // [self setPayPalEnvironment:self.environment];
    [self GetPaymentMethod];
}
-(void)viewDidAppear:(BOOL)animated
{
}
- (void)setPayPalEnvironment:(NSString *)environment
{
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}
-(void)LetsPayWithPaypal
{
    _payPalConfig.rememberUser=NO;
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Fare"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"25"]
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
#pragma mark - PayPalPaymentDelegate methods
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success!");
    [self showSuccess];
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setValue:@"Success" forKey:@"Payment"];
    [self.navigationController popViewControllerAnimated:NO];
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
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"View"];
}

#pragma mark Picker view Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _array_List.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _array_List[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *LegalAreaType=[_array_List objectAtIndex:row];
    if ([type isEqualToString:@"FormType"])
    {
        [dropDownListB1 setTitle:LegalAreaType forState:UIControlStateNormal];
        [dropDownListB2 setTitle:@"Select an Available Form" forState:UIControlStateNormal];
        textView_Info.text=@"";
        [dropDownListB1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([textView_Info.text isEqualToString:@""])
        {
            lbl_PlaceholderTextView.hidden = NO;
        }
        else
        {
            lbl_PlaceholderTextView.hidden = YES;
        }
    }
    else if ([type isEqualToString:@"FormList"])
    {
        if (_array_List.count)
        {
            NSString *FormName=[[_array_List objectAtIndex:row] valueForKey:@"FormName"];
            NSString *myString = [NSString stringWithFormat:@"%@",[[_array_List objectAtIndex:row] valueForKey:@"FormName"]];
            if ([myString length]<33)
                [dropDownListB2 setFont:[UIFont fontWithName:@"OpenSans-Light" size:18]];
            else
                [dropDownListB2 setFont:[UIFont fontWithName:@"OpenSans-Light" size:13]];
            [dropDownListB2 setTitle:FormName forState:UIControlStateNormal];
            NSString *desc=[[_array_List objectAtIndex:row] valueForKey:@"description"];
            textView_Info.text=desc;
            [textView_Info setFont:[UIFont fontWithName:@"OpenSans-Light" size:17]];
            NSString *FormPrice;
            NSString *price=[[_array_List objectAtIndex:row] valueForKey:@"price"];
            FormOrignalPrice=price;
            if ([[SharedSingleton sharedClient].user_Profile.userType isEqualToString:@"lawyer"])
            {
                FormPrice=[NSString stringWithFormat:@"%@",@"FORM REQUEST"];
            }
            else
            {
                FormPrice=[NSString stringWithFormat:@"%@  %@%@",@"FORM REQUEST",@"- $",price];
            }
            [nextBtn setTitle:FormPrice forState:UIControlStateNormal];
            [dropDownListB2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSString *formId=[[_array_List objectAtIndex:row] valueForKey:@"id"];
            FormId=formId;
        }
    }
    else if ([type isEqualToString:@"ClientName"])
    {
        NSString *ClientName=[[_array_List objectAtIndex:row] valueForKey:@"userName"];
        NSString *Id=[[_array_List objectAtIndex:row] valueForKey:@"userId"];
        [dropDownListB3 setTitle:ClientName forState:UIControlStateNormal];
        [dropDownListB3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UserId=Id;
    }
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString;
    if ([type isEqualToString:@"FormType"])
    {
        NSString *title = [_array_List objectAtIndex:row];
        attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    else if ([type isEqualToString:@"FormList"])
    {
        if ([_array_List count])
        {
            NSString *formName= [[_array_List objectAtIndex:row] valueForKey:@"FormName"];
            attString = [[NSAttributedString alloc] initWithString:formName attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        }
    }
    else if ([type isEqualToString:@"ClientName"])
    {
        NSString *formName= [[_array_List objectAtIndex:row] valueForKey:@"userName"];
        attString = [[NSAttributedString alloc] initWithString:formName attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    return attString;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources t0hat can be recreated.
}



-(void)selectFormFromList:(UIButton*)sender
{
    if ([dropDownListB1.titleLabel.text isEqualToString:@"Select Legal Practice Area"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Hello" message:@"Please Select Type First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([type isEqualToString:@"FormList"])
    {
        //        PickerBgView.hidden=NO;
        //        self.tabBarController.tabBar.hidden = YES;
        //        [PickerView reloadAllComponents];
        //        return;
    }
    
    NSString *FormType= dropDownListB1.titleLabel.text;
    type=@"FormList";
    //  FormListViewController *FormListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FormListVC"];
    //  FormListVC.delegate = self;
    //  FormListVC.Type=type;
    // FormListVC.SelectedFormType=FormType;
    //   [self.navigationController pushViewController:FormListVC animated:YES];
    
    [self GetFormsAccToCase:FormType];
}
-(void)selectFormFromtype:(UIButton*)sender
{
    type=@"FormType";
    // FormListViewController *FormListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FormListVC"];
    // FormListVC.delegate = self;
    // FormListVC.Type=type;
    //[self.navigationController pushViewController:FormListVC animated:YES];
    if ([type isEqualToString:@"FormType"])
    {
        _array_List = [[CommonHelper formShopList] mutableCopy];
    }
    PickerBgView.hidden=NO;
    self.tabBarController.tabBar.hidden = YES;
    [PickerView reloadAllComponents];
}
-(void)selectClient:(UIButton*)sender
{
    if ([type isEqualToString:@"ClientName"])
    {
        PickerBgView.hidden=NO;
        self.tabBarController.tabBar.hidden = YES;
        [PickerView reloadAllComponents];
        return;
    }
    
    type=@"ClientName";
    // FormListViewController *FormListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FormListVC"];
    // FormListVC.delegate = self;
    // FormListVC.Type=type;
    // [self.navigationController pushViewController:FormListVC animated:YES];
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *LawyerId=user_Profile.userId;
    [self GetClientsList:LawyerId];
    
}

-(void)FormListViewControllerDidSelect:(NSString *)LegalPractive withId:(NSString *)Id withDesc:(NSString *)Desc withPrice:(NSString *)Price withIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:@"FormType"])
    {
        [dropDownListB1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dropDownListB1 setTitle:LegalPractive forState:UIControlStateNormal];
        [dropDownListB2 setTitle:@"Select an Available Form" forState:UIControlStateNormal];
        textView_Info.text=@"";
    }
    else if ([type isEqualToString:@"FormList"])
    {
        NSString *FormPrice;
        if ([[SharedSingleton sharedClient].user_Profile.userType isEqualToString:@"lawyer"])
        {
            FormPrice=[NSString stringWithFormat:@"%@",@"FORM REQUEST"];
        }
        else
        {
            FormPrice=[NSString stringWithFormat:@"%@  %@%@",@"FORM REQUEST",@"- $",Price];
        }
        [nextBtn setTitle:FormPrice forState:UIControlStateNormal];
        [dropDownListB2 setTitle:LegalPractive forState:UIControlStateNormal];
        [dropDownListB2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        FormId=Id;
        textView_Info.text=Desc;
        if ([textView_Info.text isEqualToString:@""])
        {
            lbl_PlaceholderTextView.hidden = NO;
        }
        else
        {
            lbl_PlaceholderTextView.hidden = YES;
        }
    }
    else
    {
        [dropDownListB3 setTitle:LegalPractive forState:UIControlStateNormal];
        [dropDownListB3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UserId=Id;
    }
}

- (IBAction)DonePickerButton:(id)sender
{
    PickerBgView.hidden=YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (IBAction)btnClickedSubmit:(id)sender
{
    if ([dropDownListB1.titleLabel.text isEqualToString:@"Select Legal Practice Area"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Select Type First." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if ([dropDownListB2.titleLabel.text isEqualToString:@"Select an Available Form"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Select Form First." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //    else if ([textView_Info.text isEqualToString:@""])
    //    {
    //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Enter Description." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //        [alert show];
    //        return;
    //    }
    
    if ([[SharedSingleton sharedClient].user_Profile.userType isEqualToString:@"lawyer"])
    {
        if ([dropDownListB3.titleLabel.text isEqualToString:@"Choose Client"])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Select Client First." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [self RequestFormToClient];
    }
    else
    {
        //Mpve to payment View
        //        PaypalViewController *PaymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentView"];
        //        PaymentView.hidesBottomBarWhenPushed=YES;
        //        [self.navigationController pushViewController:PaymentView animated:YES];
        
        //        NSString *CardStatus=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PaymentType"]];
        //        if ([CardStatus isEqualToString:@"0"])
        //        {
        //            [self PaymentThroughPaypal];
        //
        //        }
        //        else if ([CardStatus isEqualToString:@"1"])
        //        {
        //            [self DirectPayment];
        //       }
        //        else
        //        {
        //            [self PaymentThroughCoupons];
        //        }
        
        if ([PaymentMethod isEqualToString:@"Skip"])
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
}

-(void)GetFormsAccToCase:(NSString*)FormType
{
    if ([FormType isEqualToString:@"WILL AND TRUSTS"])
    {
        FormType=@"WILL";
    }
    else if ([FormType isEqualToString:@"TRADEMARKS & COPYRIGHTS"])
    {
        FormType=@"TRADEMARKS AND COPYRIGHTS";
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper FormTypeWithName:FormType
                     andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 NSArray *detailUser = [responseObject objectForKey:@"data"];
                 if (detailUser && detailUser.count)
                 {
                     _array_List = [detailUser mutableCopy];
                     
                     PickerBgView.hidden=NO;
                     self.tabBarController.tabBar.hidden = YES;
                     [PickerView reloadAllComponents];
                 }
                 else
                 {
                     //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //  message:@"Try Again."
                     //  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     // [alert show];
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 _array_List=nil;
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
//             [alert show];
         }
     }];
}
-(void)GetClientsList:(NSString *)LawyerId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper ClientsListLinkedWithLawyer:LawyerId
                                andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 NSArray *detailUser = [responseObject objectForKey:@"data"];
                 if (detailUser && detailUser.count)
                 {
                     _array_List = [detailUser mutableCopy];
                     
                     PickerBgView.hidden=NO;
                     self.tabBarController.tabBar.hidden = YES;
                     [PickerView reloadAllComponents];
                     
                     [PickerView reloadAllComponents];
                 }
                 else
                 {
                     //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //  message:@"Try Again."
                     //  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     // [alert show];
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

-(void)RequestFormToClient
{
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Request Form" properties:@{
                                                 @"method": @"Request Form",
                                                 }];
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *LawyerId=user_Profile.userId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper RequestFormToClient:UserId withLawerId:LawyerId withFormId:FormId withDescription:textView_Info.text
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
                         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Form Suggestion Sent to Client On their Email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                         [dropDownListB1 setTitle:@"Select Legal Practice Area" forState:UIControlStateNormal];
                         [dropDownListB2 setTitle:@"Select an Available Form" forState:UIControlStateNormal];
                         [dropDownListB3 setTitle:@"Choose Client" forState:UIControlStateNormal];
                         textView_Info.text=@"";
                         [self textViewChangeText:textView_Info];
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
    [SignInAndSignUpHelper PurchaseFormByClient:ClientId withFormId:FormId
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
                         [dropDownListB1 setTitle:@"Select Legal Practice Area" forState:UIControlStateNormal];
                         [dropDownListB2 setTitle:@"Select an Available Form" forState:UIControlStateNormal];
                         textView_Info.text=@"";
                         [self textViewChangeText:textView_Info];
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

-(void)DirectPayment
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper DirectPayWithCard:userId
                                  withAmount:FormOrignalPrice
                                    withtype:@"form"
                                  withFormId:FormId
                                withBundleId:@""
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
    [SignInAndSignUpHelper PayWithPaypal:userId
                              withAmount:FormOrignalPrice
                                withtype:@"form"
                              withFormId:FormId
                            withBundleId:@""
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
    [SignInAndSignUpHelper PayWithCoupons:userId
                               withAmount:FormOrignalPrice
                                 withtype:@"form"
                               withFormId:FormId
                             withBundleId:@""
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

- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender
{
    if ([ComingFrom isEqualToString:@"CallView"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
    }
}

#pragma mark - Text View Delegates

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self textViewChangeText:textView];
    return textView.text.length + (text.length - range.length) <= 140;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self textViewChangeText:textView];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self textViewChangeText:textView];
}

-(void)textViewChangeText:(UITextView*)textView
{
    if ([textView.text isEqualToString:@""])
    {
        lbl_PlaceholderTextView.hidden = NO;
    }
    else
    {
        lbl_PlaceholderTextView.hidden = YES;
    }
}

#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==20)
    {
        if (buttonIndex==0)
        {
            [self.tabBarController setSelectedIndex:0];
        }
    }
}

@end
