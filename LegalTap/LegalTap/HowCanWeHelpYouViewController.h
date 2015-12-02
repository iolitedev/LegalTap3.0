//
//  HowCanWeHelpYouViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCWHYQuestion1.h"
#import "HCWHYQuestion2.h"
#import "HCWHYQuestion3.h"
#import "AlmostAtEndViewController.h"
#import "AppointmentNetworkHelper.h"


@interface HowCanWeHelpYouViewController : UIViewController
{
    IBOutlet UIView *view_QuestionArea;
    HCWHYQuestion1 *view_Question1;
    HCWHYQuestion2 *view_Question2;
    HCWHYQuestion3 *view_Question3;
    int questionNumber;
    
    IBOutlet UILabel *helpYouLbl;
    NSMutableArray *array_ViewQuestions;
}
@property (strong, nonatomic) NSDate *appointmentDate;;

- (IBAction)LinkButtonClicked:(id)sender;

- (IBAction)btnClicked_NextQuestion:(id)sender;
@property (strong, nonatomic) NSString *strSelectedPractice;


@property (strong, nonatomic) NSString *identifierPreviousVC;
@property (strong, nonatomic) NSMutableArray *array_QuestionsList;
@property (strong, nonatomic) NSMutableArray *array_AnswersList;
- (IBAction)BackBarButton:(id)sender;

@end
