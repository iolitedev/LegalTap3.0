//
//  UpdateAddressViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/12/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"
#import "DropDownList.h"

@interface UpdateAddressViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
{
    IBOutlet UIImageView *imageView_UserBGImage;
    IBOutlet UIImageView *imageView_UserImage;
    IBOutlet UITextField *txt_Name;
    IBOutlet UITextView *txt_Address;
    IBOutlet UITextField *txt_Street;
    IBOutlet UITextField *txt_MobileNumber;
    IBOutlet UIView *view_Address;
    IBOutlet UILabel *lbl_AddressPlaceHolder;
    IBOutlet UITextField *LastNameTextField;
    IBOutlet UILabel *FirstNameLabel;
    IBOutlet UILabel *LastNameText;
    IBOutlet UILabel *AddressText;
    IBOutlet UILabel *CityText;
    IBOutlet UILabel *StateText;
    IBOutlet UILabel *PhoneText;
    
    IBOutlet UIView *view_State;
    DropDownList *dropDownState;
    
    BOOL isUserImageUpdate;
    UIImage *userImage;
    __weak IBOutlet FXBlurView *blurView;
    
    
    __weak IBOutlet UIView *view_TextFields;
    __weak IBOutlet UIScrollView *scrollView_TextFields;
    
}
- (IBAction)btnClicked_SaveUpdate:(id)sender;
- (IBAction)btnClicked_Cancel:(id)sender;
- (IBAction)btnClicked_AddProfilePic:(id)sender;
- (IBAction)BackBarButton:(id)sender;


@end
