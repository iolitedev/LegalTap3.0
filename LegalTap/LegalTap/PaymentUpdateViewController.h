//
//  PaymentUpdateViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/5/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDatePickerViewEx.h"
#import "CardIO.h"
#import "PamentHelper.h"
#import "DropDownList.h"
#import "PayPalMobile.h"
#import "SignInAndSignUpHelper.h"
#import "SignInAndSignUpHelper.h"




@interface PaymentUpdateViewController : UIViewController<UITextFieldDelegate,CDatePickerViewExDelegate,CardIOPaymentViewControllerDelegate,UIAlertViewDelegate,PayPalPaymentDelegate,PayPalFuturePaymentDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UITextField *txt_CardNumber;
    IBOutlet UITextField *txt_ValidDate;
    IBOutlet UITextField *txt_CVV;
    IBOutlet UITextField *txt_ZipCode;
    
    CardIOPaymentViewController *cardScanViewController;
    BOOL isNavigationBarHidden;
    
    IBOutlet UIImageView *imageView_AgreeTandC;
    IBOutlet UILabel *OrLbl;
    IBOutlet UIView *rememberPassView;

    IBOutlet UIView *view_CardType;
    
    DropDownList *viewList;
    IBOutlet UIScrollView *scrollView_Detail;
    IBOutlet UIView *view_Detail;
    
    NSString *PaymentMethodType;
    IBOutlet UIButton *SkipBtn;
}

- (IBAction)btnClicked_ScanCard:(id)sender;
- (IBAction)btnClicked_Cancel:(id)sender;
- (IBAction)btnClicked_SaveUpdate:(id)sender;
- (IBAction)btnClicked_AgreeTandC:(UIButton *)sender;
- (IBAction)ApplyCuponCode:(id)sender;
- (IBAction)SkipButtonAction:(id)sender;
- (IBAction)BackBarButtonAction:(id)sender;


@property (strong, nonatomic) NSString *identifierPaymentVC;


@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
- (void)setAcceptCreditCards:(BOOL)processCreditCards;


@end
