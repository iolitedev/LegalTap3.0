//
//  AppDelegate.h
//  LegalTap
//
//  Created by John Basile on 7/12/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"
#import "Mixpanel.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    UIAlertView *alert;
	NSString *ClientIdFromNotif;
	NSString *quickBloxId;
	NSString *quickBloxUsername;
	BOOL call;
	UIView *NotifView;
	NSMutableArray *arr;
	NSMutableArray *QuestionAnsArray;
	NSString *Username;
    NSTimer *timer;
	UILabel *Timelabel;
	NSTimer *CountDownTimer;
	int startTime;
    NSString *lawyerType;
	
}
@property (strong, nonatomic) NSString *dateInStringFormated;
@property BOOL isCallEnd;
@property (strong, nonatomic) NSString *str;
@property (strong, nonatomic) NSString *defaultTime;
@property (strong, nonatomic) NSString *terminateUserId;

@property (strong, nonatomic) NSUserDefaults *standardUserDefaults;
@property (strong, nonatomic) UIWindow *window;
@property BOOL isCallStart;
@property BOOL appTerminate;
/* VideoChat test opponents */
@property (strong, nonatomic) NSArray *testOpponents;

/* Current logged in test user*/
@property (assign, nonatomic) int currentUser;

@property (assign, nonatomic) UINavigationController *navigationController;

-(void)CallResponseToClient:(NSString *)ClientId andWithResponse:(NSString *)response;


@end

