//
//  SignUpViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"
#import "DropDownList.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIWebViewDelegate>
{
//    imageView_AgreeTandC
    IBOutlet UIImageView *imageView_AddProfilePic;
    
    IBOutlet UITextField *txt_Name;
    IBOutlet UITextField *txt_EmailAddress;
    IBOutlet UITextField *txt_Password;
    IBOutlet UITextField *txt_Lastname;
    
    IBOutlet UIImageView *imageView_AgreeTandC;
    IBOutlet UIButton *btnTermandContitions;
    UIImage *userImage;
    NSString *userImageURL;
    NSString *stringToken;
    UIView *BackgroundView;
    IBOutlet UIView *bgView;
    IBOutlet UIImageView *TickImageView1;
    IBOutlet UITextView *textViewOutLet;
    IBOutlet UITextView *privacyTextView;
    IBOutlet UITextView *TOUTextView;
    IBOutlet UIScrollView *ScrollView;
    IBOutlet UIScrollView *BgScroll;
    
    IBOutlet UIView *FirstNameFg;
    IBOutlet UIView *LastNameBg;
    IBOutlet UIView *EmailBg;
    IBOutlet UIView *PasswordBg;
    IBOutlet UIImageView *TickBg;
    
    IBOutlet UIView *view_State;
    DropDownList *dropDownState;
    
    
}
- (IBAction)btnClicked_AddProfilePic:(id)sender;

- (IBAction)btnClicked_SignUp:(UIButton *)sender;

- (IBAction)btnClicked_TermAndConditions:(id)sender;
- (IBAction)btnClicked_AgreeTandC:(UIButton *)sender;
- (IBAction)TermsOfServices:(id)sender;
- (IBAction)PrivacyPolicy:(id)sender;
- (IBAction)CnclBtn:(id)sender;
- (IBAction)AgreeBtn1:(id)sender;



@end
