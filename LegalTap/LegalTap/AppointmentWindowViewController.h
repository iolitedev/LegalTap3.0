//
//  AppointmentWindowViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/9/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "Appointment.h"

@interface AppointmentWindowViewController : UIViewController
{
    UIView *viewHeaderLine;
    IBOutlet UILabel *lblTimeOfAppointment;
    __weak IBOutlet UILabel *lblHoldAlertForUser;
    int year;
    NSString *NewdateString;
    IBOutlet UIView *QueAnsView;
}
- (IBAction)btnClicked_Continue:(UIButton *)sender;

@property (strong, nonatomic) Appointment *appointmentData;

@property (strong, nonatomic) NSDate *appointmentDate;
@property (nonatomic) BOOL isOnlyOpen;


@end
