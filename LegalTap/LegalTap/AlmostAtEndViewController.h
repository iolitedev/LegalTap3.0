//
//  AlmostAtEndViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/13/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentNetworkHelper.h"
#import "SignInAndSignUpHelper.h"
#import "PayPalMobile.h"
#import "PamentHelper.h"
#import "Appointment.h"

@interface AlmostAtEndViewController : UIViewController<UIAlertViewDelegate,PayPalPaymentDelegate,UIPopoverControllerDelegate,QBRTCClientDelegate>
{
    IBOutlet UIView *view_FeeDetail;
    IBOutlet UIImageView *imageView_UserBGImage;
    IBOutlet UIImageView *imageView_UserImage;
    IBOutlet UIView *view_LegalPracticeList;
    IBOutlet UITextField *txt_Duration;
    IBOutlet UITextField *txt_Fee;
    IBOutlet UITextField *txt_CardNumber;
    NSMutableArray *LawyerListArray;
    NSUInteger randomIndex;
    NSString *OpponenntLawyerQBId;
    NSMutableArray *LawyerIdsArray;
    NSTimer *timer;
    UIView *BlackView;
    IBOutlet UILabel *lbl_SelectedLeagalTap;
    NSInteger RejectedCount;
    IBOutlet UIButton *LetsLegalTapBtn;
    int Balance;
    UILabel *Timelabel;
    NSTimer *CountDownTimer;
    int startTime;
    IBOutlet UILabel *legalLbl;
    IBOutlet UILabel *Fee;
    IBOutlet UILabel *Payment;
    IBOutlet UILabel *durationLabel;
    NSString *appointmentType;
    
}
- (IBAction)btnClicked_LetsLegalTap:(id)sender;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, assign, readwrite) BOOL goingCall;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;



- (IBAction)BackArrowBtn:(id)sender;
- (void)setAcceptCreditCards:(BOOL)processCreditCards;

@property (strong, nonatomic) NSString *strSelectedPractice;

@property (strong, nonatomic) NSDate *appointmentDate;;
@property (strong, nonatomic) Appointment *app;
@property (strong, nonatomic) NSString *identifierPreviousVC;
@property (strong, nonatomic) NSMutableArray *array_QuestionsList;
@property (strong, nonatomic) NSMutableArray *array_AnswersList;

@end
