//
//  AppointmentApprovalViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/16/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "AppointmentApprovalViewController.h"
#import "AppDelegate.h"

@interface AppointmentApprovalViewController ()
{
    BOOL isNavigationBarHidden;
}
@end

@implementation AppointmentApprovalViewController

- (void)viewDidLoad
{
    
  //  app.dateTime
    lblTimeOfAppointment.text = [self getAppointmentDateTextWithDate:_app.dateTime];
    lbl_ClientName.text=_app.lawyerName;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    @[@"5215",@"51454",@"2554",@"5215",@"51454",@"2554"]
    [self loadAnswersOnViewWithArray:_array_answersList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    isNavigationBarHidden = self.navigationController.navigationBarHidden;
//    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = isNavigationBarHidden;
}

-(NSString*)getAppointmentDateTextWithDate:(NSDate*)date
{
    NSString *strAppointText = @"";
    {
        NSDateFormatter *dateFormatter= [NSDateFormatter new];
        NSString *strStartTime;
        {
            dateFormatter.dateFormat = @"hh:mm a";
            strStartTime = [dateFormatter stringFromDate:date];
        }
        
        NSString *strEndTime;
        {
            strEndTime = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:15*60 sinceDate:date]];
        }
        
        NSString *strDate;
        {
            dateFormatter.dateFormat = @"EEEE MMMM dd";
            strDate = [dateFormatter stringFromDate:date];
            
            NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
            [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [monthDayFormatter setDateFormat:@"d"];
            
            int date_day = [[monthDayFormatter stringFromDate:date] intValue];
            NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
            NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
            NSString *suffix = [suffixes objectAtIndex:date_day];
            NewdateString = [strDate stringByAppendingString:suffix];
            
            NSDateFormatter *monthDayFormatter1 = [[NSDateFormatter alloc] init];
            [monthDayFormatter1 setFormatterBehavior:NSDateFormatterBehavior10_4];
            [monthDayFormatter1 setDateFormat:@"yyyy"];
            year = [[monthDayFormatter1 stringFromDate:_app.dateTime] intValue];
            
        }
        strAppointText = [NSString stringWithFormat:@"%@ and %@\non %@ %@ %d",strStartTime,strEndTime,NewdateString,@",",year];
    }
    return strAppointText;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadAnswersOnViewWithArray:(NSArray*)array
{
    CGFloat Y = 0;
    CGFloat Width = CGRectGetWidth(view_AnswerList.frame);

    for (UIView *view in view_AnswerList.subviews)
    {
        [view removeFromSuperview];
    }
    
    for (int i= 0; i < array.count; i++)
    {
        NSDictionary *dict = array[i];
        UILabel *lbl = [[UILabel alloc] init];
        {
            lbl.frame = CGRectMake(10, Y?Y+20:10, Width-20, 20);
            lbl.text = [NSString stringWithFormat:@"%@",dict[@"question"]];
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.numberOfLines = 0;
            [lbl sizeToFit];
            lbl.frame = CGRectMake(CGRectGetMinX(lbl.frame), CGRectGetMinY(lbl.frame), Width-20, CGRectGetHeight(lbl.frame));
        }
        [view_AnswerList addSubview:lbl];
        
        UILabel *lblAns = [[UILabel alloc] init];
        {
            lblAns.frame = CGRectMake(10, CGRectGetMaxY(lbl.frame), Width-20, 20);
            lblAns.text = [NSString stringWithFormat:@"%@",dict[@"answer"]];
            lblAns.textColor = [UIColor lightGrayColor];
            lblAns.font = [UIFont systemFontOfSize:13];
        }
        [view_AnswerList addSubview:lblAns];
        Y = CGRectGetMaxY(lblAns.frame);
    }
    if (!array.count)
    {
        Y = 50;
    }
    view_AnswerList.frame = CGRectMake(CGRectGetMinX(view_AnswerList.frame),
                                       CGRectGetMinY(view_AnswerList.frame),
                                       CGRectGetWidth(view_AnswerList.frame),
                                       Y+20);
    
    view_ScrollViewContent.frame = CGRectMake(CGRectGetMinX(view_ScrollViewContent.frame),
                                              CGRectGetMinY(view_ScrollViewContent.frame),
                                              CGRectGetWidth(view_ScrollViewContent.frame),
                                              264+CGRectGetHeight(view_AnswerList.frame));
    [view_ScrollViewContent layoutIfNeeded];
    scrollView_AnswersList.contentSize = CGSizeMake(CGRectGetWidth(scrollView_AnswersList.frame), CGRectGetHeight(view_ScrollViewContent.frame));
}

- (IBAction)btnClicked_Connect:(id)sender
{
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Connect with client" properties:@{
                                                    @"method": @"Connect with client",
                                                    }];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"accept" forKey:@"call"];


//    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
//
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.currentUser = 1;
//    
//    
//    // Your app connects to QuickBlox server here.
//    //
//    // Create extended session request with user authorization
//    //
//    QBSessionParameters *parameters = [QBSessionParameters new];
//    
//    if (user_Profile.quickBlox_UserName.length)
//    {
//        parameters.userLogin = user_Profile.quickBlox_UserName;
//        parameters.userPassword = user_Profile.quickBlox_UserName;
//    }
//    else
//    {
//        parameters.userLogin = appDelegate.testOpponents[0];
//        parameters.userPassword = appDelegate.testOpponents[1];
//
//    }
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    // QuickBlox session creation
//    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session)
//     {
//         [self loginToChat:session];
//         
//     } errorBlock:[self handleError]];
    
    
  //  
    // Show Main controller
    
  //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    MainViewController *MainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    {
        if (_app && _app.userQuickBloxId.length)
        {
            NSNumber *num = [NSNumber numberWithLongLong:_app.userQuickBloxId.longLongValue];
            MainVC.opponentID = num;
            NSString *userId=_app.userId;
            MainVC.UserIdFromAppointmentView=userId;
        }
        else
        {
           // MainVC.opponentID = appDelegate.currentUser == 1 ? appDelegate.testOpponents[5] : appDelegate.testOpponents[2];
        }
    }
    MainVC.ComingFromSide=@"Lawyer Side";

    
    [self.navigationController.tabBarController.navigationController pushViewController:MainVC animated:YES];

}

- (IBAction)btnClicked_Decline:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - QuickBlox
- (void(^)(QBResponse *))handleError
{
    return ^(QBResponse *response)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                        message:[response.error description]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", "")
                                              otherButtonTitles:nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    };
}

- (void)loginToChat:(QBASession *)session
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    [[QBChat instance] addDelegate:self];
    
    QBUUser *user = [QBUUser user];
    user.ID = session.userID;
    
    if (user_Profile.quickBlox_UserName.length)
    {
        user.password = user_Profile.quickBlox_UserName;
    }
    else
    {
        user.password = appDelegate.currentUser == 1 ? appDelegate.testOpponents[1] : appDelegate.testOpponents[4];
    }
    
    // Login to QuickBlox Chat
    //
    [[QBChat instance] loginWithUser:user];
}

#pragma mark QBChatDelegate

- (void)chatDidLogin
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    // Show Main controller
   // AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainViewController *MainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        
        if (_app && _app.userQuickBloxId.length)
        {
            NSNumber *num = [NSNumber numberWithLongLong:_app.userQuickBloxId.longLongValue];
            MainVC.opponentID = num;
        }
     
        else
        {
            MainVC.opponentID = appDelegate.currentUser == 1 ? appDelegate.testOpponents[5] : appDelegate.testOpponents[2];
        }
    }
    //    [self presentViewController:MainVC animated:YES completion:nil];
    MainVC.ComingFromSide=@"Lawyer Side";


    [self.navigationController.tabBarController.navigationController pushViewController:MainVC animated:YES];
}

- (void)chatDidNotLogin
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //Alert
}
@end
