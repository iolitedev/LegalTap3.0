//
//  AppDelegate.m
//  LegalTap
//
//  Created by John Basile on 7/12/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "AppDelegate.h"


#import "PayPalMobile.h"
#import "MainViewController.h"

#import "Fabric/Fabric.h"
#import "Crashlytics/Crashlytics.h"

#import <AirshipKit/AirshipKit.h>

#define MIXPANEL_TOKEN @"4f7ad239fb0f15a8f2d76ffceb0b2166"
# define kLabelAlignmentLeft      NSTextAlignmentLeft


//./Fabric.framework/run 2756f39298c80650d130cc4ccfe4676caecb826a c38cfd35d889227faaba05755154d4e200439c5503b9d1fd022634c5a7848bd8

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	[UIApplication sharedApplication].idleTimerDisabled = YES;
    [LTAPIClientManager sharedClient];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	sleep(2);
	
	//Video Chat
	//    self.testOpponents = @[@"parveensharma", @"parveensharma", @2569176,
	//                           @"ritesharora", @"ritesharora", @2569186];
	
	//    [QBApplication sharedApplication].applicationId = 21017;
	//    [QBConnection registerServiceKey:@"x7r3ZmYaqbV9GuP"];
	//    [QBConnection registerServiceSecret:@"bx5pUEy75jG6Xev"];
	//    [QBSettings setAccountKey:@"EX7wyrxsB4iDfPcFsQAc"];
	
	//    //Testing quickblox basic account
	//    [QBApplication sharedApplication].applicationId = 21074;
	//    [QBConnection registerServiceKey:@"MM8b57W2vOKneJ3"];
	//    [QBConnection registerServiceSecret:@"rRX9JL9YF23GrCz"];
	//    [QBSettings setAccountKey:@"VGLVfqEyphimjStbwXJP"];
	
	
	//Testing quickblox pro account
	[QBApplication sharedApplication].applicationId = 22458;
	[QBConnection registerServiceKey:@"jMJkryAcMUdFPJ3"];
	[QBConnection registerServiceSecret:@"WQOsbHkgrbhJ8PE"];
	[QBSettings setAccountKey:@"sPbsTxEpayqZfnN9pSGa"];
	
	
	//  AiPC9BjkCyDFQXbSkoZcgqH3hpacARnluiBfoYplT66qZzWSOl4qZGHr
	
	NSMutableDictionary *videoChatConfiguration = [[QBSettings videoChatConfiguration] mutableCopy];
	[videoChatConfiguration setObject:@20 forKey:kQBVideoChatCallTimeout];
	[videoChatConfiguration setObject:AVCaptureSessionPresetMedium forKey:kQBVideoChatFrameQualityPreset];
	[videoChatConfiguration setObject:@7 forKey:kQBVideoChatVideoFramesPerSecond];
	[videoChatConfiguration setObject:@3 forKey:kQBVideoChatP2PTimeout];
	[QBSettings setVideoChatConfiguration:videoChatConfiguration];
	
	//sandbox of deepak account
	[QBConnection setAutoCreateSessionEnabled:YES];
	
	//sandbox
	[PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox:@"Ad9DFjDeBHrKnYhjImpgl6yaKzuSMY-Tfpks_eQrmDi8MG4CSnU8qTnCpBrEebgY3j-WCpZXTrCUx8cP"}];
	
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
    
    [UAirship takeOff];
    [UAirship push].userPushNotificationsEnabled = YES;

    [UAirship push].pushNotificationDelegate = self;
    
    NSString *channelId = [UAirship push].channelID;
    NSLog(@"My Application Channel ID: %@", channelId);
    
	
	// For push notifications
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
	{
		//ios8 ++
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
		{
			UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
			[[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
		}
	}
	else
	{
		// ios7
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotificationTypes:)])
		{
			// [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
		}
	}
	
	
	[Fabric with:@[CrashlyticsKit]];
	
	[[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
	// self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"myImage.png"];
	[[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
											 forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
											 forState:UIControlStateSelected];
	//blueImage
	
	if (IS_IPHONE_5)
	{
		//        UIImage *BlueBackground = [UIImage imageNamed:@"blueImage"];
		
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
		//        UIImage *BlueBackground = [UIImage imageNamed:@"BlueBackground"];
		
		UIImage *BlueBackground = [UIImage imageNamed:@"blueImage2"];
		[[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
	}
	
	
	//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2F]];
	
	
	//    [[UINavigationBar appearance] setBarTintColor:[UIColor lightGrayColor]];
	//     [UINavigationBar appearance].translucent = YES;
	//    [[UINavigationBar appearance] setAlpha:0.5];
	 
	//    UIImage *BlueBackground = [UIImage imageNamed:@"BlueBackground"];
	//    [[UINavigationBar appearance] setBackgroundImage:BlueBackground forBarMetrics:UIBarMetricsDefault];
	//    //[UINavigationBar appearance].shadowImage = BlueBackground;
	// [UINavigationBar appearance].translucent = YES;
	//
	
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
	NSLog(@"%@",token);
	[[NSUserDefaults standardUserDefaults] setValue:token forKey:@"DeviceToken"];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"I am here");
	NSString *userType = [SharedSingleton sharedClient].user_Profile.userType;
	
	if ([userType isEqualToString:@"lawyer"])
	{
		if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"Approve to Receive Contact Info"])
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ApproveContactRequestFromClient" object:nil userInfo:userInfo];
			
			return;
		}
		else if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"a client Wants to talk to You"])
		{
			QuestionAnsArray=[[NSMutableArray alloc] init];
			QuestionAnsArray=[[[userInfo valueForKey:@"token"] valueForKey:@"questionare"] mutableCopy];
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"LegalTap Client Ready! Please respond!" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			alert.tag=1;
			[alert show];
            
			startTime=88;
			CountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
															  target: self
															selector:@selector(CountDownTimer)
															userInfo: nil repeats:YES];
			
			ClientIdFromNotif=[[userInfo valueForKey:@"token"] valueForKey:@"userId"];
			quickBloxId=[[userInfo valueForKey:@"token"] valueForKey:@"quickBloxId"];
			quickBloxUsername=[[userInfo valueForKey:@"token"] valueForKey:@"quickBloxUserName"];
			Username=[[userInfo valueForKey:@"token"] valueForKey:@"username"];
			
			// [self AddAcceptRejectView];
		}
	}
    
	else
	{
		
		if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] isEqualToString:@"Approve Form Request"])
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ApproveFormRequestFromUser" object:nil userInfo:userInfo];
			return;
		}
		
		NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
		
		if ([message isEqualToString:@"Lawyer Accepted your call"])
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"YesFromLaywer" object:nil userInfo:userInfo];
		}
		else
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"NoFromLaywer" object:nil userInfo:userInfo];
		}
	}
    
   
	
	// Handle your remote RemoteNotification
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
	[NotifView addSubview:questionAnsView];
	
	//NameLabel
	UILabel *NameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 100, 30)];
	[NotifView addSubview:NameLbl];
	NameLbl.text = @"Username:";
	NameLbl.textColor = [UIColor blackColor];
	// NameLbl.textAlignment = UITextAlignmentLeft;
	NameLbl.textAlignment=NSTextAlignmentLeft;
	
	//NameLabel1
	UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(100, 105, 190, 30)];
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
			[NotifView removeFromSuperview];
			call=NO;
			[self CallResponseToClient:ClientIdFromNotif andWithResponse:@"no"];
			
			startTime=0;
			[CountDownTimer invalidate];
			
			
		}
		else if (buttonIndex==1)
		{
			// call=YES;
			// [self CallResponseToClient:ClientIdFromNotif andWithResponse:@"yes"];
			
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
	
	//    // Show Main controller
	//    MainViewController *MainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
	//    {
	//        if (_app && _app.userQuickBloxId.length)
	//        {
	//            NSNumber *num = [NSNumber numberWithLongLong:_app.userQuickBloxId.longLongValue];
	//            MainVC.opponentID = num;
	//        }
	//        else
	//        {
	//            // MainVC.opponentID = appDelegate.currentUser == 1 ? appDelegate.testOpponents[5] : appDelegate.testOpponents[2];
	//        }
	//    }
	//    MainVC.ComingFromSide=@"Lawyer Side";
	//
	//    [self.navigationController.tabBarController.navigationController pushViewController:MainVC animated:YES];
	
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
	
	//    @try
	//    {
	//        [[NSNotificationCenter defaultCenter] postNotificationName:defApplicationWillTerminate object:nil];
	//    }
	//    @catch (NSException *exception)
	//    {}
	//    @finally {}
	
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
