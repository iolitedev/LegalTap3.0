//
//  AppointmentWindowViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/9/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "AppointmentWindowViewController.h"

@interface AppointmentWindowViewController ()

@end

@implementation AppointmentWindowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNavigationHeader];
    lblTimeOfAppointment.text = [self getAppointmentDateTextWithDate:_appointmentDate];
    
    if (_isOnlyOpen)
    
    {
        //Client open for Show only
        if (_appointmentData)
        {
            lblHoldAlertForUser.text = @"";
//            for (NSDictionary *QA in _appointmentData.questionare)
//            {
//                lblHoldAlertForUser.text = [lblHoldAlertForUser.text stringByAppendingString:[NSString stringWithFormat:@"\n        %@\n        %@\n",QA[@"question"],QA[@"answer"]]];
//            }
////            lblHoldAlertForUser.text = [NSString stringWithFormat:@"%@",_appointmentData.questionare];
////            lblHoldAlertForUser.text = @"";
//            lblHoldAlertForUser.userInteractionEnabled = NO;
//            lblHoldAlertForUser.textAlignment = NSTextAlignmentLeft;
//            lblHoldAlertForUser.minimumScaleFactor = 0.6;
//            [lblHoldAlertForUser setAdjustsFontSizeToFitWidth:YES];
            
            lblHoldAlertForUser.hidden=YES;
            QueAnsView.hidden=NO;
            UIView*questionAnsView=[CommonHelper loadAnswersOnViewWithWindowArray:_appointmentData.questionare withWidth:self.view.frame.size.width];
            [QueAnsView addSubview:questionAnsView];
        }
    }
    else
    {
        //Client open for Appointment
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MyAppointmentToHome"])
    {
        HomeViewController *viewController = [segue destinationViewController];
        viewController.identifierPreviousVC = @"MyAppointmentToHome";
        viewController.title = @"fdsf";
        viewController.appointmentDate = _appointmentDate;
        //[self.storyboard instantiateViewControllerWithIdentifier:@"MyAppointmentToHome"];
        
    }
}

-(void)loadNavigationHeader
{
//    UIView *viewNavigationHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    {
//        viewNavigationHeader.backgroundColor = [UIColor clearColor];
//        UILabel *lblTitle = [[UILabel alloc] init];
//        {
//            lblTitle.frame = CGRectMake(0, 0, CGRectGetWidth(viewNavigationHeader.frame), CGRectGetHeight(viewNavigationHeader.frame) - 10);
//            lblTitle.text = self.navigationItem.title;
//            lblTitle.textColor = [UIColor whiteColor];
//            lblTitle.textAlignment = NSTextAlignmentCenter;
//        }
//        [viewNavigationHeader addSubview:lblTitle];
//        
//        viewHeaderLine = [[UIView alloc] init];
//        {
//            viewHeaderLine.frame = CGRectMake(0,  CGRectGetMaxY(lblTitle.frame),  CGRectGetWidth(viewNavigationHeader.frame), 2);
//            viewHeaderLine.backgroundColor = [UIColor whiteColor];
//            [self addLinePageWithView:viewHeaderLine andWithPageNo:2];
//        }
//        [viewNavigationHeader addSubview:viewHeaderLine];
//    }
//    self.navigationItem.titleView = viewNavigationHeader;
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
             year = [[monthDayFormatter1 stringFromDate:_appointmentDate] intValue];

        }
        strAppointText = [NSString stringWithFormat:@"%@ and %@\non %@%@ %d",strStartTime,strEndTime,NewdateString,@",",year];
    }
    return strAppointText;
}

//Page Number 0-2
-(void)addLinePageWithView:(UIView *)view andWithPageNo:(CGFloat)page
{
    for (UIView *subView in view.subviews)
    {
        [subView removeFromSuperview];
    }
    CGFloat width = CGRectGetWidth(view.frame)/3;
    UILabel *lblBlueLine = [[UILabel alloc] init];
    {
        lblBlueLine.backgroundColor = defColor_LightMagenta;
        lblBlueLine.frame = CGRectMake(width*page, 0, width, CGRectGetHeight(view.frame));
    }
    [view addSubview:lblBlueLine];
}

- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
//    [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
}

- (IBAction)btnClicked_Continue:(UIButton *)sender
{
    if (_isOnlyOpen)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self performSegueWithIdentifier:@"MyAppointmentToHome" sender:self];

    }

//    [self.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}
@end
