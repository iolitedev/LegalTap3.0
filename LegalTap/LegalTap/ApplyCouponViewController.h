//
//  ApplyCouponViewController.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/24/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"


@interface ApplyCouponViewController : UIViewController<UIAlertViewDelegate>
{
    __weak IBOutlet UITextField *txt_Coupon;
    
    NSString *ComingFromView;
    IBOutlet UIButton *cancelBtn;
    IBOutlet UILabel *StaticTextLabel;
    IBOutlet UIView *CouponCodeView;
    
}
@property(nonatomic,retain) NSString *ComingFromView;
- (IBAction)btnClicked_ApplyCoupon:(id)sender;
- (IBAction)CancelButton:(id)sender;
- (IBAction)BackBarButton:(id)sender;



@end
