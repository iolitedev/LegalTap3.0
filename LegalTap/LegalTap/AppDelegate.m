
//  AppDelegate.m
//  LegalTap
//
//  Created by John Basile on 7/12/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "AppDelegate.h"

# import "FeedbackToLawyerViewController.h"
#import "PayPalMobile.h"
#import "MainViewController.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import <AirshipKit/AirshipKit.h>
#import <Appsee/Appsee.h>


#define MIXPANEL_TOKEN @"4f7ad239fb0f15a8f2d76ffceb0b2166"
#define kLabelAlignmentLeft      NSTextAlignmentLeft

 //./Fabric.framework/run 2756f39298c80650d130cc4ccfe4676caecb826a c38cfd35d889227faaba05755154d4e200439c5503b9d1fd022634c5a7848bd8

const CGFloat kQBRingThickness = 1.f;
const NSTimeInterval kQBAnswerTimeInterval = 10.0f;
const NSTimeInterval kQBRTCDisconnectTimeInterval = 60.f;

const NSUInteger kQBApplicationID = 92;
NSString *const kQBRegisterServiceKey = @"wJHdOcQSxXQGWx5";
NSString *const kQBRegisterServiceSecret = @"BTFsj7Rtt27DAmT";
NSString *const kQBAccountKey = @"7yvNe17TnjNUqDoPwfqp";


@interface AppDelegate ()<CrashlyticsDelegate>

@end

@implementation AppDelegate
@synthesize navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appsee start:@"369cbfd79fe346cb86f41b1b625f6c4b"];

    CrashlyticsKit.delegate = self;
    [Fabric with:@[CrashlyticsKit]];
	// Override point for customization after application launch.
	[UIApplication sharedApplication].idleTimerDisabled = YES;
    [LTAPIClientManager sharedClient];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	sleep(2);
	
	//Testing quickblox pro account
    
    [QBSettings setApplicationID:22458];
    [QBSettings setAuthKey:@"jMJkryAcMUdFPJ3"];
    [QBSettings setAuthSecret:@"WQOsbHkgrbhJ8PE"];
    [QBSettings setAccountKey:@"sPbsTxEpayqZfnN9pSGa"];
    
    [QBSettings setLogLevel:QBLogLevelNothing];
    [QBSettings setAutoReconnectEnabled:YES];
    //QuickbloxWebRTC preferences

    [QBRTCConfig setAnswerTimeInterval:90];
    [QBRTCConfig setDTLSEnabled:YES];

    [QBRTCConfig setDisconnectTimeInterval:kQBRTCDisconnectTimeInterval];
    [QBRTCConfig setDialingTimeInterval:kQBAnswerTimeInterval];
    [QBRTCClient initializeRTC];
    
  	//sandbox of deepak account
	/*//sandbox
	[PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox:@"AWg5Cj7a7IwbeqeYYl9RT9t9Q3SaS45s4o1wIBY2no5eV_CFW2a5l3ZjM7RBAhczjW08s4IFBI3b-daJ"}];*/
	
	//Live
	[PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:@"ATfkRBq1e8LuqhQEVNmwoMt42N6t9GWo7hVkkYzx8YEm0W5_Wwq31h4Ik-kLXHC89wGCBEyhn0c8QdwT"}];
	
	// Initialize the library with your
	// Mixpanel project token, MIXPANEL_TOKEN
	[Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
	
	// Later, you can get your instance with
	Mixpanel *mixpanel = [Mixpanel sharedInstance];
	
	[mixpanel track:@"App launch" properties:@{
											   @"method": @"appdelegate",
											   }];
   
    UAConfig *config = [UAConfig defaultConfig];
    
    [UAirship takeOff:config];

    [UAirship push].userPushNotificationsEnabled = YES;

     [UAirship push].pushNotificationDelegate = self;
    NSString *channelId = [UAirship push].channelID;
    NSLog(@"My Application Channel ID: %@", channelId);
    
	
	// For push notifications
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
//    [[Crashlytics sharedInstance] crash];
	
    
	
	[[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
	[[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
											 forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
											 forState:UIControlStateSelected];
	//blueImage
	
	if (IS_IPHONE_5)
	{
		
		UIImage *BlueBackground = [UIImage imageNamed:@"blueImage1"];
		[[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
	}
	else if (IS_IPHONE_6P)
	{
		
		UIImage *BlueBackground = [UIImage imageNamed:@"blueImage3"];
		[[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
		
	}
	else
	{
		
		UIImage *BlueBackground = [UIImage imageNamed:@"blueImage2"];
		[[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
	}
	
	
		
	return YES;
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // available in iOS8
{
	[application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
	//Format token as you need:
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	NSLog(@"---%@",token);
	[[NSUserDefaults standardUserDefaults] setValue:token forKey:@"DeviceToken"];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"I am here");
    NSString *userType = [SharedSingleton sharedClient].user_Profile.userType;
    if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"A LegalTap client is ready to talk to you!"])
    {
        _terminateUserId = [[userInfo valueForKey:@"token"] valueForKey:@"userId"];
        [SharedSingleton sharedClient].appID = [[userInfo valueForKey:@"token"] valueForKey:@"appointmentId"];
        lawyerType = [[userInfo valueForKey:@"token"] valueForKey:@"LawyerType"];
    }
    
    else if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"A LegalTap Lawyer is ready to talk to you!"])
    {
        _isCallStart = NO;
        [SharedSingleton sharedClient].user_Profile.quickBloxLawyer_Id = [[userInfo valueForKey:@"token"] valueForKey:@"quickBloxId"];
        [SharedSingleton sharedClient].appID = [[userInfo valueForKey:@"token"] valueForKey:@"appointmentId"];
        lawyerType = [[userInfo valueForKey:@"token"] valueForKey:@"LawyerType"];
        [SharedSingleton sharedClient].user_Profile.lawyerId = [[userInfo valueForKey:@"token"] valueForKey:@"clientId"];
    }
    
    if ([userType isEqualToString:@"lawyer"])
    {
        if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"App Terminated By User!"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TerminateApp" object:nil];
        }
        else if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"Approve to Receive Contact Info"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ApproveContactRequestFromClient" object:nil userInfo:userInfo];
            
            return;
        }
        else if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"A LegalTap client is not ready to talk to you!"])
        {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
        }
        else if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"A LegalTap client is ready to talk to you!"])
        {
            QuestionAnsArray=[[NSMutableArray alloc] init];
            QuestionAnsArray=[[[userInfo valueForKey:@"token"] valueForKey:@"questionare"] mutableCopy];
            alert=[[UIAlertView alloc] initWithTitle:nil message:@"LegalTap Client Ready! Please respond!" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag=1;
            [alert show];
            if (!timer) {
                timer = [NSTimer scheduledTimerWithTimeInterval:87.0f
                                                         target:self
                                                       selector:@selector(timerr)
                                                       userInfo:nil
                                                        repeats:YES];
            }
            startTime=88;
            CountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target: self
                                                            selector:@selector(CountDownTimer)
                                                            userInfo: nil repeats:YES];
            
            ClientIdFromNotif=[[userInfo valueForKey:@"token"] valueForKey:@"userId"];
            quickBloxId=[[userInfo valueForKey:@"token"] valueForKey:@"quickBloxId"];
            quickBloxUsername=[[userInfo valueForKey:@"token"] valueForKey:@"quickBloxUserName"];
            Username=[[userInfo valueForKey:@"token"] valueForKey:@"username"];
            //			 [self AddAcceptRejectView];
        }
    }
    
    else
    {
        if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"Approve Form Request"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ApproveFormRequestFromUser" object:nil userInfo:userInfo];
            return;
        }
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"App Terminated By Lawyer!"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TerminateApp" object:nil];
        }
        else if ([message isEqualToString:@"Lawyer Accepted your call"])
        {
            [SharedSingleton sharedClient].user_Profile.quickBloxLawyer_Id = [[userInfo valueForKey:@"token"] valueForKey:@"quickBloxId"];
            [SharedSingleton sharedClient].user_Profile.lawyerId = [[userInfo valueForKey:@"token"] valueForKey:@"userId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YesFromLaywer" object:nil userInfo:userInfo];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoFromLaywer" object:nil userInfo:userInfo];
        }
    }
    
    
   	// Handle your remote RemoteNotification
}
-(void)timerr
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [timer invalidate];
    timer = nil;
}
-(void)CountDownTimer
{
    startTime=startTime-1;
    if (startTime==0)
    {
        startTime=0;
        [CountDownTimer invalidate];
        [NotifView removeFromSuperview];
    }
    Timelabel.text=[NSString stringWithFormat:@"%@%d",@"Time Left : ",startTime];
}
-(void)AddAcceptRejectView
{
    NotifView=[[UIView alloc] initWithFrame:self.window.frame];
    NotifView.backgroundColor=[UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:NotifView];
    
    //QuestionAnsView
    
    UIView*questionAnsView=[CommonHelper loadAnswersOnViewWithArray:QuestionAnsArray withWidth:NotifView.frame.size.width];
    questionAnsView.frame = CGRectMake(0,0,320, 50);
    [NotifView addSubview:questionAnsView];
    
    //NameLabel
    UILabel *NameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 95, 100, 30)];
    [NotifView addSubview:NameLbl];
    NameLbl.text = @"Username:";
    NameLbl.textColor = [UIColor blackColor];
    // NameLbl.textAlignment = UITextAlignmentLeft;
    NameLbl.textAlignment=NSTextAlignmentLeft;
    
    //NameLabel1
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(100, 95, 190, 30)];
    [NotifView addSubview:Name];
    Name.text = Username;
    Name.textColor = [UIColor blackColor];
    //    Name.textAlignment = UITextAlignmentLeft;
    Name.textAlignment=NSTextAlignmentLeft;
    
    
    UIImageView *LogoImageView;
    if (IS_IPHONE_5)
    {
        LogoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(90,50,150,40)];
        Timelabel=[[UILabel alloc] initWithFrame:CGRectMake(190, 30, 150, 20)];
    }
    else if (IS_IPHONE_6)
    {
        LogoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(105,50,150,40)];
        Timelabel=[[UILabel alloc] initWithFrame:CGRectMake(230, 30, 150, 20)];
    }
    else if (IS_IPHONE_6P)
    {
        LogoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(105,50,150,40)];
        Timelabel=[[UILabel alloc] initWithFrame:CGRectMake(220, 40, 150, 20)];
    }
    
    else if (IS_IPHONE_4_OR_LESS)
    {
        Timelabel=[[UILabel alloc] initWithFrame:CGRectMake(190, 65, 150, 20)];
        LogoImageView =[[UIImageView alloc] initWithFrame:CGRectMake(80,25,150,40)];
        NameLbl.frame=CGRectMake(10, 80, 100, 30);
        Name.frame=CGRectMake(100, 80, 150, 30);
    }
    //  Timelabel.text=[NSString stringWithFormat:@"%@%@",@"Time Left : ",@"90"];
    
    LogoImageView.image=[UIImage imageNamed:@"Logo"];
    [NotifView addSubview:LogoImageView];
    [NotifView addSubview:Timelabel];
    
    //connect Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(ConnectButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"CONNECT" forState:UIControlStateNormal];
    if (IS_IPHONE_5)
    {
        button.frame = CGRectMake(10, 430, 120, 120);
    }
    else if (IS_IPHONE_6)
    {
        button.frame = CGRectMake(25, 500, 120, 120);
    }
    else if (IS_IPHONE_6P)
    {
        button.frame = CGRectMake(25, 600, 120, 120);
    }
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderWidth=1.0;
    if (IS_IPHONE_4_OR_LESS)
    {
        button.layer.cornerRadius=40;
    }
    else
    {
        button.layer.cornerRadius=60;
    }
    
    [NotifView addSubview:button];
    
    //Decline Button
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 addTarget:self
                action:@selector(DeclineButtonAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"DECLINE" forState:UIControlStateNormal];
    if (IS_IPHONE_5)
    {
        button1.frame = CGRectMake(180, 430, 120, 120);
        
    }
    else if (IS_IPHONE_6)
    {
        button1.frame = CGRectMake(220, 500, 120, 120);
    }
    else if (IS_IPHONE_6P)
    {
        button1.frame = CGRectMake(280, 600, 120, 120);
    }
    
    else if (IS_IPHONE_4_OR_LESS)
    {
        button.frame = CGRectMake(25, 390, 80, 80);
        button1.frame = CGRectMake(205, 390, 80, 80);
    }
    
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.layer.borderWidth=1.0;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        button1.layer.cornerRadius=40;
    }
    else
    {
        button1.layer.cornerRadius=60;
    }
    
    
    [NotifView addSubview:button1];
    
}

-(IBAction)ConnectButtonAction:(id)sender
{
    [NotifView removeFromSuperview];
    call=YES;
    startTime=0;
    [CountDownTimer invalidate];
    
    [self CallResponseToClient:ClientIdFromNotif andWithResponse:@"yes"];
    
    
}
-(IBAction)DeclineButtonAction:(id)sender
{
    [NotifView removeFromSuperview];
    call=NO;
    startTime=0;
    [CountDownTimer invalidate];
    [self CallResponseToClient:ClientIdFromNotif andWithResponse:@"no"];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error:%@",error);
    // [CommonHelper loadAnswersOnViewWithArray:<#(NSArray *)#> withWidth:320];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [NotifView removeFromSuperview];
            call=NO;
            [self CallResponseToClient:ClientIdFromNotif andWithResponse:@"no"];
            
            startTime=0;
            [CountDownTimer invalidate];
            
        }
        else if (buttonIndex==1)
        {
            NSMutableArray *userId = [[NSMutableArray alloc] init];
            UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
            NSString *UserId=user_Profile.userId;
            
            [SignInAndSignUpHelper GetUsersList:lawyerType withUserId:UserId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
             {
                 
                 NSArray *arr = [responseObject valueForKey:@"lawyer"];
                 for (NSDictionary *dict in arr)
                 {
                     NSString *str = [dict valueForKey:@"userId"];
                     [userId addObject:str];
                     NSLog(@"aaaaaaa:%@",userId);
                     
                 }
                 
                 [SignInAndSignUpHelper UserCall:userId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                  {
                      if (!error) {
                          
                          NSLog(@"SUCCESS");
                      }
                  }];
                 
             }];
            
            
            //			 call=YES;
            //			 [self CallResponseToClient:ClientIdFromNotif andWithResponse:@"yes"];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(targetMethod:)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
}

-(IBAction)targetMethod:(id)sender
{
    [self AddAcceptRejectView];
}

-(void)CallResponseToClient:(NSString *)ClientId andWithResponse:(NSString *)response
{
    NSMutableArray *userId = [[NSMutableArray alloc] init];
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *UserId=user_Profile.userId;
    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    
    [SignInAndSignUpHelper CallResponseToClient:ClientId withUserId:UserId withResponse:response andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if (responseObject && responseObject.count)
                 {
                     //  UserProfile *user_Profile = [[UserProfile alloc] initWithDictionary:detailUser];
                     if ([[responseObject valueForKey:@"success"] integerValue]==1)
                     {
                         if (call==YES)
                         {
                             [self PushToMainViewForVideoCall];
                         }
                     }
                 }
                 else
                 {
                     
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 
                 NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:errorMsg
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
             
             
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Try Again.."
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         
     }];
}

-(void)PushToMainViewForVideoCall
{
    self.navigationController = (UINavigationController *)self.window.rootViewController;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MainViewController *controller = (MainViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MainVC"];
    
    if (quickBloxId.length)
    {
        NSNumber *num = [NSNumber numberWithLongLong:quickBloxId.longLongValue];
        controller.opponentID = num;
        controller.UserIdFromAppointmentView=ClientIdFromNotif;
    }
    else
    {
        // MainVC.opponentID = appDelegate.currentUser == 1 ? appDelegate.testOpponents[5] : appDelegate.testOpponents[2];
    }
    
    controller.ComingFromSide=@"Lawyer Side";
    controller.ComingFromApprovelView=@"Yes";
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    @try
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:defApplicationDidEnterBackground object:nil];
    }
    @catch (NSException *exception)
    {}
    @finally {}
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    @try
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:defApplicationWillEnterForeground object:nil];
    }
    @catch (NSException *exception)
    {}
    @finally {}
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    @try
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:defApplicationDidBecomeActive object:nil];
    }
    @catch (NSException *exception)
    {}
    @finally {}
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSString *userType = [SharedSingleton sharedClient].user_Profile.userType;
    if ([userType isEqualToString:@"lawyer"])
    {
        NSLog(@"assd:%@", _terminateUserId);
        [SignInAndSignUpHelper TerminateAppByLawyer:_terminateUserId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             if (!error)
             {
                 NSLog(@"Result: %@",responseObject);
             }
         }];
    }
    else
    {
        [SignInAndSignUpHelper TerminateApp:[SharedSingleton sharedClient].user_Profile.lawyerId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             NSLog(@"Result: %@",responseObject);
             
         }];
    }
    
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    if (user_Profile && user_Profile.userId.length)
    {
        [SignInAndSignUpHelper changeStatusWithUserId:user_Profile.userId
                                           withStatus:NO andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             NSLog(@"%@\nLogout Status",responseObject);
             user_Profile.onlineStatus = NO;
         }];
    }
}

#pragma mark - Methods

-(void)loadUserProfileIfExist
{
    [SharedSingleton sharedClient].user_Profile = [CommonHelper getUserProfileFromUserDefault];
}

@end
