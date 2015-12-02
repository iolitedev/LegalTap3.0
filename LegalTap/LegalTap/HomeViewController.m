//
//  HomeViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "HomeViewController.h"
#import "SliderViewController.h"
SliderViewController *SliderVC;

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize isListExpended,ShowSliderView;

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
    
    ShowSliderView=NO;
    // Later, you can get your instance with
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"Legal Practice Area" properties:@{
                                                        @"method": @"Legal Practice Area",
                                                        }];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    //    self.navigationController.navigationBar.alpha = 0.6;
    
    if (!_identifierPreviousVC.length)
    {
        _identifierPreviousVC = @"HomeTab";
        
        //Add slider button in home view
        
        //        UIButton *SliderBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        //        [SliderBtn setImage:[UIImage imageNamed:@"Slider"] forState:UIControlStateNormal];
        //      //  [SliderBtn setTitle:@"Slider" forState:UIControlStateNormal];
        //        [SliderBtn addTarget:self action:@selector(SliderButton:) forControlEvents:UIControlEventTouchUpInside];
        //        [SliderBtn setFrame:CGRectMake(0,0,50,32)];
        //        UIBarButtonItem *LeftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:SliderBtn];
        //        self.navigationItem.leftBarButtonItem = LeftBarBtn;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    // [self.navigationController.navigationBar
    // setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    self.navigationController.navigationBarHidden = YES;
    // self.navigationController.navigationBar.alpha = 1;
    
    strSelectedPractice = @"";
    [self reloadtableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    // self.navigationController.navigationBar.alpha = 1;
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //    [self hideContentController:SliderVC];
    //    ShowSliderView=NO;
    
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
    
    [content didMoveToParentViewController:self];          // 3
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
    //    else if ([segue.identifier isEqualToString:@"HomeToMeetUs"])
    //    {
    //        HowCanWeHelpYouViewController *viewController = [segue destinationViewController];
    //        viewController.identifierPreviousVC = _identifierPreviousVC;
    //    }
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
    //    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    //    {
    //        return _array_LegalPracticeList.count;; // removed +1 to hide the dropdown which was the last row
    //    }
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
    //    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    //    {
    //        if (indexPath.row == _array_LegalPracticeList.count)
    //        {
    //            headerHeight = 20.0;
    //        }
    //        else
    //        {
    //            headerHeight = 58.0;
    //        }
    //        return headerHeight;
    //    }
    
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
    //    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    //    {
    //        return [self legalTableView:tableView cellForRowAtIndexPath:indexPath];
    //    }
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
            //            cell.textLabel.text = @"TEXT";
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
    
    [self createSeesionForClientwithUserName:qUserName withUserPassword:qPassword];
}

//Video Chat
-(void)createSeesionForClientwithUserName:(NSString*)userName withUserPassword:(NSString*)password
{
    // Your app connects to QuickBlox server here.
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = userName;
    parameters.userPassword = password;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // QuickBlox session creation
    
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session)
     {
         [self loginToChat:session withPassword:password];
         
     } errorBlock:[self handleError]];
}

#pragma mark - Main view delegate

-(void)MainViewControllerDidEndCall
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    if (user_Profile && [user_Profile.userType isEqualToString:@"user"])
    {
        [[QBChat instance] addDelegate:self];
        // [QBRTCClient.instance addDelegate:self];
        
        MainVC = nil;
    }
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

- (void)loginToChat:(QBASession *)session withPassword:(NSString*)password
{
    // Set QuickBlox Chat delegate
    [[QBChat instance] addDelegate:self];
    //    [QBChat instance].delegate = self;
    // [QBRTCClient.instance addDelegate:self];
    
    QBUUser *user = [QBUUser user];
    user.ID = session.userID;
    user.password = password;
    
    // Login to QuickBlox Chat
    [[QBChat instance] loginWithUser:user];
}

#pragma mark QBChatDelegate

- (void)chatDidLogin
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)chatDidNotLogin
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark QBChatDelegate
// VideoChat delegate

-(void) chatDidReceiveCallRequestFromUser:(NSUInteger)userID
                            withSessionID:(NSString *)_sessionID
                           conferenceType:(enum QBVideoChatConferenceType)conferenceType
{
    
    NSLog(@"chatDidReceiveCallRequestFromUser %lu", (unsigned long)userID);
    //     save  opponent data
    videoChatOpponentID = userID;
    videoChatConferenceType = conferenceType;
    sessionID = _sessionID;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"call"] isEqualToString:@"reject"])
    {
        //  [[NSUserDefaults standardUserDefaults] setValue:@"accept" forKey:@"call"];
    }
    else
    {
        if (!MainVC)
        {
            MainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
            MainVC.delegate = self;
            [self.navigationController.tabBarController.navigationController pushViewController:MainVC animated:NO];
            
        }
    }
}

@end