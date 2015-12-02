//
//  PaypalViewController.h
//  LegalTap
//
//  Created by Vikram on 26/03/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "DropDownList.h"


@interface PaypalViewController : UIViewController<PayPalPaymentDelegate,UIPopoverControllerDelegate>
{
    
    
}


- (void)setAcceptCreditCards:(BOOL)processCreditCards;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;


- (IBAction)PayWithPayPalBtnAction:(id)sender;


@end
