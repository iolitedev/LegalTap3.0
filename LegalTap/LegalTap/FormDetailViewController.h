//
//  FormDetailViewController.h
//  LegalTap
//
//  Created by Praveen on 9/22/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormShopObject.h"
#import "SignInAndSignUpHelper.h"
#import "PayPalMobile.h"
#import "AppointmentNetworkHelper.h"


typedef enum : NSUInteger {
    FormShopsDetailView1,
    FormShopsDetailView2,
    FormShopsDetailView3,
}   FormShopsDetailViewType;

@interface FormDetailViewController : UIViewController
{
    NSString *PaymentMethod;
    NSString *strPayment_Amout;
    NSString *strFormID;
    NSString *ComingFrom;
    NSString *form_Type;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView_FormDetail;

@property (strong, nonatomic) IBOutlet UILabel *lbl_FormName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_FormPrice;

@property (strong, nonatomic) IBOutlet UILabel *lbl_FormDetailCategory;

@property (strong, nonatomic) IBOutlet UITextView *textView_FormDescription;
@property (strong, nonatomic) IBOutlet UIButton *btn_BuyNow;

@property (strong, nonatomic) NSArray *formDataArray;
@property (strong, nonatomic) FormShopObject *obj_FormShop;

@property (assign, nonatomic) FormShopsDetailViewType type;


- (IBAction)buyNowButtonClick:(id)sender;

@end
