//
//  VideoCallingViewController.m
//  LegalTap
//
//  Created by Vikram on 23/03/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "VideoCallingViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface VideoCallingViewController ()
@property (copy, nonatomic) void(^chatConnectCompletionBlock)(BOOL error);
@property (copy, nonatomic) dispatch_block_t chatDisconnectedBlock;
@property (copy, nonatomic) dispatch_block_t chatReconnectedBlock;
@end

@implementation VideoCallingViewController
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginAsUser1:(id)sender
{
    /*
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.currentUser = 1;
    
    // Your app connects to QuickBlox server here.
    //
    // Create extended session request with user authorization
    //
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = appDelegate.testOpponents[0];
    parameters.userPassword = appDelegate.testOpponents[1];
    
    // QuickBlox session creation
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session)
    {
        [self loginToChat:session];
        
    } errorBlock:[self handleError]];
    
    [activityIndicator startAnimating];
    
    loginAsUser1Button.enabled = NO;
    loginAsUser2Button.enabled = NO;
     */
}

- (IBAction)loginAsUser2:(id)sender
{
    /*
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.currentUser = 2;
    
    // Your app connects to QuickBlox server here.
    //
    // Create extended session request with user authorization
    //
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = appDelegate.testOpponents[3];
    parameters.userPassword = appDelegate.testOpponents[4];
    
    // QuickBlox session creation
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session)
    {
        [self loginToChat:session];
        
    } errorBlock:[self handleError]];
    
    [activityIndicator startAnimating];
    
    loginAsUser1Button.enabled = NO;
    loginAsUser2Button.enabled = NO;
     */
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
        // NSLog(@"error");
        
    }];
}


- (void(^)(QBResponse *))handleError
{
    return ^(QBResponse *response)
    {
        loginAsUser1Button.enabled = YES;
        loginAsUser2Button.enabled = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                        message:[response.error description]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", "")
                                              otherButtonTitles:nil];
        [alert show];
    };
}

- (void)loginToChat:(QBASession *)session
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Set QuickBlox Chat delegate
    //
    [[QBChat instance] addDelegate:self];
    
    QBUUser *user = [QBUUser user];
    user.ID = session.userID;
    user.password = appDelegate.currentUser == 1 ? appDelegate.testOpponents[1] : appDelegate.testOpponents[4];
    
    // Login to QuickBlox Chat
    //
    //b[[QBChat instance] loginWithUser:user];
}
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
        NSLog(@"connect");
        
        if (!error) {
           // [weakSelf applyConfiguration];
            
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
    
    //[self createSeesionForClientwithUserName:qUserName withUserPassword:qPassword];
}



#pragma mark -
#pragma mark QBChatDelegate

- (void)chatDidConnect
{
    // Show Main controller
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainViewController *MainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    MainVC.opponentID = appDelegate.currentUser == 1 ? appDelegate.testOpponents[5] : appDelegate.testOpponents[2];
//    [self presentViewController:MainVC animated:YES completion:nil];
     [self.navigationController pushViewController:MainVC animated:YES];

    
  //  MainViewController *MainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
   // [self.navigationController pushViewController:MainVC animated:YES];
}
- (void)session:(QBRTCSession *)session initializedLocalMediaStream:(QBRTCMediaStream *)mediaStream {
    
    NSLog(@"Initialized local media stream %@", mediaStream);
}

- (void)chatDidNotConnectWithError{
    loginAsUser1Button.enabled = YES;
    loginAsUser2Button.enabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


@end
