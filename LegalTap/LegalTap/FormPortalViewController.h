//
//  FormPortalViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/16/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormListViewController.h"
#import "SignInAndSignUpHelper.h"
#import "PayPalMobile.h"
#import "AppointmentNetworkHelper.h"



@interface FormPortalViewController : UIViewController<UITextViewDelegate,FormListViewControllerDelegate,PayPalPaymentDelegate,UIPopoverControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView *view_SeletionArea;
    NSString *ComingFrom;

    
    IBOutlet UILabel *lbl_TextForm;
    IBOutlet UIView *view_DropDownList1;
    
    
    IBOutlet UILabel *lbl_TextClient;
    IBOutlet UIView *view_DropDownList2;
    
    IBOutlet UITextView *textView_Info;
    IBOutlet UILabel *lbl_PlaceholderTextView;
    
    IBOutlet UILabel *SelectAdminLabel;
    IBOutlet UIBarButtonItem *barButton_Home;
    NSString *type;
    IBOutlet UIView *showClientBtn;
    IBOutlet UILabel *selectClientLabel;
    IBOutlet UIButton *doneBtn;
    
    
    IBOutlet UIView *view_DropDownList3;
    IBOutlet UIView *textViewBgView;
    IBOutlet UIButton *nextBtn;
    IBOutlet UIScrollView *scrollView;
    NSString *UserId;
    NSString *FormId;
    IBOutlet UIPickerView *PickerView;
    IBOutlet UIImageView *selectClientRightArrow;
    IBOutlet UIImageView *TopImage;
    IBOutlet UILabel *legalPractice;
    IBOutlet UILabel *SelectClient;
    IBOutlet UILabel *ChooseForm;
    IBOutlet UILabel *FormDesc;
    NSString *PaymentMethod;
    NSString *FormOrignalPrice;
}
@property(nonatomic,retain) NSString *ComingFrom;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property (strong, nonatomic) NSMutableArray *array_List;



- (void)setAcceptCreditCards:(BOOL)processCreditCards;
- (IBAction)DonePickerButton:(id)sender;

- (IBAction)btnClickedSubmit:(id)sender;
- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender;

//Sliser Button Actions



@end
