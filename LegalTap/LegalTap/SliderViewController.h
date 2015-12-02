//
//  SliderViewController.h
//  LegalTap
//
//  Created by Nikhil Bansal on 5/14/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface SliderViewController : UIViewController
{
    IBOutlet UIButton *myAccount;
    IBOutlet UIButton *favoriteLawyersBtn;
    IBOutlet UIButton *legalBtn;
    IBOutlet UIButton *helpBtn;
    IBOutlet UIButton *logoutBtn;
    
    IBOutlet UILabel *AccountBalLbl;
    IBOutlet UILabel *applyCouponLbl;
    IBOutlet UILabel *EmailLbl;
    IBOutlet UILabel *AddressLbl;
    IBOutlet UILabel *cardInfoLbl;
    
    
    
}
- (IBAction)MyAccountBtn:(id)sender;
- (IBAction)MyFavoriteLawyers:(id)sender;
- (IBAction)Legal:(id)sender;
- (IBAction)Help:(id)sender;
- (IBAction)LogOut:(id)sender;
- (IBAction)sLIDERbUTTON:(id)sender;

- (IBAction)AccountBalanceBtn:(id)sender;
- (IBAction)ApplyCouponBtn:(id)sender;
- (IBAction)ChangeEmailAndPassword:(id)sender;
- (IBAction)UpdateAddress:(id)sender;
- (IBAction)UpdateCardInformation:(id)sender;


@property (strong, nonatomic) HomeViewController *VC;


@end
