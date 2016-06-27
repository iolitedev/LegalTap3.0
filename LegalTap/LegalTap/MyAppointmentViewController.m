
//
//  MyAppointmentViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/9/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "MyAppointmentViewController.h"
#import "CalenderView.h"
//#import "Settings.h"


@interface MyAppointmentViewController ()

@property (copy, nonatomic) void(^chatConnectCompletionBlock)(BOOL error);
@property (copy, nonatomic) dispatch_block_t chatDisconnectedBlock;
@property (copy, nonatomic) dispatch_block_t chatReconnectedBlock;
@property (strong, nonatomic) QBRTCTimer *presenceTimer;
//@property (strong, nonatomic) Settings *settings;
@end

@implementation MyAppointmentViewController

@synthesize LawyerIdFromSettings;
- (void)viewDidLoad
{
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"My Appointments" properties:@{
                                                   @"method": @"My Appointments",
                                                   }];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userType = [SharedSingleton sharedClient].user_Profile.userType;
    
    if ([userType isEqualToString:@"lawyer"])
    {
        //blueImage
        view_PageControl.hidden=YES;
        topViewOutlet.hidden=YES;
        
        if (IS_IPHONE_5)
        {
          //  UIImage *BlueBackground = [UIImage imageNamed:@"blueImage1"];
            //[[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
            self.tabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"blueImage4"];
        }
       
        else if (IS_IPHONE_6P)
        {
            self.tabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"blueImage5"];
            
        }
        else
        {
//            UIImage *BlueBackground = [UIImage imageNamed:@"BlueBackground"];
//            [[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
            self.tabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"blueImage5"];

        }
//        collectionView_List.frame=CGRectMake(collectionView_List.frame.origin.x,collectionView_List.frame.origin.y-10,collectionView_List.frame.size.width,collectionView_List.frame.size.height+50);
//        view_PlaceForCalenderandList.frame=CGRectMake(view_PlaceForCalenderandList.frame.origin.x, 0,view_PlaceForCalenderandList.frame.size.width,CGRectGetHeight(self.view.fr));
//        [view_PlaceForCalenderandList layoutIfNeeded];

        self.title = @"Booked Appointments";
        view_List.hidden = NO;
        view_Calender.hidden = YES;
        view_PageControl.hidden = YES;
        
        view_PlaceForCalenderandList.frame = CGRectMake(CGRectGetMinX(view_PlaceForCalenderandList.frame),
                                                        70,
                                                        CGRectGetWidth(view_PlaceForCalenderandList.frame),
                                                        CGRectGetHeight(self.view.frame) - 70 -44);
        [view_PlaceForCalenderandList layoutIfNeeded];
        
        [collectionView_List registerClass:[MyAppointmentCollectionViewCell class] forCellWithReuseIdentifier:@"MyAppointmentCollectionViewCell"];
        UINib *cellNib = [UINib nibWithNibName:@"MyAppointmentCollectionViewCell" bundle:nil];
        [collectionView_List registerNib:cellNib forCellWithReuseIdentifier:@"MyAppointmentCollectionViewCell"];
//        {
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            dateFormatter.dateFormat = @"dd/MM/yyyy";
//            
//            NSDate *todayDate = [NSDate date];
//            NSDate *dateForList = [NSDate dateWithTimeInterval:4*60*60 sinceDate:[NSDate date]];
//            NSString *strToDay = [dateFormatter stringFromDate:todayDate];
//            NSString *strSelDay = [dateFormatter stringFromDate:dateForList];
//            
//            if (![strToDay isEqualToString:strSelDay])
//            {
//                dateForList = nil;
//            }
//            NSMutableArray *array_calenderList = [[NSMutableArray alloc] initWithArray:[self getStartDateAndEndDate:dateForList]];
//            [self reloadAppointmentsListWithArray:array_calenderList];
//        }
        [self videoCalling];
        
    }
    else
    {
        UIView *statusBarView;
        if (IS_IPHONE_6)
        {
            view_Calender.frame = CGRectMake(CGRectGetMinX(view_Calender.frame),
                                             CGRectGetMinY(view_Calender.frame),
                                             CGRectGetWidth(view_Calender.frame),
                                             CGRectGetHeight(CalendarScrellView.frame));
            [view_Calender layoutIfNeeded];
            
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 380, 22)];
            
        }
        else if (IS_IPHONE_6P)
        {
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 420, 22)];
            
        }

        else
        {
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 22)];
            
        }
        
        statusBarView.backgroundColor = [UIColor colorWithRed:70/255.0f green:130/255.0f blue:180/255.0f alpha:1.0f];
        [self.navigationController.navigationBar addSubview:statusBarView];
        
        
        UIImage *navBarImg = [UIImage imageNamed:@"Navigation_bg"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:3/255.0f green:136/255.0f blue:201/255.0f alpha:1.0];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

        
        if (IS_IPHONE_4_OR_LESS)
        {
            
            CalendarScrellView.contentSize = CGSizeMake(300, 380);
   
        }
        else if (IS_IPHONE_6)
        {
            CalendarScrellView.contentSize = CGSizeMake(CGRectGetWidth(calenderView.frame),
                                                        CGRectGetHeight(calenderView.frame));

            view_PageControl.frame=CGRectMake(view_PageControl.frame.origin.x, 80, view_PageControl.frame.size.width, view_PageControl.frame.size.height);
            view_PlaceForCalenderandList.frame=CGRectMake(view_PlaceForCalenderandList.frame.origin.x, 145, view_PlaceForCalenderandList.frame.size.width, view_PlaceForCalenderandList.frame.size.height - 35);
            
            view_Calender.frame = CGRectMake(CGRectGetMinX(view_Calender.frame),
                                             CGRectGetMinY(view_Calender.frame),
                                             CGRectGetWidth(view_Calender.frame),
                                             CGRectGetHeight(CalendarScrellView.frame));
            [view_Calender layoutIfNeeded];

        }
        else if (IS_IPHONE_6P)
        {
            view_PageControl.frame=CGRectMake(view_PageControl.frame.origin.x, 80, view_PageControl.frame.size.width, view_PageControl.frame.size.height);
            view_PlaceForCalenderandList.frame=CGRectMake(view_PlaceForCalenderandList.frame.origin.x,
                                                          145,
                                                          view_PlaceForCalenderandList.frame.size.width,
                                                          view_PlaceForCalenderandList.frame.size.height);
            
//            view_Calender.frame = CGRectMake(CGRectGetMinX(view_Calender.frame),
//                                             CGRectGetMinY(view_Calender.frame),
//                                             CGRectGetWidth(view_Calender.frame),
//                                             CGRectGetHeight(CalendarScrellView.frame));
//            
////            CalendarScrellView.frame
//            [view_Calender layoutIfNeeded];
            
//            view_List.frame = CGRectMake(CGRectGetMinX(view_List.frame),
//                                         CGRectGetMinY(view_List.frame)- 50,
//                                         CGRectGetWidth(view_List.frame),
//                                         CGRectGetHeight(view_List.frame) +50);
            [view_PlaceForCalenderandList layoutIfNeeded];

            
        }
        
        [self loadCalenderView];
        [self loadNavigationHeader];
        
        [collectionView_Calender registerClass:[MyAppointmentCollectionViewCell class] forCellWithReuseIdentifier:@"MyAppointmentCollectionViewCell"];
        
        [collectionView_List registerClass:[MyAppointmentCollectionViewCell class] forCellWithReuseIdentifier:@"MyAppointmentCollectionViewCell"];
        
        UINib *cellNib = [UINib nibWithNibName:@"MyAppointmentCollectionViewCell" bundle:nil];
        [collectionView_Calender registerNib:cellNib forCellWithReuseIdentifier:@"MyAppointmentCollectionViewCell"];
        [collectionView_List registerNib:cellNib forCellWithReuseIdentifier:@"MyAppointmentCollectionViewCell"];
        
        
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd/MM/yyyy";
            
            NSDate *todayDate = [NSDate date];
            NSDate *dateForList = [NSDate dateWithTimeInterval:4*60*60 sinceDate:[NSDate date]];
            NSString *strToDay = [dateFormatter stringFromDate:todayDate];
            NSString *strSelDay = [dateFormatter stringFromDate:dateForList];
            
            if (![strToDay isEqualToString:strSelDay])
            {
                dateForList = nil;
            }
            NSMutableArray *array_calenderList = [[NSMutableArray alloc] initWithArray:[self getStartDateAndEndDate:dateForList]];
//            [self reloadAppointmentsListWithArray:array_calenderList];
            array_Calender = [[NSMutableArray alloc] initWithArray:array_calenderList];
        }
        
        [collectionView_Calender reloadData];
        [collectionView_List reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [[NSUserDefaults standardUserDefaults] setValue:LawyerIdFromSettings forKey:@"FavoriteLawyerId"];
    [super viewWillAppear:animated];
        [self getAppointments];
    if ([userType isEqualToString:@"lawyer"])
    {
        self.navigationController.navigationBarHidden = NO;
    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CalendarTab"] isEqualToString:@"LetsLegalTap"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CalendarTab"];
            if (pageControl_Calender.selectedSegmentIndex == 1)
            {
                pageControl_Calender.selectedSegmentIndex = 0;
                [self pageControl_ChangeType:pageControl_Calender];
            }
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CalendarTab"] isEqualToString:@"ConformAppointment"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CalendarTab"];
            
            if (pageControl_Calender.selectedSegmentIndex == 0)
            {
                pageControl_Calender.selectedSegmentIndex = 1;
                [self pageControl_ChangeType:pageControl_Calender];
            }


        }
        
//        view_PageControl.backgroundColor = [UIColor clearColor];
//        [self addLinePageWithView:viewHeaderLine andWithPageNo:0];
//        view_List.hidden = !view_List.hidden;
//        view_Calender.hidden = !view_Calender.hidden;
//        
//        [collectionView_Calender reloadData];
//        [collectionView_List reloadData];

    }
}

-(void)getAppointments
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;

    NSString *strUserId = user_Profile.userId;
    NSString *strUserType = user_Profile.userType;
    
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AppointmentNetworkHelper getAppointmentWithUserid:strUserId
                                          withUserType:strUserType
                                andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 NSArray *arrAppointmetsData = [responseObject valueForKey:@"appointment"];
                 NSMutableArray *arrAppointmentsObjectes = [NSMutableArray array];
                 if (arrAppointmetsData)
                 {
                     NSMutableArray *array_calenderList = [NSMutableArray array];
                     for (NSDictionary *dict in arrAppointmetsData)
                     {
                         Appointment *ap = [[Appointment alloc] initWithDictionary:dict];
                         user_Profile.appointmentId = ap.appointmentId;
                         if ([ap.callStatus  isEqual: @""])
                         {
                             [arrAppointmentsObjectes addObject:ap];
                             [array_calenderList addObject:ap.dateTime];
                         }
                     }
                     [self reloadAppointmentsListWithArray:arrAppointmentsObjectes];
                 }
             }
             else
             {
//                 NSMutableArray *array_calenderList = [[NSMutableArray alloc] initWithArray:[self getStartDateAndEndDate:[NSDate dateWithTimeInterval:4*60*60 sinceDate:[NSDate date]]]];//temp data
                 [self reloadAppointmentsListWithArray:nil];
             }
         }
         else
         {
             [self reloadAppointmentsListWithArray:nil];
         }
     }];
}

-(void)reloadAppointmentsListWithArray:(NSArray*)array
{
    NSMutableArray *array_calenderList;// = [[NSMutableArray alloc] initWithArray:[self getStartDateAndEndDate:[NSDate dateWithTimeInterval:4*60*60 sinceDate:[NSDate date]]]];
//    if (array)
    {
        array_calenderList = [[NSMutableArray alloc] initWithArray:array];
    }
    array_List = [[NSMutableArray alloc] initWithArray:array_calenderList];
    [collectionView_List reloadData];
}

- (void)didReceiveMemoryWarning
{
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
//            
//            lblTitle.text = self.navigationItem.title;
//            lblTitle.textColor = [UIColor whiteColor];
//            lblTitle.textAlignment = NSTextAlignmentCenter;
//        }
//        [viewNavigationHeader addSubview:lblTitle];
//        
////        viewHeaderLine = [[UIView alloc] init];
////        {
////            viewHeaderLine.frame = CGRectMake(0,  CGRectGetMaxY(lblTitle.frame),  CGRectGetWidth(viewNavigationHeader.frame), 2);
////            viewHeaderLine.backgroundColor = [UIColor whiteColor];
////            [self addLinePageWithView:viewHeaderLine andWithPageNo:0];
////        }
////        [viewNavigationHeader addSubview:viewHeaderLine];
//    }
//    self.navigationItem.title = viewNavigationHeader;
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

-(void)loadCalenderView
{
    if (!calenderView)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CalenderView class]) owner:self options:nil];
        calenderView = [arr firstObject];
        {
            calenderView.frame = view_Calender.bounds;
            calenderView.delegate = self;
            calenderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Calendar_Bg"]];

            
            if (IS_IPHONE_6P)
            {
                collectionView_Calender.frame = CGRectMake(CGRectGetMinX(collectionView_Calender.frame),
                                                           CGRectGetMinY(collectionView_Calender.frame) - 80,
                                                           CGRectGetWidth(collectionView_Calender.frame),
                                                           CGRectGetHeight(collectionView_Calender.frame) + 50);
            }
            else if (IS_IPHONE_4_OR_LESS)
            {
                collectionView_Calender.frame = CGRectMake(CGRectGetMinX(collectionView_Calender.frame),
                                                           CGRectGetMinY(collectionView_Calender.frame) + 40,
                                                           CGRectGetWidth(collectionView_Calender.frame),
                                                           CGRectGetHeight(collectionView_Calender.frame));

            }
            
            
//            UIView *view = calenderView;//[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.frame = view.bounds;
//            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blueColor] CGColor], (id)[[UIColor greenColor] CGColor], nil];
//            [view.layer insertSublayer:gradient atIndex:0];
            
            
            NSMutableArray *arrayList = [[NSMutableArray alloc] init];
            for (int i = 0; i < 21; i++)
            {
                NSDate *date = [NSDate dateWithTimeInterval:86400*i sinceDate:[NSDate date]];
                [arrayList addObject:date];
            }
            [calenderView setCalenderWithDateReminderArray:arrayList];
        }
        [view_Calender addSubview:calenderView];
        [view_Calender bringSubviewToFront:collectionView_Calender];
        [calenderView layoutIfNeeded];
    }
}

-(void)CalenderView:(CalenderView *)CalenderView didSelectDate:(NSDate *)selDate
{
    NSLog(@"%@",selDate);
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    
    NSString *strTodateDate = [dateFormatter stringFromDate:todayDate];
    dateFormatter.dateFormat = @"dd/MM/yyyy hh:mm:ss";
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    strTodateDate = [strTodateDate stringByAppendingString:@" 00:00:00"];
    todayDate = [dateFormatter dateFromString:strTodateDate];
    
    NSDate *_7thDay = [NSDate dateWithTimeInterval:86400*21 sinceDate:todayDate];
    if ((([todayDate compare:selDate] == NSOrderedAscending) || ([todayDate compare:selDate] == NSOrderedSame))
        && ([_7thDay compare:selDate] == NSOrderedDescending))
    {
        NSLog(@"Selected  - %@",selDate);
        NSDate *dateForList;
        
        dateFormatter.dateFormat = @"dd/MM/yyyy";

        if ([[dateFormatter stringFromDate:selDate] isEqualToString:[dateFormatter stringFromDate:todayDate]])
        {
            dateForList = [NSDate dateWithTimeInterval:4*60*60 sinceDate:[NSDate date]];
            
            NSString *strToDay = [dateFormatter stringFromDate:todayDate];
            NSString *strSelDay = [dateFormatter stringFromDate:dateForList];
            if (![strToDay isEqualToString:strSelDay])
            {
                dateForList = nil;
            }
        }
        else
        {
            dateForList = selDate;
        }
        
        NSMutableArray *array_calenderList = [[NSMutableArray alloc] initWithArray:[self getStartDateAndEndDate:dateForList]];
        array_Calender = [[NSMutableArray alloc] initWithArray:array_calenderList];
        [collectionView_Calender reloadData];
        if (array_Calender.count)
        {
            [collectionView_Calender scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
        }
    }
    else
    {
        NSLog(@"Not Selected - %@",selDate);
        array_Calender = [[NSMutableArray alloc] initWithArray:@[]];
        [collectionView_Calender reloadData];
    }
}

-(NSArray*)getStartDateAndEndDate:(NSDate*)date
{
    if (!date)
    {
        return @[];
    }
    NSDate *ds = [self roundOffDate:date];
    
    if ([self dateExistInInterval:ds])
    {
        NSDate *stD = ds;
        NSDate *enD = [self endDateByDate:ds];
        NSArray *arrat = [self getArrayOfTimeListWithStartDate:stD withEndDate:enD];
        return arrat;
    }
    return nil;
}

-(NSDate*)endDateByDate:(NSDate*)date
{
    NSDate *endDate;
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        
        NSString *strDate = [dateFormatter stringFromDate:date];
        strDate = [strDate  stringByAppendingString:@" 09:30:00 PM"];
        dateFormatter.dateFormat = @"dd/MM/yyyy hh:mm:ss a";
        
        endDate = [dateFormatter dateFromString:strDate];
    }
    return endDate;
}

-(NSDate*)roundOffDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd/MM/yyyy z";

    NSString *strDate930 = [dateFormatter stringFromDate:date];
    dateFormatter.dateFormat = @"dd/MM/yyyy z HH:mm:ss";
    strDate930 = [strDate930 stringByAppendingString:@" 6:00:00"];
    
    
    NSDate *date930 = [dateFormatter dateFromString:strDate930];
    if (([date compare:date930] == NSOrderedAscending)
        || ([date compare:date930] == NSOrderedSame))
    {
        return date930;
    }
    else
    {
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        
        NSString *strDate = [dateFormatter stringFromDate:date];
        strDate = [strDate  stringByAppendingString:@" 00:00:00"];
        dateFormatter.dateFormat = @"dd/MM/yyyy hh:mm:ss";
        
        NSDate *temStDate = [dateFormatter dateFromString:strDate];
        NSTimeInterval timInt = [date timeIntervalSinceDate:temStDate];
        
        
        NSInteger timDiff = ((15*60) - ((NSInteger)timInt)%(15*60));
        
        NSDate *sDate = [NSDate dateWithTimeInterval:timDiff sinceDate:date];
        return sDate;
    }
}

-(BOOL)dateExistInInterval:(NSDate*)date
{
//    NSString *strStartTime = @"9:30 AM";
    NSString *strEndTime = @"9:30 PM";
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    
//    strStartTime = [@" "  stringByAppendingString:strStartTime];
    strEndTime = [@" "  stringByAppendingString:strEndTime];

    
//    strStartTime = [strDate stringByAppendingString:strStartTime];
    strEndTime = [strDate stringByAppendingString:strEndTime];
    
    dateFormatter.dateFormat = @"dd/MM/yyyy hh:mm a";

//    NSDate *dateStartDate = [dateFormatter dateFromString:strStartTime];
    NSDate *dateEndDate = [dateFormatter dateFromString:strEndTime];

//    if ((([dateStartDate compare:date] == NSOrderedAscending) || ([dateStartDate compare:date] == NSOrderedSame))
//        && ([dateEndDate compare:date] == NSOrderedDescending))
    if ([dateEndDate compare:date] == NSOrderedDescending)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSArray*)getArrayOfTimeListWithStartDate:(NSDate*)startDate  //9:30AM
                           withEndDate:(NSDate*)endDate    //9:30PM
{
    NSMutableArray *arrayOfDates = [NSMutableArray array];
    {
        NSTimeInterval interval = 15*60; //15 Min
        NSTimeInterval limit = [endDate timeIntervalSinceDate:startDate];
        
        for (NSTimeInterval i = 0; i < limit; i = i + interval)
        {
            NSDate *dateWithInternal = [NSDate dateWithTimeInterval:i sinceDate:startDate];
            [arrayOfDates addObject:dateWithInternal];
        }
    }
    return arrayOfDates;
}

#pragma mark - Collection View Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == collectionView_Calender)
    {
         
        return [self collectionView_Calender:collectionView numberOfItemsInSection:section];
    }
    else if (collectionView == collectionView_List)
    {
        return [self collectionView_List:collectionView numberOfItemsInSection:section];
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == collectionView_Calender)
    {
        return [self collectionView_Calender:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    else if (collectionView == collectionView_List)
    {
        return [self collectionView_List:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeMake(320, 100);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == collectionView_Calender)
    {
        return [self collectionView_Calender:collectionView cellForItemAtIndexPath:indexPath];
    }
    else if (collectionView == collectionView_List)
    {
        return [self collectionView_List:collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == collectionView_Calender)
    {
        [self collectionView_Calender:collectionView didSelectItemAtIndexPath:indexPath];
    }
    else if (collectionView == collectionView_List)
    {
        [self collectionView_List:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - Collection View Calender Delegates
-(NSInteger)collectionView_Calender:(UICollectionView *)collectionView
             numberOfItemsInSection:(NSInteger)section
{
    if (view_Calender.hidden)
    {
        return 0;
    }
    if (lblEmpty_Calender)
    {
        [lblEmpty_Calender removeFromSuperview];
        lblEmpty_Calender = nil;
    }
    if (!array_Calender.count)
    {
        
        lblEmpty_Calender = [[UILabel alloc] initWithFrame:collectionView.bounds];
        {
            lblEmpty_Calender.text = @"No Appointments are available for selected Date";
            lblEmpty_Calender.textColor = [UIColor lightGrayColor];
            lblEmpty_Calender.textAlignment = NSTextAlignmentCenter;
            lblEmpty_Calender.numberOfLines = 0;
        }
        [collectionView addSubview:lblEmpty_Calender];
    }
    return array_Calender.count;
}

- (CGSize)collectionView_Calender:(UICollectionView *)collectionView
                           layout:(UICollectionViewLayout*)collectionViewLayout
           sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6)
    {
        return CGSizeMake(370, 40);
  
    }
    else if (IS_IPHONE_6P)
    {
        return CGSizeMake(370, 40);
 
    }
    else
    {
        return CGSizeMake(320, 40);
    }

}

-(UICollectionViewCell *)collectionView_Calender:(UICollectionView *)collectionView
                          cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MyAppointmentCollectionViewCell";
    MyAppointmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyAppointmentCollectionViewCell class]) owner:self options:nil];
        cell= [array firstObject];
    }
    cell.cellType = MyAppointmentCollectionViewCellCalenderType;
    [cell layoutIfNeeded];

    [cell setViewLayoutByType];

    cell.date = [array_Calender objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)collectionView_Calender:(UICollectionView *)collectionView
      didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    AppointmentWindowViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentWindow"];
    
    NSDate *dateAppointment  = [array_Calender objectAtIndex:indexPath.row];
    viewController.appointmentDate = dateAppointment;
    viewController.isOnlyOpen = NO;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Collection View List Delegates
-(NSInteger)collectionView_List:(UICollectionView *)collectionView
             numberOfItemsInSection:(NSInteger)section
{
    if (view_List.hidden)
    {
        return 0;
    }
    if (lblEmpty_List)
    {
        [lblEmpty_List removeFromSuperview];
        lblEmpty_List = nil;
    }
    if (!array_List.count)
    {
        
        lblEmpty_List = [[UILabel alloc] initWithFrame:collectionView.bounds];
        {
            lblEmpty_List.text = @"Not any Previous Appointments";
            lblEmpty_List.textColor = [UIColor lightGrayColor];
            lblEmpty_List.textAlignment = NSTextAlignmentCenter;
            lblEmpty_List.numberOfLines = 0;

        }
        [collectionView addSubview:lblEmpty_List];
    }
    return array_List.count;
}

- (CGSize)collectionView_List:(UICollectionView *)collectionView
                           layout:(UICollectionViewLayout*)collectionViewLayout
           sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([userType isEqualToString:@"lawyer"])
    {
        return CGSizeMake(def_DeviceWidth-20, 100);
  
    }
    else
    {
        return CGSizeMake(def_DeviceWidth-20, 100);

    }
}

-(UICollectionViewCell *)collectionView_List:(UICollectionView *)collectionView
                          cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MyAppointmentCollectionViewCell";
    MyAppointmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyAppointmentCollectionViewCell" owner:self options:nil];
        cell= [array firstObject];
    }
    cell.cellType = MyAppointmentCollectionViewCellListType;
    [cell layoutIfNeeded];
    [cell setViewLayoutByType];
    cell.userType = userType;
    
    
    NSDate *date;
    if ([[array_List objectAtIndex:indexPath.row] isKindOfClass:[Appointment class]])
    {
        Appointment *app = [array_List objectAtIndex:indexPath.row];
        date = app.dateTime;
        cell.clientAppointment = app;
    }
    else
    {
        date = [array_List objectAtIndex:indexPath.row];
    }
    cell.date = date;

    return cell;
}

-(void)collectionView_List:(UICollectionView *)collectionView
      didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    NSDate *date;
    Appointment *app;
    if ([[array_List objectAtIndex:indexPath.row] isKindOfClass:[Appointment class]])
    {
        app = [array_List objectAtIndex:indexPath.row];
        date = app.dateTime;
        NSString *str = app.appointmentId;
           }
    else
    {
        date = [array_List objectAtIndex:indexPath.row];
    }
    
    if ([userType isEqualToString:@"lawyer"])
    {
        //AppointmentApproval
        AppointmentApprovalViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentApproval"];
        if (app)
        {
            viewController.array_answersList = app.questionare;
            viewController.app = app;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        AppointmentWindowViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentWindow"];
        viewController.isOnlyOpen = YES;
        viewController.appointmentDate = date;
        if (app)
        {
            viewController.appointmentData = app;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView == collectionView_Calender)
    {
        //get refrence of vertical indicator
        UIImageView *verticalIndicator = ((UIImageView *)[scrollView.subviews objectAtIndex:(scrollView.subviews.count-1)]);
        //set color to vertical indicator
        [verticalIndicator setBackgroundColor:[UIColor redColor]];
        
//        //get refrence of horizontal indicator
//        UIImageView *horizontalIndicator = ((UIImageView *)[scrollView.subviews objectAtIndex:(scrollView.subviews.count-2)]);
//        //set color to horizontal indicator
//        [horizontalIndicator setBackgroundColor:[UIColor blueColor]];
    }
}

//CollectionView Cell draging Width + Space
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
//                     withVelocity:(CGPoint)velocity
//              targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    if (scrollView == collectionView_Calender)
//    {
//        float pageWidth = 200 + 10;
//        float currentOffset = scrollView.contentOffset.x;
//        float targetOffset = targetContentOffset->x;
//        float newTargetOffset = 0;
//        
//        if (targetOffset > currentOffset)
//            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
//        else
//            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
//        
//        if (newTargetOffset < 0)
//            newTargetOffset = 0;
//        else if (newTargetOffset > scrollView.contentSize.width)
//            newTargetOffset = scrollView.contentSize.width;
//        
//        targetContentOffset->x = currentOffset;
//        [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:NO];
//    }
//}

#pragma mark - Actions
- (IBAction)pageControl_ChangeType:(id)sender
{
    if (![view_PageControl.backgroundColor isEqual:self.view.backgroundColor])
    {
        view_PageControl.backgroundColor = self.view.backgroundColor;
        [self addLinePageWithView:viewHeaderLine andWithPageNo:1];
    }
    else
    {
        view_PageControl.backgroundColor = [UIColor clearColor];
        [self addLinePageWithView:viewHeaderLine andWithPageNo:0];

    }
    view_List.hidden = !view_List.hidden;
    view_Calender.hidden = !view_Calender.hidden;
    
    [collectionView_Calender reloadData];
    [collectionView_List reloadData];
}

- (IBAction)navigationBar_Clicked_Home:(id)sender
{
   // [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
}

#pragma mark - Video calling

-(void)videoCalling
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    
    NSString *qUserName;
    NSString *qPassword;
    if (user_Profile.quickBlox_UserName.length){
        qUserName = user_Profile.quickBlox_UserName;
        qPassword = user_Profile.quickBlox_UserName;
    }else{
        qUserName = @"ritesharora";
        qPassword = @"ritesharora";
    }
    
    
    
        // Set QuickBlox Chat delegate
    [[QBChat instance] addDelegate:self];
    QBUUser *user = [QBUUser user];
    user.fullName = qUserName;
    user.login = qUserName;
    user.ID =  user_Profile.quickBlox_Id.intValue;
    user.password = qPassword;

    
    [self logInWithUser:user completion:^(BOOL error) {
        NSLog(@"connect");

        if (!error) {
            
         //   [weakSelf applyConfiguration];
//            [weakSelf performSegueWithIdentifier:kSettingsCallSegueIdentifier sender:nil];
        }
        else {
            NSLog(@"error");

           // [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Login chat error!", nil)];
        }
    } disconnectedBlock:^{
        NSLog(@"Disconnect");
    } reconnectedBlock:^{
//        [weakSelf applyConfiguration];

        NSLog(@"Reconnect");
    }];
    

   // [self createSeesionForClientwithUserName:qUserName withUserPassword:qPassword];
    
}
//- (void)applyConfiguration {
//    
//    NSMutableArray *iceServers = [NSMutableArray array];
//    
//    for (NSString *url in self.settings.stunServers) {
//        
//        QBRTCICEServer *server = [QBRTCICEServer serverWithURL:url username:@"" password:@""];
//        [iceServers addObject:server];
//    }
//    
//    [iceServers addObjectsFromArray:[self quickbloxICE]];
//    
//    [QBRTCConfig setICEServers:iceServers];
//    [QBRTCConfig setMediaStreamConfiguration:self.settings.mediaConfiguration];
//    [QBRTCConfig setStatsReportTimeInterval:1.f];
//}
//- (NSArray *)quickbloxICE {
//    
//    NSString *password = @"baccb97ba2d92d71e26eb9886da5f1e0";
//    NSString *userName = @"quickblox";
//    
//    QBRTCICEServer * stunServer = [QBRTCICEServer serverWithURL:@"stun:turn.quickblox.com"
//                                                       username:@""
//                                                       password:@""];
//    
//    QBRTCICEServer * turnUDPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=udp"
//                                                          username:userName
//                                                          password:password];
//    
//    QBRTCICEServer * turnTCPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=tcp"
//                                                          username:userName
//                                                          password:password];
//    
//    
//    return@[stunServer, turnTCPServer, turnUDPServer];
//}
//

- (void)logInWithUser:(QBUUser *)user completion:(void (^)(BOOL error))completion  disconnectedBlock:(dispatch_block_t)disconnectedBlock reconnectedBlock:(dispatch_block_t)reconnectedBlock{
    
    [QBChat.instance addDelegate:self];
    if (QBChat.instance.isConnected) {
        completion(NO);
        return;
    }
    
    self.chatConnectCompletionBlock = completion;
    self.chatDisconnectedBlock = disconnectedBlock;
    self.chatReconnectedBlock = reconnectedBlock;
    [QBChat.instance connectWithUser:user completion:^(NSError * _Nullable error) {
    // NSLog(@"error");
        
    }];
}

//
//
//-(void)createSeesionForClientwithUserName:(NSString*)userName withUserPassword:(NSString*)password
//{
//    // Your app connects to QuickBlox server here.
//    
//    
//    
//    
//    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    
//        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
//        [[QBChat instance] addDelegate:self];
//
//    QBUUser *user = [QBUUser user];
//    user.login = userName;
//    user.password = password;
//    
//
//    
//    [QBRequest logInWithUserLogin:userName password:user.password  successBlock:^(QBResponse *response, QBUUser *user) {
//        // Success, do something
//        NSLog(@"success:Response");
//        [QBChat.instance addDelegate:self];
//
////        [QBChat.instance loginWithUser:user];
//        
//
//
//    } errorBlock:^(QBResponse *response) {
//        // error handling
//        NSLog(@"error: %@", response.error);
//        NSLog(@"error:Response");
//
//    }];
//    
//    

    
    
//    
//    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
//        // Success, do something
//        
//        
//        
//        //        [self loginToChat:self.session withPassword:password];
//    } errorBlock:^(QBResponse *response) {
//        // error handling
//        NSLog(@"error: %@", response.error);
//    }];
    
//}
#pragma mark - QuickBlox
- (void(^)(QBResponse *))handleError
{
    return ^(QBResponse *response)
    {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
//                                                        message:[response.error description]
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"OK", "")
//                                              otherButtonTitles:nil];
//        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    };
}
//
//- (void)loginToChat:(QBASession *)session withPassword:(NSString*)password
//{
//    // Set QuickBlox Chat delegate
//    [[QBChat instance] addDelegate:self];
//    //    [QBChat instance].delegate = self;
//    
//    QBUUser *user = [QBUUser user];
//    user.ID = session.userID;
//    user.password = password;
//    
//    // Login to QuickBlox Chat
//    [[QBChat instance] loginWithUser:user];
//}

#pragma mark QBChatDelegate
#pragma mark - QBChatDelegate

- (void)chatDidNotConnectWithError:(NSError *)error {
    
    if (self.chatConnectCompletionBlock) {
        self.chatReconnectedBlock();

        self.chatConnectCompletionBlock(YES);
        self.chatConnectCompletionBlock = nil;
    }
}

- (void)chatDidAccidentallyDisconnect {
    
    if (self.chatConnectCompletionBlock) {
        
        self.chatConnectCompletionBlock(YES);
        self.chatConnectCompletionBlock = nil;
    }
    if (self.chatDisconnectedBlock) {
        self.chatDisconnectedBlock();
    }

}

- (void)chatDidFailWithStreamError:(NSError *)error {
    
    if (self.chatConnectCompletionBlock) {
        
        self.chatConnectCompletionBlock(YES);
        self.chatConnectCompletionBlock = nil;
        self.chatReconnectedBlock();

    }
}

- (void)chatDidConnect {
    
    [[QBChat instance] sendPresence];
    __weak __typeof(self)weakSelf = self;
    
    self.presenceTimer = [[QBRTCTimer alloc] initWithTimeInterval:5
                                                           repeat:YES
                                                            queue:dispatch_get_main_queue()
                                                       completion:^{
                                                           [[QBChat instance] sendPresence];
                                                           
                                                       } expiration:^{
                                                           
                                                           if ([QBChat.instance isConnected]) {
                                                               [QBChat.instance disconnectWithCompletionBlock:nil];
                                                           }
                                                           
                                                           [weakSelf.presenceTimer invalidate];
                                                           weakSelf.presenceTimer = nil;
                                                       }];
    
    self.presenceTimer.label = @"Chat presence timer";
    
    if (self.chatConnectCompletionBlock) {
        
        self.chatConnectCompletionBlock(NO);
        self.chatConnectCompletionBlock = nil;
    }
}

- (void)chatDidReconnect {
    if (self.chatReconnectedBlock) {
        self.chatReconnectedBlock();
    }
}
- (void)session:(QBRTCSession *)session initializedLocalMediaStream:(QBRTCMediaStream *)mediaStream {
    
    NSLog(@"Initialized local media stream %@", mediaStream);
}

//- (void)chatDidConnect {
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    
//}
//- (void)chatDidNotConnectWithError:(NSError *)error {
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    
//}




@end
