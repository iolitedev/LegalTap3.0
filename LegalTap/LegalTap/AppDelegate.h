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
	NSString *ClientIdFromNotif;
	NSString *quickBloxId;
	NSString *quickBloxUsername;
	BOOL call;
	UIView *NotifView;
	NSMutableArray *arr;
	NSMutableArray *QuestionAnsArray;
	NSString *Username;
	
	UILabel *Timelabel;
	NSTimer *CountDownTimer;
	int startTime;
	
}

@property (strong, nonatomic) UIWindow *window;

/* VideoChat test opponents */
@property (strong, nonatomic) NSArray *testOpponents;

/* Current logged in test user*/
@property (assign, nonatomic) int currentUser;

@property (assign, nonatomic) UINavigationController *navigationController;


@end

