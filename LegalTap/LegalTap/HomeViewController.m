//
//  HomeViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "HomeViewController.h"
#import "SliderViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AppointmentApprovalViewController.h"
#import "Settings.h"

SliderViewController *SliderVC;
const NSTimeInterval kChatPresenceTimeInterval = 15;

@interface HomeViewController ()
@property (strong, nonatomic) QBRTCSession *session;
@property (strong, nonatomic) Settings *settings;
@property (copy, nonatomic) void(^chatConnectCompletionBlock)(BOOL error);
@property (copy, nonatomic) dispatch_block_t chatDisconnectedBlock;
@property (copy, nonatomic) dispatch_block_t chatReconnectedBlock;
@property (strong, nonatomic) QBRTCTimer *presenceTimer;
@end

@implementation HomeViewController
@synthesize isListExpended,ShowSliderView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    ShowSliderView=NO;
    // Later, you can get your instance with
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Legal Practice Area" properties:@{
                                                        @"method": @"Legal Practice Area",
                                                        }];
    // Do any additional setup after loading the view.
    
    if (!_identifierPreviousVC.length)
    {
        _identifierPreviousVC = @"HomeTab";
        
    }
    _array_LegalPracticeList = [CommonHelper legalPracticeList];
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
        self.title= @"Legal Practice Area";
        navigation_Title.text = @"Talk to a lawyer";
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please select your legal practice area and answer the questions to schedule your appointment." delegate:nil cancelButtonTitle:@"Thanks" otherButtonTitles:nil, nil];
        [alert show];
        
        sliderBtn.hidden=YES;
    }
    else
    {
        [self videoCalling];
        
        SliderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Slider"];
        
        SliderVC.VC = self;
        [self.view addSubview:SliderVC.view];
        
        if (IS_IPHONE_6)
        {
            SliderVC.view.frame = CGRectMake(-250, 0, 200,650);
        }
        else if (IS_IPHONE_6P)
        {
            SliderVC.view.frame = CGRectMake(-250, 0, 200,750);
        }
        else
        {
            SliderVC.view.frame = CGRectMake(-250, 0, 200,550);
        }
    }
    [QBRTCClient.instance addDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    strSelectedPractice = @"";
    [self reloadtableView];
}

-(void)HideSlider
{
    [self hideContentController:SliderVC];
    ShowSliderView=NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(IBAction)SliderButton:(id)sender
{
    if (ShowSliderView == NO)
    {
        [self displayContentController:SliderVC];
        ShowSliderView = YES;
    }
    else
    {
        [self hideContentController:SliderVC];
        ShowSliderView = NO;
    }
}

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         if (IS_IPHONE_6)
                         {
                             content.view.frame = CGRectMake(0, 0, 250,650);
                         }
                         else if (IS_IPHONE_6P)
                         {
                             content.view.frame = CGRectMake(0, 0, 250,750);
                         }
                         else
                         {
                             content.view.frame = CGRectMake(0, 0, 250,550);
                         }
                     }];
    
    [content didMoveToParentViewController:self];
}

-(void) hideContentController: (UIViewController*) content
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         if (IS_IPHONE_6)
                         {
                             content.view.frame = CGRectMake(-250, 0, 200,650);
                         }
                         else if (IS_IPHONE_6P)
                         {
                             content.view.frame = CGRectMake(-250, 0, 200,750);
                         }
                         else
                         {
                             content.view.frame = CGRectMake(-250, 0, 200,550);
                         }
                     }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"HomeToHCHelp"])
    {
        HowCanWeHelpYouViewController *viewController = [segue destinationViewController];
        viewController.identifierPreviousVC = _identifierPreviousVC;
        viewController.strSelectedPractice = strSelectedPractice.length?strSelectedPractice:@"All";
        
        if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
        {
            viewController.appointmentDate = _appointmentDate;
        }
    }
}

#pragma mark Table View Data Source Method

-(void)reloadtableView
{
    [tableView_ExpendedList reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
        return 1;
    }
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
        return 60;
    }
    
    CGFloat headerHeight = 0.0f;
    switch (section)
    {
        case 1:
            headerHeight = 60;
            break;
            
        default:
            headerHeight = 0.0;
            break;
    }
    return headerHeight;
}

-(UIView*)headerViewWithSection:(NSInteger)section withtable:(UITableView*)tableView
{
    NSString *headerTitle = @"Select area of legal practice";
    UIView *headerView = [[UIView alloc] init];
    {
        headerView.frame = CGRectMake(0,
                                      0,
                                      CGRectGetWidth(tableView.frame),
                                      60);
        
        headerView.backgroundColor = [UIColor clearColor];
        headerView.layer.masksToBounds = YES;
        //Background color
        UIView *viewBackColor = [[UIView alloc] init];
        {
            if (isListExpended)
            {
                viewBackColor.frame = CGRectMake(14,
                                                 0,
                                                 CGRectGetWidth(tableView.frame)-30,
                                                 44);
                viewBackColor.backgroundColor = [UIColor whiteColor];//defColor_DropDownListHeaderSeleted;
            }
            else
            {
                viewBackColor.frame = CGRectMake(14,
                                                 0,
                                                 CGRectGetWidth(tableView.frame)-30,
                                                 52);
                viewBackColor.backgroundColor =[UIColor whiteColor]; //defColor_DropDownListHeader;
            }
            viewBackColor.layer.cornerRadius = 4.0;
            viewBackColor.layer.masksToBounds = YES;
            
            UILabel *lbl_HeaderTitle = [[UILabel alloc] init];
            {
                
                lbl_HeaderTitle.frame = CGRectMake(20,
                                                   10,
                                                   CGRectGetWidth(viewBackColor.frame)-30,
                                                   30);
                lbl_HeaderTitle.text = headerTitle;
                // lbl_HeaderTitle.textColor = [UIColor lightGrayColor];
                lbl_HeaderTitle.textColor=[UIColor colorWithRed:165/255.0f green:157/255.0f blue:157/255.0f alpha:1.0f];
                lbl_HeaderTitle.textAlignment = NSTextAlignmentLeft;
                lbl_HeaderTitle.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
                
            }
            [viewBackColor addSubview:lbl_HeaderTitle];
            viewBackColor.layer.borderColor=[UIColor lightGrayColor].CGColor;
            viewBackColor.layer.borderWidth=0.5;
            
            if (![_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
            {
                UIImageView *imgDownArrowIcon = [[UIImageView alloc] init];
                {
                    imgDownArrowIcon.frame = CGRectMake(CGRectGetWidth(viewBackColor.frame) - 10 - 10,
                                                        20,
                                                        10,
                                                        10.0);
                    imgDownArrowIcon.image = [UIImage imageNamed:@"New_downArrow"];
                    imgDownArrowIcon.contentMode = UIViewContentModeScaleAspectFit;
                }
                [viewBackColor addSubview:imgDownArrowIcon];
                
                
                UIButton *btn_ExpandList = [[UIButton alloc] init];
                {
                    btn_ExpandList.frame = viewBackColor.bounds;
                    [btn_ExpandList addTarget:self action:@selector(btnClicked_ExpandList:) forControlEvents:UIControlEventTouchUpInside];
                }
                [viewBackColor addSubview:btn_ExpandList];
            }
            else
            {
                lbl_HeaderTitle.frame = CGRectMake(10,
                                                   5,
                                                   CGRectGetWidth(viewBackColor.frame)-20,
                                                   30);
                lbl_HeaderTitle.textAlignment = NSTextAlignmentCenter;
            }
        }
        [headerView addSubview:viewBackColor];
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
        return [self headerViewWithSection:section withtable:tableView];
    }
    switch (section)
    {
        case 1:
        {
            return [self headerViewWithSection:section withtable:tableView];
            break;
        }
        default:
            return nil;
            break;
    }
}

-(void)btnClicked_ExpandList:(UIButton*)sender
{
    if (isListExpended)
    {
        isListExpended = !isListExpended;
        [tableView_ExpendedList reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else
    {
        isListExpended = !isListExpended;
        [tableView_ExpendedList reloadData];
        [tableView_ExpendedList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 1;
    switch (section)
    {
        case 0:
            number = 1;
            break;
        case 1:
        {
            if (isListExpended)
                number = _array_LegalPracticeList.count+1;
            else
                number = 0;
            break;
        }
        default:
            number = 0;
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat headerHeight = 0.0f;
    switch (indexPath.section)
    {
        case 0:
        {
            if ([CommonHelper isiPhone5or5s])
            {
                headerHeight = 384;
            }
            else if (IS_IPHONE_6P)
            {
                headerHeight = 500;
            }
            else
            {
                headerHeight = 430;
            }
            break;
        }
        case 1:
        {
            if (indexPath.row == _array_LegalPracticeList.count)
            {
                headerHeight = 20.0;
            }
            else
            {
                headerHeight = 58.0;
            }
            break;
        }
        default:
            headerHeight = 0.0;
            break;
    }
    return headerHeight;
}

-(UITableViewCell *)legalTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        NSString *identifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        UIImageView *imageView_Logo = [[UIImageView alloc] init];
        {
            imageView_Logo.frame = CGRectMake(10,
                                              -4,
                                              CGRectGetWidth(tableView.frame)-20,
                                              14);
            imageView_Logo.layer.cornerRadius = 4;
            
            imageView_Logo.backgroundColor = defColor_CellBackground;
            
        }
        [cell.contentView addSubview:imageView_Logo];
        cell.clipsToBounds = YES;
        return cell;
    }
    else
    {
        NSString *identifier = @"LegalPracticeTableViewCell";
        LegalPracticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            cell = [array firstObject];
        }
        cell.delegate = self;
        
        NSString *strTitle =  _array_LegalPracticeList[indexPath.row];
        cell.textTitle = strTitle;
        cell.indexPath = indexPath;
        cell.accessibilityIdentifier = strTitle;
        
        NSString *strImageName = [strTitle lowercaseString];
        {
            strImageName = [strImageName stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
            strImageName = [strImageName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            strImageName = [NSString stringWithFormat:@"LP_%@",strImageName];
        }
        cell.imageView_Icon.image = [UIImage imageNamed:strImageName];
        cell.imgName = strImageName;
        [cell layoutIfNeeded];
        return cell;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0://Logo
        {
            NSString *identifier = @"HomeLegalInquryTableViewCell";
            HomeLegalInquryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
                cell = [array firstObject];
            }
            cell.delegate = self;
            
            [cell layoutIfNeeded];
            return cell;
        }
        case 1://List
        {
            return [self legalTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        default:
        {
            NSString *identifier = @"cellIdentifier1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma Table View Delegates

- (IBAction)btnClickedTalkToLawyer:(id)sender
{
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Talk to lawyer now" properties:@{
                                                       @"method": @"Talk to lawyer now",
                                                       }];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"All" forKey:@"LawyerType"];
    
    [self pushToQuestionVC_HCHelpWith:@"All"];
}

-(void)HomeLegalInquryTableViewCellDidSelect:(NSString *)LegalPractive
{
    [self pushToQuestionVC_HCHelpWith:LegalPractive];
    
}

-(void)LegalPracticeTableViewCellDidSelect:(NSString *)LegalPractive withIndexPath:(NSIndexPath *)indexPath
{
    NSString *strTitle =  _array_LegalPracticeList[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setValue:strTitle forKey:@"LawyerType"];
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:strTitle properties:@{
                                          @"method": strTitle,
                                          }];
    
    NSString *strPractice = LegalPractive;
    strPractice = [strPractice stringByReplacingOccurrencesOfString:@"&" withString:@"AND"];
    [self pushToQuestionVC_HCHelpWith:strPractice];
    
}

-(void)pushToQuestionVC_HCHelpWith:(NSString*)legalPractice
{
    strSelectedPractice = legalPractice;
    NSString *strKey = strSelectedPractice;
    
    if ([strKey isEqualToString:@"All"])
    {
        [self performSegueWithIdentifier:@"HomeToHCHelp" sender:self];
        return;
    }
    
    if ([self questionsWithKey:strKey] && [self questionsWithKey:strKey].count)
    {
        [self performSegueWithIdentifier:@"HomeToHCHelp" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"No Data Existed for selected Legal Practice."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(NSArray*)questionsWithKey:(NSString*)key
{
    NSArray *arr;
    {
        NSString *strUrl = [[NSBundle mainBundle] pathForResource:@"LegalPractice" ofType:@"plist"];
        NSDictionary *dict_LegalPractice = [NSDictionary dictionaryWithContentsOfFile:strUrl];
        
        NSDictionary *dict_LegalPracticeAreaData = [dict_LegalPractice objectForKey:@"Practice Area List Data"];
        
        NSDictionary *dict_Detail = [dict_LegalPracticeAreaData objectForKey:key];
        
        if (dict_Detail && [dict_Detail isKindOfClass:[NSDictionary class]])
        {
            arr = [dict_Detail objectForKey:@"Questions"];
        }
        else
        {
            return @[];
        }
    }
    return arr;
}

#pragma mark - Video calling

-(void)videoCalling
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    
    NSString *qUserName;
    NSString *qPassword;
    if (user_Profile.quickBlox_UserName.length)
    {
        qUserName = user_Profile.quickBlox_UserName;
        qPassword = user_Profile.quickBlox_UserName;
    }
    else
    {
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
    
    //    user.login = qUserName;
    //    user.password = qPassword;
    //    user.fullName = user_Profile.name;
    //    user.ID = user_Profile.userId.intValue;
    
[self logInWithUser:user completion:^(BOOL error) {
    
} disconnectedBlock:^{
} reconnectedBlock:^{
    
}];
    
}

- (void)applyConfiguration {
    
    NSMutableArray *iceServers = [NSMutableArray array];
    
    for (NSString *url in self.settings.stunServers) {
        
        QBRTCICEServer *server = [QBRTCICEServer serverWithURL:url username:@"" password:@""];
        [iceServers addObject:server];
    }
    
    [iceServers addObjectsFromArray:[self quickbloxICE]];
    
    [QBRTCConfig setICEServers:iceServers];
    [QBRTCConfig setMediaStreamConfiguration:self.settings.mediaConfiguration];
    [QBRTCConfig setStatsReportTimeInterval:60.0f];
}
- (NSArray *)quickbloxICE {
    
    NSString *password = @"baccb97ba2d92d71e26eb9886da5f1e0";
    NSString *userName = @"quickblox";
    
    QBRTCICEServer * stunServer = [QBRTCICEServer serverWithURL:@"stun:turn.quickblox.com"
                                                       username:@""
                                                       password:@""];
    
    QBRTCICEServer * turnUDPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=udp"
                                                          username:userName
                                                          password:password];
    
    QBRTCICEServer * turnTCPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=tcp"
                                                          username:userName
                                                          password:password];
    
    
    return@[stunServer, turnTCPServer, turnUDPServer];
}



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
        
    }];
}


//Video Chat
-(void)createSeesionForClientwithUserName:(NSString*)userName withUserPassword:(NSString*)password
{
    // Your app connects to QuickBlox server here.
    
    QBUUser *user = [QBUUser user];
    user.login = userName;
    user.password = password;
    
    
    [QBRequest logInWithUserLogin:userName password:user.password  successBlock:^(QBResponse *response, QBUUser *user) {
        // Success, do something
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"error: %@", response.error);
    }];
}

#pragma mark - Main view delegate

-(void)MainViewControllerDidEndCall
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    if (user_Profile && [user_Profile.userType isEqualToString:@"user"])
    {
        [[QBChat instance] addDelegate:self];
        
        MainVC = nil;
    }
}

#pragma mark - QuickBlox

- (void(^)(QBResponse *))handleError
{
    return ^(QBResponse *response)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    };
}

- (void)loginToChat:(QBRTCSession *)session withPassword:(NSString*)password
{
    
    // Set QuickBlox Chat delegate
    [[QBChat instance] addDelegate:self];
    
    QBUUser *user = [QBUUser user];
    user.login =
    user.password = password;
    
    
     //Login to QuickBlox Chat
    
    [QBChat.instance connectWithUser:user completion:^(NSError * _Nullable error) {
        
        NSLog(@"Error:123:%@",error);
    }];
}

#pragma mark QBChatDelegate
- (void)session:(QBRTCSession *)session initializedLocalMediaStream:(QBRTCMediaStream *)mediaStream {
    
    NSLog(@"Initialized local media stream %@", mediaStream);
}


#pragma mark QBChatDelegate
- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    //     save  opponent data
    MainViewController *MainVCc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    
    if (MainVCc.session) {
        
        [session rejectCall:@{@"reject" : @"busy"}];
        return;
    }
    
    MainVCc.session = session;
    NSArray *num = [NSArray arrayWithObject:session.opponentsIDs];
    MainVCc.videoCallOppId = num[0][0];
    
    
    [QBRTCSoundRouter.instance initialize];
    [self.navigationController.tabBarController.navigationController pushViewController:MainVCc animated:NO];}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.session) {
        
        [QBRTCSoundRouter.instance deinitialize];
        self.session = nil;
        [QBRTCClient deinitializeRTC];

    }
    
    
}
- (void)chatDidNotConnectWithError:(NSError *)error {
    
    if (self.chatConnectCompletionBlock) {
        
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
    }
}

- (void)chatDidConnect {
    
    [[QBChat instance] sendPresence];
    __weak __typeof(self)weakSelf = self;
    
    self.presenceTimer = [[QBRTCTimer alloc] initWithTimeInterval:kChatPresenceTimeInterval
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
@end