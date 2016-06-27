//
//  FeedbackToLawyerViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/16/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"
#import "HomeViewController.h"


@interface FeedbackToLawyerViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UILabel *lbl_Heading;
    IBOutlet UILabel *lbl_CompletedCall;
    IBOutlet UILabel *lbl_CallDate;
    IBOutlet UILabel *lbl_CallTime;
    
    IBOutlet UILabel *lbl_LawyerName;
    
    //Stars
    IBOutlet UIButton *btn_Star1;
    IBOutlet UIButton *btn_Star2;
    IBOutlet UIButton *btn_Star3;
    IBOutlet UIButton *btn_Star4;
    IBOutlet UIButton *btn_Star5;
    
    
    //TextView
    IBOutlet UILabel *lbl_PlaceholderTextView;
    IBOutlet UITextView *textView_Info;
    __weak IBOutlet FXBlurView *blurView;
    NSString *RatingValue;
    NSString *LawyerQuickBloxId;
    NSString *LawyerId;
    IBOutlet UIView *DescBg;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,retain)NSString *LawyerQuickBloxId;
@property (strong, nonatomic) IBOutlet UIButton *favLawyer;
@property (strong, nonatomic) NSMutableArray *arrayList;


- (IBAction)SubmitButton:(id)sender;
- (IBAction)btnClicked_RateLawyer:(UIButton *)sender;
- (IBAction)btnClickedFev:(UIButton *)sender;
@end
