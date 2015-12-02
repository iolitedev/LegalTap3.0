//
//  AppointmentApprovalViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/16/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Appointment.h"


@interface AppointmentApprovalViewController : UIViewController<QBActionStatusDelegate, QBChatDelegate>
{
    IBOutlet UILabel *lbl_ClientReadyInTime;
    IBOutlet UILabel *lbl_ClientName;
    IBOutlet UILabel *lbl_SelectedLegalPractice;
    
    IBOutlet UIScrollView *scrollView_AnswersList;
    IBOutlet UIView *view_ScrollViewContent;
    IBOutlet UIView *view_AnswerList;
    IBOutlet UILabel *lblTimeOfAppointment;
    int year;
    NSString *NewdateString;


}
- (IBAction)btnClicked_Connect:(id)sender;
- (IBAction)btnClicked_Decline:(id)sender;
@property (strong, nonatomic) NSArray *array_answersList;


//Video
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *testOpponents;
@property (strong, nonatomic) Appointment *app;

/* Current logged in test user*/
@property (assign, nonatomic) int currentUser;

@end
