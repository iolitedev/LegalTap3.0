//
//  MainViewController.m
//  LegalTap
//
//  Created by Vikram on 23/03/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "CaptureSessionManager.h"
#import "OpponentVideoWriter.h"
#import "MTBlockAlertView.h"
#import "FeedbackToLawyerViewController.h"
#import "FormPortalViewController.h"
#define kPayPalEnvironment PayPalEnvironmentSandbox

//#import <MediaPlayer/MediaPlayer.h>


#define VideoRecordingMode 2  // 1 is to record own video, 2 is to record opponent's video



@interface MainViewController ()

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payFutureButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;


@property (nonatomic) CaptureSessionManager *captureSessionManager;
@property (nonatomic) OpponentVideoWriter *opponentVideoWriter;


@end

@implementation MainViewController

@synthesize opponentID;
@synthesize ComingFromSide,UserIdFromAppointmentView,ComingFromApprovelView;

- (void)viewDidLoad
{
    
    EnableVideo=YES;
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"ApproveContactRequestFromClient"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification1:)
                                                 name:@"ApproveFormRequestFromUser"
                                               object:nil];
    flag=1;
    flag1=2;
    chatFinished=NO;
    blurView.blurRadius = 8.0;
    blurView.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    
    [self setUserImage];
    
    IsMicroPhoneEnabled = YES;
    
    if(!QB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        audioOutput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        audioOutput.frame = CGRectMake(audioOutput.frame.origin.x-15, audioOutput.frame.origin.y, audioOutput.frame.size.width+50, audioOutput.frame.size.height);
        videoOutput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    }
    
    // Setup Video & Audio capture
    //
    _captureSessionManager = [CaptureSessionManager new];
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [_captureSessionManager setupVideoCapture];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    CGRect layerRect = [[myVideoView layer] bounds];
    [videoPreviewLayer setBounds:layerRect];
    [videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    myVideoView.hidden = NO;
    
    [myVideoView.layer addSublayer:videoPreviewLayer];
    //
    //
    [_captureSessionManager setupAudioCapture];
    
    
    // Setup Own video writer
    //
    _opponentVideoWriter = [OpponentVideoWriter new];
    
    
    // Set output blocks
    //
    __weak typeof(self) weakSelf = self;
    _captureSessionManager.audioOutputBlock = ^(AudioBuffer buffer)
    {
        // forward audio data to video chat
        //
        [weakSelf.videoChat processVideoChatCaptureAudioBuffer:buffer];
    };
    _captureSessionManager.videoOutputBlock = ^(CMSampleBufferRef buffer){
        // forward video data to video chat
        //
        [weakSelf.videoChat processVideoChatCaptureVideoSample:buffer];
    };
    
    
    // Start sending chat presence
    [[QBChat instance] addDelegate:self];
    [NSTimer scheduledTimerWithTimeInterval:30 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
    
    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    {
        [self startVideoChat];
        RecommendForm.hidden=NO;
        SendCntctInfo.hidden=YES;
        AcceptRejectView.hidden=YES;
        
    }
    else
    {
        AcceptRejectView.hidden=NO;
        RecommendForm.hidden=YES;
        SendCntctInfo.hidden=NO;
        [self GetPaymentMethod];
        sleep(3);
        
        [TimeLeftLabel setText:@"Time Left : 15:00"];
        currMinute=15;
        currSeconds=00;
        [self start];
    }
    
    
    [QBRTCClient.instance addDelegate:self];
    
    //    // Set answer time interval
    //    [QBRTCConfig setAnswerTimeInterval:60];
    //    // Set dialing time interval
    //    [QBRTCConfig setDialingTimeInterval:5];
    //    // Set disconnect time interval
    //    [QBRTCConfig setDisconnectTimeInterval:15];
    // Enable DTLS (Datagram Transport Layer Security)
    [QBRTCConfig setDTLSEnabled:YES];
    
    // Set custom ICE servers
    NSURL *stunUrl = [NSURL URLWithString:@"stun:turn.quickblox.com"];
    QBICEServer *stunServer =
    [QBICEServer serverWithURL:stunUrl username:@"quickblox" password:@"baccb97ba2d92d71e26eb9886da5f1e0"];
    
    NSURL *turnUDPUrl = [NSURL URLWithString:@"turn:turn.quickblox.com:3478?transport=udp"];
    QBICEServer *turnUDPServer =
    [QBICEServer serverWithURL:turnUDPUrl username:@"quickblox" password:@"baccb97ba2d92d71e26eb9886da5f1e0"];
    
    NSURL *turnTCPUrl = [NSURL URLWithString:@"turn:turn.quickblox.com:3478?transport=tcp"];
    QBICEServer* turnTCPServer =
    [QBICEServer serverWithURL:turnTCPUrl username:@"quickblox" password:@"baccb97ba2d92d71e26eb9886da5f1e0"];
    
    [QBRTCConfig setICEServers:@[stunServer, turnUDPServer, turnTCPServer]];}


-(void)start
{
    timerLeft=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [TimeLeftLabel setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time Left : ",currMinute,@":",currSeconds]];
    }
    else
    {
        [self finishVideoChat];
        [timerLeft invalidate];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [timerLeft invalidate];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
    
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"%@",userInfo);
    
    UserIdFromNotif=[[userInfo valueForKey:@"token"] valueForKey:@"userId"];
    LawyerIdFromNotif=[[userInfo valueForKey:@"token"] valueForKey:@"lawyerId"];
    
    
    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]
                                                       delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
        alert.tag=11;
        [alert show];
        
    }
}
- (void) receiveTestNotification1:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
    
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"%@",userInfo);
    
    //    UserIdFromNotif=[[userInfo valueForKey:@"token"] valueForKey:@"userId"];
    //    LawyerIdFromNotif=[[userInfo valueForKey:@"token"] valueForKey:@"lawyerId"];
    //
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Lawyer would like to recommend a form. Do you approve?"
                                                   delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    alert.tag=12;
    [alert show];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    // [self setPayPalEnvironment:self.environment];
    
}
- (void)setPayPalEnvironment:(NSString *)environment
{
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

-(void)LetsPayWithPaypal
{
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Fare"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"40"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"LegalTap";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable)
    {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success!");
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setValue:@"Success" forKey:@"Payment"];
    //    [self.navigationController popViewControllerAnimated:NO];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@"PayPal Payment Canceled");
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment
{
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    // TransactionId=[[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"];
    
    FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
    FeedbackVc.LawyerQuickBloxId=[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID];
    [self.navigationController pushViewController:FeedbackVc animated:YES];
    if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)])
    {
        [_delegate MainViewControllerDidEndCall];
    }
}

#pragma mark - Helpers

- (void)showSuccess
{
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)viewDidAppear:(BOOL)animated
{
    //   [super viewDidAppear:animated];
    
    //    // Start sending chat presence
    //    [[QBChat instance] addDelegate:self];
    //    [NSTimer scheduledTimerWithTimeInterval:30 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
    //
    //    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    //    {
    //        [self startVideoChat];
    //        RecommendForm.hidden=NO;
    //        SendCntctInfo.hidden=YES;
    //    }
    //    else
    //    {
    //        AcceptRejectView.hidden=NO;
    //        RecommendForm.hidden=YES;
    //        SendCntctInfo.hidden=NO;
    //    }
}

#pragma mark -

-(void)setUserImage
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *strUrl = user_Profile.imageURL;
    if (user_Profile.image)
    {
        imageViw_CallBG.image = user_Profile.image;
        RoundUserImage.image = user_Profile.image;
    }
    else
    {
        if(![strUrl isEqualToString:@""])
        {
            NSString *imgStr = strUrl;
            
            NSURL *url = [NSURL URLWithString:imgStr];
            NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@"image_placeholder"];
            
            __weak UIImageView *weakCell = imageViw_CallBG;
            
            
            [weakCell setImageWithURLRequest:request1
                            placeholderImage:placeholderImage
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 
                 weakCell.image = image;
                 imageViw_CallBG.image = image;
                 RoundUserImage.image = image;
                 [weakCell setNeedsLayout];
                 
             } failure:nil];
        }
    }
}

#pragma mark Actions

//- (IBAction)changeRecordingSwitch:(id)sender
//{
//    // Enable/disable recording of own video
//    //
//    if(VideoRecordingMode == 1)
//    {//        // Enable/disable recording of opponent's video
//        //
//    }else{
//        _captureSessionManager.enabledRecording = [sender isOn];
//

//        if([sender isOn]){
//            __weak typeof(_opponentVideoWriter) weakWriter = _opponentVideoWriter;
//            opponentVideoView.opponentVideoViewCallbackBlock = ^(id data){
//                [weakWriter writeVideoData:(CGImageRef)data];
//            };
//        }else{
//            opponentVideoView.opponentVideoViewCallbackBlock = nil;
//
//            __weak typeof(self) weakSelf = self;
//            [_opponentVideoWriter finishWithCompletionBlock:^(NSURL *videoFileUrl) {
//
//                [MTBlockAlertView showWithTitle:nil
//                                        message:@"Would you like to watch the recorded video?"
//                              cancelButtonTitle:@"No"
//                               otherButtonTitle:@"Yes"
//                                 alertViewStyle:UIAlertViewStyleDefault
//                                completionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                                    // Yes
//                                    if (buttonIndex == 1) {
//                                        //  MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:videoFileUrl];
//
//                                        // Present the movie player view controller
//                                        // [weakSelf presentViewController:playerVC animated:YES completion:nil];
//
//
//                                        // stop video chat
//                                        [weakSelf finishVideoChat];
//                                    }
//                                }];
//
//            }];
//        }
//    }
//}

//- (IBAction)audioOutputDidChange:(UISegmentedControl *)sender
//{
//    if(sender.selectedSegmentIndex == 0){
//        [[QBAudioIOService shared] routeToSpeaker];
//    }else{
//        [[QBAudioIOService shared] routeToHeadphone];
//    }
//}

- (IBAction)videoOutputDidChange:(UISegmentedControl *)sender
{
    [_captureSessionManager changeVideoOutput:sender.selectedSegmentIndex != 0];
}

- (IBAction)EnableDisableVideo:(id)sender
{
    if (EnableVideo==YES)
    {
        //hide video here
        [enableDisableVideoBtn setImage:[UIImage imageNamed:@"VideoOff"] forState:UIControlStateNormal];
        opponentVideoView.hidden=YES;
        EnableVideo=NO;
        myVideoView.hidden=YES;
        
        
        __weak typeof(self) weakSelf = self;
        _captureSessionManager.audioOutputBlock = ^(AudioBuffer buffer)
        {
            // forward audio data to video chat
            //
            [weakSelf.videoChat processVideoChatCaptureAudioBuffer:buffer];
        };
        _captureSessionManager.videoOutputBlock = ^(CMSampleBufferRef buffer){
            // forward video data to video chat
            //
            [weakSelf.videoChat processVideoChatCaptureVideoSample:nil];
        };
        
    }
    else
    {
        //show video here
        [enableDisableVideoBtn setImage:[UIImage imageNamed:@"VideoOn"] forState:UIControlStateNormal];
        opponentVideoView.hidden=NO;
        EnableVideo=YES;
        myVideoView.hidden=NO;
        
        __weak typeof(self) weakSelf = self;
        _captureSessionManager.audioOutputBlock = ^(AudioBuffer buffer)
        {
            // forward audio data to video chat
            ////
            [weakSelf.videoChat processVideoChatCaptureAudioBuffer:buffer];
        };
        _captureSessionManager.videoOutputBlock = ^(CMSampleBufferRef buffer)
        {
            // forward video data to video chat
            //
            [weakSelf.videoChat processVideoChatCaptureVideoSample:buffer];
        };
    }
}

- (IBAction)call:(id)sender
{
    [timerLeft invalidate];
    
    // Call
        if(callButton.tag == 101){
    //        [self startVideoChat];
    
            // Finish
        }else{
    [self finishVideoChat];
        }
    
}

- (void)startVideoChat
{
    callButton.tag = 102;
    
    //  Setup video chat
    
    if(self.videoChat == nil){
        self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstance];
        self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
        self.videoChat.viewToRenderOwnVideoStream = myVideoView;
    }
    
    // setup custom captures
    //
    self.videoChat.isUseCustomAudioChatSession = YES;
    self.videoChat.isUseCustomVideoChatCaptureSession = YES;
    
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
    NSMutableArray *marr=[[NSMutableArray alloc] init];
    [marr addObject:qUserName];
    [marr addObject:qPassword];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:qUserName forKey:@"username"];
    [dict setObject:qPassword forKey:@"password"];
    
    
    
    // Call user by ID
    //
    
    
    NSLog(@"///%@",[NSArray arrayWithObject:opponentID]);
    NSLog(@"++++++%@",dict);
    
    //
    //   [QBRTCClient.instance addDelegate:self];
    //
    //
    //    QBRTCSession *session =
    //    [QBRTCClient.instance createNewSessionWithOpponents:[NSArray arrayWithObject:opponentID]  withConferenceType:QBConferenceTypeVideo];
    //
    //    if (session) {
    //
    //        self.session = session;
    //
    //    }
    //    NSLog(@".....%@",self.session);
    //
    
    NSLog(@"video chat is is %lu",(unsigned long)videoChatOpponentID);
    NSLog(@"opponent id id %@",opponentID);
    //start call
    
    //[QBRTCClient.instance addDelegate:self];
    
    //  [session startCall:dict];
    
    
    [self.videoChat callUser:[opponentID integerValue] conferenceType:QBVideoChatConferenceTypeAudioAndVideo];
    
    //  QBRTCSession *newSession = [QBRTCClient.instance createNewSessionWithOpponents:[NSArray arrayWithObject:opponentID]
    //                                                         withConferenceType:QBConferenceTypeVideo];
    //    // userInfo - the custom user information dictionary for the call. May be nil.
    //  //  NSDictionary *userInfo = @{ @"key" : @"value" };
    //
    
    
    
    // callButton.hidden = YES;
    ringigngLabel.hidden = NO;
    ringigngLabel.text = @"Calling...";
    ringigngLabel.frame = CGRectMake(128, 375, 90, 37);
    callingActivityIndicator.hidden = NO;
    [callingActivityIndicator startAnimating];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}





-(void)MicroPhoneIsEnabledOrNot
{
    if (IsMicroPhoneEnabled==YES)
    {
        self.videoChat.microphoneEnabled=NO;
        IsMicroPhoneEnabled=NO;
        [MuteUnmuteBtn setImage:[UIImage imageNamed:@"MicroPhone_Disabled"] forState:UIControlStateNormal];
        // [MuteUnmuteBtn setTitle:@"UnMute" forState:UIControlStateNormal];
    }
    else
    {
        self.videoChat.microphoneEnabled=YES;
        IsMicroPhoneEnabled=YES;
        [MuteUnmuteBtn setImage:[UIImage imageNamed:@"MicroPhone_Enabled"] forState:UIControlStateNormal];
        //  [MuteUnmuteBtn setTitle:@"Mute" forState:UIControlStateNormal];
    }
}

- (void)finishVideoChat
{
    callButton.tag = 101;
    // Finish call
    //
    [self.videoChat finishCall];
    
    myVideoView.hidden = YES;
    opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
    //  opponentVideoView.image = [UIImage imageNamed:@"person.png"];
    // AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    [callButton setTitle:appDelegate.currentUser == 1 ? @"Call User2" : @"Call User1" forState:UIControlStateNormal];
    
    //    opponentVideoView.layer.borderWidth = 1;
    
    [startingCallActivityIndicator stopAnimating];
    
    
    // release video chat
    //
    [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
    self.videoChat = nil;
    
    
    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        // [[QBChat instance] logout];
    }
    else
    {
        chatFinished=YES;
        
        //Push to feedback screen
        
        NSLog(@"2222222222222222222222222");
        
        
        //        NSString *CardStatus=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PaymentType"]];
        //
        //        if ([CardStatus isEqualToString:@"0"])
        //        {
        //            [self PaymentThroughPaypal];
        //        }
        //
        //        else if ([CardStatus isEqualToString:@"1"])
        //        {
        //            [self DirectPayment];
        //        }
        //        else
        //        {
        //            [self PaymentThroughCoupons];
        //        }
        
        if ([PaymentMethod isEqualToString:@"Skip"])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Select Payment Method First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if ([PaymentMethod isEqualToString:@"Card"])
        {
            [self DirectPayment];
        }
        else if ([PaymentMethod isEqualToString:@"Paypal"])
        {
            [self PaymentThroughPaypal];
        }
        else if ([PaymentMethod isEqualToString:@"Cupon"])
        {
            [self PaymentThroughCoupons];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        //
        //
        //        FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
        //        FeedbackVc.LawyerQuickBloxId=[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID];
        //        [self.navigationController pushViewController:FeedbackVc animated:YES];
        //
        //
        //
        //        if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)])
        //        {
        //            [_delegate MainViewControllerDidEndCall];
        //        }
    }
}

- (void)reject
{
    // Reject call
    //
    if(self.videoChat == nil)
    {
        self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:sessionID];
    }
    [self.videoChat rejectCallWithOpponentID:videoChatOpponentID];
    //
    //
    [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
    self.videoChat = nil;
    
    // update UI
    //  callButton.hidden = NO;
    ringigngLabel.hidden = YES;
    
    // release player
    ringingPlayer = nil;
    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        // [[QBChat instance] logout];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)])
        {
            [_delegate MainViewControllerDidEndCall];
        }
    }
}

- (void)accept
{
    NSLog(@"accept");
    
    
    //    // Setup video chat
    //
    if(self.videoChat == nil)
    {
        self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:sessionID];
        self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
        self.videoChat.viewToRenderOwnVideoStream = myVideoView;
    }
    
    // setup custom capture
    //
    self.videoChat.isUseCustomAudioChatSession = YES;
    self.videoChat.isUseCustomVideoChatCaptureSession = YES;
    
    //   Accept call
    
    
    
    // NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID] forKey:@"ID"];
    // [self.session acceptCall:nil];
    [self.videoChat acceptCallWithOpponentID:videoChatOpponentID conferenceType:videoChatConferenceType];
    
    ringigngLabel.hidden = YES;
    //  callButton.hidden = NO;
    //    [callButton setTitle:@"Hang up" forState:UIControlStateNormal];
    callButton.tag = 102;
    
    opponentVideoView.layer.borderWidth = 0;
    
    [startingCallActivityIndicator startAnimating];
    
    myVideoView.hidden = NO;
    
    ringingPlayer = nil;
}

- (IBAction)EndCallButton:(id)sender
{
    [timerLeft invalidate];
    
    badConnection=NO;
    
    if ([ComingFromApprovelView isEqualToString:@"Yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"reject" forKey:@"call"];
    }
    else
    {
    }
    
    [self reject];
    AcceptRejectView.hidden=YES;}

- (IBAction)AnswerButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"accept" forKey:@"call"];
    
    [self accept];
    
    
    
    AcceptRejectView.hidden=YES;
    
}

- (IBAction)MuteUnmuteButtonAction:(id)sender
{
    [self MicroPhoneIsEnabledOrNot];
}

- (IBAction)SendContactInfo:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Do you Want to Send Contact Details To Lawyer?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=5;
    [alert show];
}

- (IBAction)RecommendFormBtnAction:(id)sender
{
    //    FormPortalViewController *FormPortalVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FormPortal"];
    //    FormPortalVc.ComingFrom=@"CallView";
    //    [self.navigationController pushViewController:FormPortalVc animated:YES];
    [self AskFromUserAboutRecommndForm];
}

- (void)hideCallAlert
{
    [self.callAlert dismissWithClickedButtonIndex:-1 animated:YES];
    self.callAlert = nil;
    // callButton.hidden = NO;
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    ringingPlayer = nil;
}
-(void)GetLawyerDetailWithQuickBloxId:(NSString *)lawyerQuickBloxId
{
    //  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper LawyerDetailWithQuickBloxId:lawyerQuickBloxId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     //  NSString *UserName=[[responseObject valueForKey:@"data"] valueForKey:@"firstName"];
                     
                     //  NSString *imageUrl=[[responseObject valueForKey:@"data"] valueForKey:@"userImage"];
                     
                     LawyerId=[[responseObject valueForKey:@"data"] valueForKey:@"id"];
                     
                     
                 }
                 else
                 {
                     //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //  message:@"Try Again."
                     //  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     // [alert show];
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

-(void)SendContactdetailsToLawyer
{
    //    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    //    NSString *UserId=user_Profile.userId;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper SendContactDetailsToLawyer:UserIdFromNotif withLawyerId:LawyerIdFromNotif andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Your Request for Contact Detail has been Sent to Admin." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 else
                 {
                     //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //  message:@"Try Again."
                     //  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     // [alert show];
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

#pragma mark -
#pragma mark QBChatDelegate
//
// VideoChat delegate
-(void)ShowAcceptCallView
{
    [newIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    
}

-(void) chatDidReceiveCallRequestFromUser:(NSUInteger)userID withSessionID:(NSString *)_sessionID conferenceType:(enum QBVideoChatConferenceType)conferenceType
{
    if (flag1==2)
    {
        flag1=3;
        
        //        [newIndicator startAnimating];
        //        [self.view setUserInteractionEnabled:NO];
        //        timer = [NSTimer scheduledTimerWithTimeInterval:2
        //                                                 target: self
        //                                               selector:@selector(ShowAcceptCallView)
        //                                               userInfo: nil repeats:NO];
        
        NSLog(@"chatDidReceiveCallRequestFromUser %lu", (unsigned long)userID);
        
        // play call music
        //
        if(ringingPlayer == nil)
        {
            NSString *path =[[NSBundle mainBundle] pathForResource:@"ringing" ofType:@"wav"];
            NSURL *url = [NSURL fileURLWithPath:path];
            ringingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
            ringingPlayer.delegate = self;
            [ringingPlayer setVolume:1.0];
            [ringingPlayer play];
        }
        
        
        // save  opponent data
        videoChatOpponentID = userID;
        videoChatConferenceType = conferenceType;
        sessionID = _sessionID;
        
        // if (flag1==2)
        // {
        // flag1=3;
        
        // }
        [self GetLawyerDetailWithQuickBloxId:[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID]];
        
        
        //  callButton.hidden = YES;
        
        // show call alert
        //
        if (self.callAlert == nil)
        {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *message = [NSString stringWithFormat:@"%@ is calling. Would you like to answer?", appDelegate.currentUser == 1 ? @"User 2" : @"User 1"];
            self.callAlert = [[UIAlertView alloc] initWithTitle:@"Call" message:message delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
            //[self.callAlert show];
            if ([ComingFromSide isEqualToString:@"Lawyer Side"])
            {
                AcceptRejectView.hidden=YES;
                
            }
            else
            {
                AcceptRejectView.hidden=NO;
                
            }
            
            [[QBAudioIOService shared] routeToSpeaker];
        }
        
        // hide call alert if opponent has canceled call
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideCallAlert) object:nil];
        [self performSelector:@selector(hideCallAlert) withObject:nil afterDelay:4];
        
        //    // play call music
        //    //
        //    if(ringingPlayer == nil){
        //        NSString *path =[[NSBundle mainBundle] pathForResource:@"ringing" ofType:@"wav"];
        //        NSURL *url = [NSURL fileURLWithPath:path];
        //        ringingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        //        ringingPlayer.delegate = self;
        //        [ringingPlayer setVolume:1.0];
        //        [ringingPlayer play];
        //    }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }
    
}

-(void) chatCallUserDidNotAnswer:(NSUInteger)userID
{
    NSLog(@"chatCallUserDidNotAnswer %lu", (unsigned long)userID);
    //  callButton.hidden = NO;
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    callButton.tag = 101;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"user isn't answering, Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

-(void) chatCallDidRejectByUser:(NSUInteger)userID
{
    NSLog(@"chatCallDidRejectByUser %lu", (unsigned long)userID);
    
    // callButton.hidden = NO;
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    
    callButton.tag = 101;
    
    UIAlertView *alert;
    if (badConnection==YES)
        alert= [[UIAlertView alloc] initWithTitle:@"" message:@"User has rejected your call." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    else
        alert= [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Lost." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 * Called in case when you are calling to user, but he hasn't answered
 */
- (void)session:(QBRTCSession *)session userDoesNotRespond:(NSNumber *)userID {
    
    NSLog(@"userDoesNotRespond");
    
}

- (void)session:(QBRTCSession *)session acceptByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    NSLog(@"acceptByUser");
    
}

/**
 * Called in case when opponent has rejected you call
 */
- (void)session:(QBRTCSession *)session rejectedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    NSLog(@"rejectedByUser");
    
}

-(void) chatCallDidAcceptByUser:(NSUInteger)userID
{
    NSLog(@"chatCallDidAcceptByUser %lu", (unsigned long)userID);
    
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    
    opponentVideoView.layer.borderWidth = 0;
    
    //  callButton.hidden = NO;
    //    [callButton setTitle:@"Hang up" forState:UIControlStateNormal];
    callButton.tag = 102;
    
    myVideoView.hidden = NO;
    
    [startingCallActivityIndicator startAnimating];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [TimeLeftLabel setText:@"Time Left : 15:00"];
    currMinute=15;
    currSeconds=00;
    [self start];
    
    
}

-(void) chatCallDidStopByUser:(NSUInteger)userID status:(NSString *)status
{
    NSLog(@"chatCallDidStopByUser %lu purpose %@", (unsigned long)userID, status);
    if([status isEqualToString:kStopVideoChatCallStatus_OpponentDidNotAnswer])
    {
        
        self.callAlert.delegate = nil;
        [self.callAlert dismissWithClickedButtonIndex:0 animated:YES];
        self.callAlert = nil;
        
        ringigngLabel.hidden = YES;
        
        ringingPlayer = nil;
        
    }
    //kStopVideoChatCallStatus_Manually
    
    else if([status isEqualToString:kStopVideoChatCallStatus_BadConnection]||[status isEqualToString:kStopVideoChatCallStatus_Manually])
    {
        badConnection=YES;
        
        NSLog(@"kStopVideoChatCallStatus_BadConnection/////");
        if ([ComingFromApprovelView isEqualToString:@"Yes"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"reject" forKey:@"call"];
        }
        
        
        if ([ComingFromSide isEqualToString:@"Lawyer Side"])
        {
            [self finishVideoChat];
        }
        
        myVideoView.hidden = YES;
        opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
        callButton.tag = 101;
        AcceptRejectView.hidden=YES;
        
        
    }
    else{
        
        myVideoView.hidden = YES;
        opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
        //        opponentVideoView.layer.borderWidth = 1;
        //        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //        [callButton setTitle:appDelegate.currentUser == 1 ? @"Call User2" : @"Call User1" forState:UIControlStateNormal];
        callButton.tag = 101;
        if ([ComingFromApprovelView isEqualToString:@"Yes"])
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"reject" forKey:@"call"];
        }
        else
        {
        }
        
        //  [self reject];
        AcceptRejectView.hidden=YES;

    }
    
    //  callButton.hidden = NO;
    
    // release video chat
    //
    [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
    self.videoChat = nil;
    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    {
        NSArray *aRR=[self.navigationController viewControllers];
        
        NSLog(@"arr is%@ ",aRR);
        [self.navigationController popToViewController:[aRR lastObject] animated:YES];        //[[QBChat instance] logout];
    }
    else
    {
        //Push to feedback screen
        if (chatFinished==NO) {
            
            if (flag==1)
            {
                flag=0;
                NSLog(@"111111111111111111111111");
                
                if ([PaymentMethod isEqualToString:@"Skip"])
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Select Payment Method First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                else if ([PaymentMethod isEqualToString:@"Card"])
                {
                    [self DirectPayment];
                }
                else if ([PaymentMethod isEqualToString:@"Paypal"])
                {
                    [self PaymentThroughPaypal];
                }
                else if ([PaymentMethod isEqualToString:@"Cupon"])
                {
                    [self PaymentThroughCoupons];
                    
                }
            }
            //
            //        FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
            //        FeedbackVc.LawyerQuickBloxId=[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID];
            //        [self.navigationController pushViewController:FeedbackVc animated:YES];
            //        if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)])
            //        {
            //            [_delegate MainViewControllerDidEndCall];
            //        }
            
            //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }
    
}

- (void)chatCallDidStartWithUser:(NSUInteger)userID sessionID:(NSString *)sessionID{
    
    [startingCallActivityIndicator stopAnimating];
}

- (void)didStartUseTURNForVideoChat{
    //    NSLog(@"_____TURN_____TURN_____");
}

- (void)didReceiveAudioBuffer:(AudioBuffer)buffer{
    [_captureSessionManager processAudioBuffer:buffer];
}


#pragma mark -
#pragma mark UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==5)
    {
        if (buttonIndex==1)
        {
            //            [self SendContactdetailsToLawyer];
            [self AskFromLawyerToSendContactInfo];
        }
        return;
    }
    if (alertView.tag==11)
    {
        if (buttonIndex==1)
        {
            [self SendContactdetailsToLawyer];
        }
        else if (buttonIndex==0)
        {
            
        }
        return;
    }
    
    if (alertView.tag==12)
    {
        if (buttonIndex==1)
        {
            //Yes form request approved by user
            [self AcceptFormRequestFromLawyer];
            
            
        }
        else if (buttonIndex==0)
        {
            
        }
        return;
    }
    
    // Call alert
    switch (buttonIndex) {
            // Reject
        case 0:
            [self reject];
            break;
            // Accept
        case 1:
            [self accept];
            break;
            
        default:
            break;
    }
    
    self.callAlert = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnClicked_ChangeCamera:(UIButton*)sender
{
    [_captureSessionManager changeVideoOutput:sender.tag == 0];
    
    if (sender.tag == 0)
    {
        sender.tag = 1;
    }
    else
    {
        sender.tag = 0;
    }
}

#pragma marck Hud
-(void)showHud
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideHud
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)PaymentAfterCall
{
    
}
-(void)GetPaymentMethod
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper GetPaymentMethod:userId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     NSLog(@"payment is %@",[responseObject valueForKey:@"data"]);
                     PaymentMethod=[responseObject valueForKey:@"data"];
                 }
                 else
                 {
                     //                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //                                                                     message:@"Please Check Your Account Details For Payment"
                     //                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     //                     [alert show];
                 }
             }
             else
             {
                 //                 //Empty Response
                 //                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 //                 //    NSString *errorMsg = [responseObject valueForKey:@"message"];
                 //                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                 //                                                                 message:@"Please Check Your Account Details For Payment"
                 //                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 //                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //             //Error
             //             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             //             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
             //                                                             message:@"Please Check Your Account Details For Payment"
             //                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             //             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         
     }];
}

-(void)DirectPayment
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //39
    [SignInAndSignUpHelper DirectPayWithCard:userId
                                  withAmount:@"39"
                                    withtype:@"call"
                                  withFormId:@""
                                withBundleId:@""
                                withLawyerId:LawyerId
                      andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
                     FeedbackVc.LawyerQuickBloxId=[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID];
                     [self.navigationController pushViewController:FeedbackVc animated:YES];
                     if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)])
                     {
                         [_delegate MainViewControllerDidEndCall];
                     }
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Please Check Your Account Details For Payment"
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 //    NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Please Check Your Account Details For Payment"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Please Check Your Account Details For Payment"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         
     }];
}
-(void)PaymentThroughPaypal
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //39
    [SignInAndSignUpHelper PayWithPaypal:userId
                              withAmount:@"39"
                                withtype:@"call"
                              withFormId:@""
                            withBundleId:@""
                            withLawyerId:LawyerId
                  andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
                     FeedbackVc.LawyerQuickBloxId=[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID];
                     [self.navigationController pushViewController:FeedbackVc animated:YES];
                     
                     if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)])
                     {
                         [_delegate MainViewControllerDidEndCall];
                         
                     }
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Please Check Your Account Details For Payment"
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 //    NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Please Check Your Account Details For Payment"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             }
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Please Check Your Account Details For Payment"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
         
     }];
}

-(void)PaymentThroughCoupons
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //39
    [SignInAndSignUpHelper PayWithCoupons:userId
                               withAmount:@"39"
                                 withtype:@"call"
                               withFormId:@""
                             withBundleId:@""
                             withLawyerId:LawyerId
                   andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     
                     if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)])
                     {
                         [_delegate MainViewControllerDidEndCall];
                     }
                     
                     FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
                     FeedbackVc.LawyerQuickBloxId=[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID];
                     [self.navigationController pushViewController:FeedbackVc animated:YES];
                     
                     
                     
                     
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Please Check Your Account Details For Payment"
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 //    NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Please Check Your Balance For Payment"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Please Check Your Account Details For Payment"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
         
     }];
}

-(void)callDelegate{
    
    FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
    FeedbackVc.LawyerQuickBloxId=[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID];
    [self.navigationController pushViewController:FeedbackVc animated:YES];
    
    
}
-(void)AskFromLawyerToSendContactInfo
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper AskFromLawyerToSendContactInfo:userId withLawyerId:LawyerId withMessage:@"Approve to Receive Contact Info" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Approvel Sent to Lawyer"
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@""
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 //    NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Error"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Error"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
         
     }];
}
-(void)AskFromUserAboutRecommndForm
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *LawyerId1=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper AskFromUserAboutReccommndForm:UserIdFromAppointmentView withLawyerId:LawyerId1 withMessage:@"Approve Form Request" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Approvel Sent to User"
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@""
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     
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
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Please Check Your Account Details For Payment"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
         
     }];
}
-(void)AcceptFormRequestFromLawyer
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *userId=user_Profile.userId;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper RequestFormRequestFromLawyer:userId withLawyerId:LawyerId withMessage:@"Form Request Approoved By User" withRequest:@"yes" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Your Form Request has been sent to admin for Approovel"
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@""
                                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     
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
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }
             
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Please Check Your Account Details For Payment"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
         
     }];
}

#pragma mark -
#pragma mark QBRTCClientDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    
    NSLog(@"session created");
    if (self.session) {
        // userInfo - the custom user information dictionary for the call from caller. May be nil.
        //   NSDictionary *userInfo = @{ @"key" : @"value" };
        [session rejectCall:nil];
        return;
    }
    self.session = session;
}


#pragma mark -
#pragma mark QBRTCClientDelegate

- (void)session:(QBRTCSession *)session startConnectionToUser:(NSNumber *)userID {
    
    NSLog(@"Begin connect to user %@", userID);
}

#pragma mark -
#pragma mark QBRTCClientDelegate

- (void)session:(QBRTCSession *)session connectedToUser:(NSNumber *)userID {
    
    NSLog(@"Connection with user %@ is established", userID);
}
#pragma mark -
#pragma mark QBRTCClientDelegate

//Called in case when receive remote video track from opponent
- (void)session:(QBRTCSession *)session didReceiveRemoteVideoTrack:(QBRTCVideoTrack *)videoTrack fromUser:(NSNumber *)userID {
    
    NSLog(@"remote video calllll");
    QBUUser *user = [QBUUser user];
    NSNumber *testID = @(user.ID);
    
    
    QBRTCVideoTrack *videoTrackTEST = [self.session remoteVideoTrackWithUserID:testID];
    [opponentVideoView setVideoTrack:videoTrackTEST];
    
    
    
}


//Called in case when receive local video track
- (void)session:(QBRTCSession *)session didReceiveLocalVideoTrack:(QBRTCVideoTrack *)videoTrack {
    NSLog(@"local video callllll");
    
    [myVideoView setVideoTrack:videoTrack];
    
}
#pragma mark -
#pragma mark QBRTCClientDelegate

- (void)session:(QBRTCSession *)session hungUpByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    //For example:Update GUI
    NSLog(@"hungUpByUser");
}

#pragma mark -
#pragma mark QBRTCClientDelegate

- (void)sessionDidClose:(QBRTCSession *)session {
    
    // release session instance
    self.session = nil;
}

- (void)sessionWillClose:(QBRTCSession *)session {
    
}
@end