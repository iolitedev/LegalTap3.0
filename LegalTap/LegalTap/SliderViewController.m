//
//  SliderViewController.m
//  LegalTap
//
//  Created by Nikhil Bansal on 5/14/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "SliderViewController.h"
#import "MeetUsViewController.h"
#import "LegalViewController.h"
#import "FavoriteLawyerViewController.h"
#import "MyAccountViewController.h"
#import "AccountBalanceViewController.h"
#import "ApplyCouponViewController.h"
#import "UpdateInformationViewController.h"
#import "UpdateAddressViewController.h"
#import "PaymentUpdateViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController

- (void)viewDidLoad
{
    myAccount.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    favoriteLawyersBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    legalBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    helpBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    logoutBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    
    
    AccountBalLbl.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
    applyCouponLbl.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
    EmailLbl.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
    AddressLbl.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
    cardInfoLbl.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _scrollView.contentSize = CGSizeMake(200,600);
    }
    else if (IS_IPHONE_5)
    {
        _scrollView.contentSize = CGSizeMake(200,600);
    }
    else if (IS_IPHONE_6)
    {
        _scrollView.contentSize = CGSizeMake(200,620);
        
    }
    else{
        _scrollView.contentSize = CGSizeMake(200,620);
    }

    
    

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)MyAccountBtn:(id)sender
{
//   MyAccount
    MyAccountViewController *MyAccountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAccount"];
    [self.navigationController pushViewController:MyAccountVC animated:YES];
    [self HideSliderHomeView];
}

- (IBAction)MyFavoriteLawyers:(id)sender
{
    FavoriteLawyerViewController *FavListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FavLawyer"];
    [self.navigationController pushViewController:FavListVC animated:YES];
    [self HideSliderHomeView];
}

- (IBAction)Legal:(id)sender
{
    LegalViewController *LegalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LegalVc"];
    [self.navigationController pushViewController:LegalVC animated:YES];
    [self HideSliderHomeView];
}

- (IBAction)Help:(id)sender
{
    MeetUsViewController *MeetUsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetUSVC"];
    [self.navigationController pushViewController:MeetUsVC animated:YES];
    [self HideSliderHomeView];
}

- (IBAction)LogOut:(id)sender
{
    //LOGOUT
    [CommonHelper removeUserDetail];
    [SharedSingleton sharedClient].user_Profile = nil;
   // [[QBChat instance] logout];
    [self.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    [self HideSliderHomeView];
}

- (IBAction)sLIDERbUTTON:(id)sender
{
    if (!_VC)
    {
        _VC = [[HomeViewController alloc] init];
    }
    _VC.ShowSliderView=YES;
    [_VC SliderButton:sender];
}

- (IBAction)AccountBalanceBtn:(id)sender
{
    AccountBalanceViewController *BalanceViewObj = [self.storyboard instantiateViewControllerWithIdentifier:@"AccBalView"];
    [self.navigationController pushViewController:BalanceViewObj animated:YES];
    [self HideSliderHomeView];
}

- (IBAction)ApplyCouponBtn:(id)sender
{
    ApplyCouponViewController *CouponViewObj = [self.storyboard instantiateViewControllerWithIdentifier:@"CuponView"];
    [self.navigationController pushViewController:CouponViewObj animated:YES];
    [self HideSliderHomeView];

}

- (IBAction)ChangeEmailAndPassword:(id)sender
{
    UpdateInformationViewController *UpdateInfoObj = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateInfo"];
    [self.navigationController pushViewController:UpdateInfoObj animated:YES];
    [self HideSliderHomeView];
}

- (IBAction)UpdateAddress:(id)sender
{
    UpdateAddressViewController *UpdateAddressObj = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateAddress"];
    [self.navigationController pushViewController:UpdateAddressObj animated:YES];
    [self HideSliderHomeView];
}

- (IBAction)UpdateCardInformation:(id)sender
{
    PaymentUpdateViewController *UpdatePaymentObj = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentUpdate"];
    [self.navigationController pushViewController:UpdatePaymentObj animated:YES];
    [self HideSliderHomeView];
  
}

- (void) hideContentController: (UIViewController*) content
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         if (IS_IPHONE_6)
                         {
                             content.view.frame = CGRectMake(-250, 0, 200,650);
                             
                         }
                         else if (IS_IPHONE_6P)
                         {
                             content.view.frame = CGRectMake(-250, 0, 200,750);
                             
                         }
                         else
                         {
                             content.view.frame = CGRectMake(-250, 0, 200,550);
                         }
                         
                     }];
}
-(void)HideSliderHomeView
{
    if (!_VC)
    {
        _VC = [[HomeViewController alloc] init];
    }
    [_VC HideSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
