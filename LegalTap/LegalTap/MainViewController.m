//
//  MainViewController.m
//  LegalTap
//
//  Created by Vikram on 23/03/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
//#import "CaptureSessionManager.h"
#import "OpponentVideoWriter.h"
#import "MTBlockAlertView.h"
#import "FeedbackToLawyerViewController.h"
#import "FormPortalViewController.h"
#import "Appointment.h"
#import "Settings.h"
#import "MyAppointmentViewController.h"
#import "AppointmentApprovalViewController.h"
#import "QMSoundManager.h"
#import "QBRTCScreenCapture.h"
#define kPayPalEnvironment PayPalEnvironmentSandbox
#import <MediaPlayer/MediaPlayer.h>
#define VideoRecordingMode 2

@interface MainViewController ()

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payFutureButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property (copy, nonatomic) void(^chatConnectCompletionBlock)(BOOL error);
@property (copy, nonatomic) dispatch_block_t chatDisconnectedBlock;
@property (copy, nonatomic) dispatch_block_t chatReconnectedBlock;
@property (strong, nonatomic) QBRTCTimer *presenceTimer;
@property (strong, nonatomic) Settings *settings;
@property (strong, nonatomic)MBProgressHUD *theHud;

@property (assign, nonatomic) NSTimer *beepTimer;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property (nonatomic) OpponentVideoWriter *opponentVideoWriter;


@end

@implementation MainViewController

@synthesize opponentID;
@synthesize ComingFromSide,UserIdFromAppointmentView,ComingFromApprovelView;

- (void)viewDidLoad
{
    EnableVideo=YES;
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    appDelegate.appTerminate = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"ApproveContactRequestFromClient"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification1:)
                                                 name:@"ApproveFormRequestFromUser"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishApp)
                                                 name:@"TerminateApp"
                                               object:nil];
    flag=1;
    flag1=2;
    chatFinished=NO;
    blurView.blurRadius = 8.0;
    blurView.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    
    [self setUserImage];
    
    IsMicroPhoneEnabled = YES;
    
    [QBRTCClient.instance addDelegate:self];
    
    
    // Setup Video output
    AVCaptureVideoDataOutput *videoCaptureOutput = [[AVCaptureVideoDataOutput alloc] init];
    AVCaptureSession *captureSession = [AVCaptureSession new];
    
    // Set the video output to store frame in BGRA (It is supposed to be faster)
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [videoCaptureOutput setVideoSettings:videoSettings];
    /*And we create a capture session*/
    if([captureSession canAddOutput:videoCaptureOutput]){
        [captureSession addOutput:videoCaptureOutput];
        
    }else{
        NSLog(@"cantAddOutput");
    }
    
    /*We create a serial queue to handle the processing of our frames*/
    dispatch_queue_t callbackQueue= dispatch_queue_create("cameraQueue", NULL);
    [videoCaptureOutput setSampleBufferDelegate:self queue:callbackQueue];
    
    // Add preview layer
    AVCaptureVideoPreviewLayer *prewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [prewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CGRect layerRect = [[myVideoView layer] bounds];
    [prewLayer setBounds:layerRect];
    [prewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    myVideoView.hidden = NO;
    [myVideoView.layer addSublayer:prewLayer];
    [captureSession startRunning];
    
    // Setup Own video writer
    
    _opponentVideoWriter = [OpponentVideoWriter new];
    
    QBRTCVideoFormat *videoFormat = [[QBRTCVideoFormat alloc] init];
    videoFormat.frameRate = 30;
    videoFormat.pixelFormat = QBRTCPixelFormat420f;
    videoFormat.width = 640;
    videoFormat.height = 480;
    
    
    // QBRTCCameraCapture class used to capture frames using AVFoundation APIs
    self.videoCapture = [[QBRTCCameraCapture alloc] initWithVideoFormat:videoFormat position:AVCaptureDevicePositionFront];
    self.videoCapture.previewLayer.frame = myVideoView.bounds;
    [self.videoCapture startSession];
    
    
    [myVideoView.layer insertSublayer:self.videoCapture.previewLayer atIndex:0];
    
    [[QBChat instance] addDelegate:self];
    [NSTimer scheduledTimerWithTimeInterval:30 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
    
    if ([ComingFromSide isEqualToString:@"Lawyer Side"]){
        [self startVideoChat:QBRTCConferenceTypeVideo];
        RecommendForm.hidden=YES;
        enableDisableVideoBtn.hidden = YES;
        SendCntctInfo.hidden=YES;
        AcceptRejectView.hidden=true;
    }
    else{
        self.dialignTimer =
        [NSTimer scheduledTimerWithTimeInterval:[QBRTCConfig dialingTimeInterval]
                                         target:self
                                       selector:@selector(dialing:)
                                       userInfo:nil
                                        repeats:YES];
        
        videoChatOpponentID = _videoCallOppId.intValue;
        
        [self getLawyerDetail];
        RecommendForm.hidden=YES;
        SendCntctInfo.hidden=NO;
        [self GetPaymentMethod];
        sleep(3);
        
    }
    
    [QBRTCConfig setDTLSEnabled:YES];
    
    // Set custom ICE servers
    NSURL *stunUrl = [NSURL URLWithString:@"stun:turn.quickblox.com"];
    QBRTCICEServer *stunServer =
    [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"%@",stunUrl] username:@"quickblox" password:@"baccb97ba2d92d71e26eb9886da5f1e0"];
    
    NSURL *turnUDPUrl = [NSURL URLWithString:@"turn:turn.quickblox.com:3478?transport=udp"];
    QBRTCICEServer *turnUDPServer =
    [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"%@",turnUDPUrl] username:@"quickblox" password:@"baccb97ba2d92d71e26eb9886da5f1e0"];
    
    NSURL *turnTCPUrl = [NSURL URLWithString:@"turn:turn.quickblox.com:3478?transport=tcp"];
    QBRTCICEServer* turnTCPServer =
    [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"%@",turnTCPUrl] username:@"quickblox" password:@"baccb97ba2d92d71e26eb9886da5f1e0"];
    
    [QBRTCConfig setICEServers:@[stunServer, turnUDPServer, turnTCPServer]];
}

- (void)dialing:(NSTimer *)timer {
    
    [QMSoundManager playRingtoneSound];
}

-(void)start{
    
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
    
    FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
    [self.navigationController pushViewController:FeedbackVc animated:YES];
    if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)]){
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

- (IBAction)videoOutputDidChange:(UISegmentedControl *)sender
{
}

- (IBAction)EnableDisableVideo:(id)sender
{
    self.session.localMediaStream.audioTrack.enabled = !self.session.localMediaStream.audioTrack.isEnabled;
    self.session.localMediaStream.videoTrack.enabled = !self.session.localMediaStream.videoTrack.isEnabled;
    
    if (EnableVideo==YES)
    {
        //hide video here
        [enableDisableVideoBtn setImage:[UIImage imageNamed:@"VideoOff"] forState:UIControlStateNormal];
        opponentVideoView.hidden=YES;
        EnableVideo=NO;
        myVideoView.hidden=YES;
    }
    else
    {
        //show video here
        [enableDisableVideoBtn setImage:[UIImage imageNamed:@"VideoOn"] forState:UIControlStateNormal];
        opponentVideoView.hidden=NO;
        EnableVideo=YES;
        myVideoView.hidden=NO;
    }
}

- (IBAction)call:(id)sender
{
    
    [timerLeft invalidate];
    
    if(callButton.tag == 101){
        
    }else{
        
        [self finishVideoChat];
    }
    
}
- (void)startVideoChat:(QBRTCConferenceType)conferenceType {
    
    callButton.tag = 102;
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    [QBRTCSoundRouter.instance initialize];
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
    NSLog(@"%d",opponentID.intValue);
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:qUserName forKey:@"username"];
    [dict setObject:qPassword forKey:@"password"];
    //start call
    
    [QBRTCClient.instance addDelegate:self];
    QBRTCSession *session  = [QBRTCClient.instance
                              createNewSessionWithOpponents:@[@(opponentID.intValue)]
                              withConferenceType:QBRTCConferenceTypeVideo];
    
    if (session) {
        self.session = session;
    }
    NSLog(@".....%@",self.session);
    
    NSDictionary *userInfo = @{@"startCall" : @"userInfo"};
    NSLog(@"%@",session);
    NSLog(@"%@",self.session);
    
    [session startCall:userInfo];
    
    
    //  [self startCall];
    [QBRTCSoundRouter instance].currentSoundRoute = QBRTCSoundRouteReceiver;
    
    ringigngLabel.hidden = NO;
    ringigngLabel.text = @"Calling...";
    ringigngLabel.frame = CGRectMake(128, 375, 90, 37);
    callingActivityIndicator.hidden = NO;
    [callingActivityIndicator startAnimating];
    [MBProgressHUD showHUDAddedTo:opponentVideoView animated:YES];
}

- (void)finishApp
{
    if ([ComingFromSide isEqualToString:@"Lawyer Side"]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.appTerminate == NO)
        {
            [self reject];
            return;
        }
        else
        {
            [self finishVideoChat];
        }
    }
    else
    {
        
        [self finishVideoChat];
        
    }
}
- (void)startCall {
    //Begin play calling sound
    self.beepTimer = [NSTimer scheduledTimerWithTimeInterval:[QBRTCConfig dialingTimeInterval]
                                                      target:self
                                                    selector:@selector(playCallingSound:)
                                                    userInfo:nil
                                                     repeats:YES];
    [self playCallingSound:nil];
    //Start call
    NSDictionary *userInfo = @{@"startCall" : @"userInfo"};
    NSLog(@"%@",self.session);
    [self.session startCall:userInfo];
}

- (void)playCallingSound:(id)sender {
    
    [QMSoundManager playCallingSound];
}


-(void)MicroPhoneIsEnabledOrNot
{
    if (IsMicroPhoneEnabled==YES)
    {
        self.session.localMediaStream.audioTrack.enabled = NO;
        IsMicroPhoneEnabled=NO;
        [MuteUnmuteBtn setImage:[UIImage imageNamed:@"MicroPhone_Disabled"] forState:UIControlStateNormal];
    }
    else
    {
        self.session.localMediaStream.audioTrack.enabled = YES;
        IsMicroPhoneEnabled=YES;
        [MuteUnmuteBtn setImage:[UIImage imageNamed:@"MicroPhone_Enabled"] forState:UIControlStateNormal];
    }
}

- (void)finishVideoChat
{
        callButton.tag = 101;
    
    // Finish call
    NSLog(@"+++++%@",self.session);
    
    __weak __typeof(self)weakSelf = self;
    NSDictionary *userInfo = @{ @"key" : @"value" };
    [weakSelf.session hangUp:userInfo];
    
    self.remoteVideoChat = nil;
    self.videoCapture = nil;
    [self.videoCapture stopSession];
    
    myVideoView.hidden = YES;
    opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
    [startingCallActivityIndicator stopAnimating];
    
    
    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        chatFinished=YES;
        
        NSLog(@"2222222222222222222222222");
        
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
        
    }
}

- (void)reject
{
    ringigngLabel.hidden = YES;
    
    // release player
    ringingPlayer = nil;
    
    NSLog(@"----%@",self.session);
    [self.session rejectCall:@{@"reject" : @"busy"}];
    
    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)]){
            [_delegate MainViewControllerDidEndCall];
        }
    }
}

- (void)accept
{
    NSLog(@"accept");
    NSLog(@"self.session%@",self.session);
    [self.dialignTimer invalidate];
    
    NSDictionary *userInfo = @{@"acceptCall" : @"userInfo"};
    [self.session acceptCall:userInfo];
    
    ringigngLabel.hidden = YES;
    callButton.tag = 102;
    opponentVideoView.layer.borderWidth = 0;
    [startingCallActivityIndicator startAnimating];
    myVideoView.hidden = NO;
    ringingPlayer = nil;
    [TimeLeftLabel setText:@"Time Left : 15:00"];
    currMinute=15;
    currSeconds=00;
    [self start];
}

- (IBAction)EndCallButton:(id)sender{
    [timerLeft invalidate];
    badConnection=NO;
    
    if ([ComingFromApprovelView isEqualToString:@"Yes"]){
        [[NSUserDefaults standardUserDefaults] setValue:@"reject" forKey:@"call"];
    }else{
    }
    
    [self reject];
    AcceptRejectView.hidden=YES;
}

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
    [self AskFromUserAboutRecommndForm];
}

- (void)hideCallAlert
{
    [self.callAlert dismissWithClickedButtonIndex:-1 animated:YES];
    self.callAlert = nil;
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    ringingPlayer = nil;
}
-(void)GetLawyerDetailWithQuickBloxId:(NSString *)lawyerQuickBloxId
{
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
                 
//                 NSString *errorMsg = [responseObject valueForKey:@"message"];
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                 message:errorMsg
//                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                 [alert show];
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
                 
//                 NSString *errorMsg = [responseObject valueForKey:@"message"];
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                 message:errorMsg
//                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                 [alert show];
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
#pragma mark - QBChatDelegate

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
    
    self.presenceTimer = [[QBRTCTimer alloc] initWithTimeInterval:45
                                                           repeat:YES
                                                            queue:dispatch_get_main_queue()
                                                       completion:^{
                                                           [[QBChat instance] sendPresence];
                                                           
                                                       } expiration:^{
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

#pragma mark -
#pragma mark QBChatDelegate
//
// VideoChat delegate
-(void)ShowAcceptCallView
{
    [newIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    
}
- (void)session:(QBRTCSession *)session userDidNotRespond:(NSNumber *)userID;
{
    [QMSysPlayer stopAllSounds];
    
    [self.dialignTimer invalidate];
    NSLog(@"chatCallUserDidNotAnswer %lu", (unsigned long)userID);
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    callButton.tag = 101;
    if ([ComingFromSide isEqualToString:@"Lawyer Side"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"user isn't answering, Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:opponentVideoView animated:YES];
    
}


- (void)session:(QBRTCSession *)session rejectedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo
{
    NSLog(@"chatCallDidRejectByUser %lu", (unsigned long)userID);
    
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    
    callButton.tag = 101;
    
    UIAlertView *alert;
    if (badConnection == YES){
        alert= [[UIAlertView alloc] initWithTitle:@"" message:@"User has rejected your call." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else
        
        alert= [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Lost." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:opponentVideoView animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)session:(QBRTCSession *)session acceptedByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSLog(@"acceptByUser");
    NSLog(@"chatCallDidAcceptByUser %lu", (unsigned long)userID);
    appDelegate.appTerminate = YES;
    ringigngLabel.hidden = YES;
    callingActivityIndicator.hidden = YES;
    
    opponentVideoView.layer.borderWidth = 0;
    callButton.tag = 102;
    
    myVideoView.hidden = NO;
    
    [startingCallActivityIndicator startAnimating];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:opponentVideoView animated:YES];
    
    [TimeLeftLabel setText:@"Time Left : 15:00"];
    currMinute=15;
    currSeconds=00;
    [self start];
    
}

- (void)chatCallDidStartWithUser:(NSUInteger)userID sessionID:(NSString *)sessionID{
    
    [startingCallActivityIndicator stopAnimating];
}

- (void)didStartUseTURNForVideoChat{
    //    NSLog(@"_____TURN_____TURN_____");
}

- (void)didReceiveAudioBuffer:(AudioBuffer)buffer{
}


#pragma mark UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==5)
    {
        if (buttonIndex==1)
        {
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

- (IBAction)btnClicked_ChangeCamera:(UIButton*)sender
{
    AVCaptureDevicePosition position = [self.videoCapture currentPosition];
    AVCaptureDevicePosition newPosition = position == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    // check whether videoCapture has or has not camera position
    // for example, some iPods do not have front camera
    if ([self.videoCapture hasCameraForPosition:newPosition]) {
        [self.videoCapture selectCameraPosition:newPosition];
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
    NSLog(@"%@",[SharedSingleton sharedClient].user_Profile.lawyerId);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //39
    [SignInAndSignUpHelper DirectPayWithCard:userId
                                  withAmount:@"39"
                                    withtype:@"call"
                                  withFormId:@""
                                withBundleId:@""
                                withLawyerId:[SharedSingleton sharedClient].user_Profile.lawyerId
                      andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             if ([ComingFromSide isEqualToString:@"Lawyer Side"])
             {
                 [AppointmentNetworkHelper checkAppointmentStatus:userId withAppointmentId:[[NSUserDefaults standardUserDefaults] valueForKey:@"appID"] withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      if (!error)
                      {
                          NSString *strSuccess = [responseObject valueForKey:@"success"];
                          NSLog(@"%@",strSuccess);
                      }
                  }];
             }
             else
             {
                 [AppointmentNetworkHelper checkAppointmentStatus:userId withAppointmentId:[SharedSingleton sharedClient].appID withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      if (!error)
                      {
                          NSString *strSuccess = [responseObject valueForKey:@"success"];
                          NSLog(@"%@",strSuccess);
                      }
                  }];
             }
             
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 // NSDictionary *detailUser = [responseObject objectForKey:@"details"];
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)]){
                         [_delegate MainViewControllerDidEndCall];
                     }
                     FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
                     [self.navigationController pushViewController:FeedbackVc animated:YES];
                     
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
    NSLog(@"%@",[SharedSingleton sharedClient].user_Profile.lawyerId);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //39
    [SignInAndSignUpHelper PayWithPaypal:userId
                              withAmount:@"39"
                                withtype:@"call"
                              withFormId:@""
                            withBundleId:@""
                            withLawyerId:[SharedSingleton sharedClient].user_Profile.lawyerId
                  andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             
             if ([ComingFromSide isEqualToString:@"Lawyer Side"])
             {
                 [AppointmentNetworkHelper checkAppointmentStatus:userId withAppointmentId:[[NSUserDefaults standardUserDefaults] valueForKey:@"appID"] withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      if (!error)
                      {
                          NSString *strSuccess = [responseObject valueForKey:@"success"];
                          NSLog(@"%@",strSuccess);
                      }
                  }];
             }
             else
             {
                 [AppointmentNetworkHelper checkAppointmentStatus:userId withAppointmentId:[SharedSingleton sharedClient].appID withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      if (!error)
                      {
                          NSString *strSuccess = [responseObject valueForKey:@"success"];
                          NSLog(@"%@",strSuccess);
                          
                      }
                  }];
             }
             
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)]){
                         [_delegate MainViewControllerDidEndCall];
                     }
                     FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
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
    NSString *userId = user_Profile.userId;
    NSLog(@"LawyerId%@", LawyerId);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //39
    [SignInAndSignUpHelper PayWithCoupons:userId
                               withAmount:@"39"
                                 withtype:@"call"
                               withFormId:@""
                             withBundleId:@""
                             withLawyerId:[SharedSingleton sharedClient].user_Profile.lawyerId
                   andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         if (!error)
         {
             if ([ComingFromSide isEqualToString:@"Lawyer Side"])
             {
                 [AppointmentNetworkHelper checkAppointmentStatus:userId withAppointmentId:[[NSUserDefaults standardUserDefaults] valueForKey:@"appID"] withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      if (!error)
                      {
                          NSString *strSuccess = [responseObject valueForKey:@"success"];
                          NSLog(@"%@",strSuccess);
                      }
                  }];
             }
             else
             {
                 
                 [AppointmentNetworkHelper checkAppointmentStatus:userId withAppointmentId:[SharedSingleton sharedClient].appID withStatus:@"Done" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      if (!error)
                      {
                          NSString *strSuccess = [responseObject valueForKey:@"success"];
                          NSLog(@"%@",strSuccess);
                      }
                  }];
             }
             
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)]){
                         [_delegate MainViewControllerDidEndCall];
                     }
                     FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
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

-(void)callDelegate
{
    FeedbackToLawyerViewController *FeedbackVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackToLawyer"];
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
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Approval Sent to Lawyer"
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
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Approval Sent to User"
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
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Your Form Request has been sent to admin for Approval"
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

-(void)getLawyerDetail
{
    NSLog(@"New Session Created");
    {
        if (flag1==2)
        {
            flag1=3;
            
            [self GetLawyerDetailWithQuickBloxId:[NSString stringWithFormat:@"%lu",(unsigned long)videoChatOpponentID]];
            if (self.callAlert == nil)
            {
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSString *message = [NSString stringWithFormat:@"%@ is calling. Would you like to answer?", appDelegate.currentUser == 1 ? @"User 2" : @"User 1"];
                self.callAlert = [[UIAlertView alloc] initWithTitle:@"Call" message:message delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
                if ([ComingFromSide isEqualToString:@"Lawyer Side"])
                {
                    AcceptRejectView.hidden=YES;
                }
                else
                {
                    
                    if (appDelegate.isCallStart == YES) {
                        
                        AcceptRejectView.hidden = YES;
                        [self accept];
                    }
                    else
                    {
                        AcceptRejectView.hidden=NO;
                        [QBRTCSoundRouter.instance initialize];
                        [QMSoundManager playRingtoneSound];
                    }
                }
            }
            
            // hide call alert if opponent has canceled call
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideCallAlert) object:nil];
            [self performSelector:@selector(hideCallAlert) withObject:nil afterDelay:4];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }
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
    
    NSParameterAssert(self.session == session);
    
    if (self.beepTimer) {
        
        [self.beepTimer invalidate];
        self.beepTimer = nil;
        [QMSysPlayer stopAllSounds];
    }
}
#pragma mark -
#pragma mark QBRTCClientDelegate

//Called in case when receive remote video track from opponent
- (void)session:(QBRTCSession *)session receivedRemoteVideoTrack:(QBRTCVideoTrack *)videoTrack fromUser:(NSNumber *)userID {
    
    [opponentVideoView setVideoTrack:videoTrack];
}

/**
 *  Called in case when connection state changed
 */
- (void)session:(QBRTCSession *)session connectionClosedForUser:(NSNumber *)userID {
    
    NSLog(@"Connection Clsed");
    [self.session connectionStateForUser:userID];
    myVideoView = nil;
}
//Called in case when receive local video track
- (void)session:(QBRTCSession *)session didReceiveLocalVideoTrack:(QBRTCVideoTrack *)videoTrack {
    
    NSLog(@"local video callllll");
    
    [myVideoView setVideoTrack:videoTrack];
    
}
#pragma mark -
#pragma mark QBRTCClientDelegate

- (void)session:(QBRTCSession *)session hungUpByUser:(NSNumber *)userID userInfo:(NSDictionary *)userInfo {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    appDelegate.appTerminate = NO;
    self.remoteVideoChat = nil;
    self.videoCapture = nil;
    [self.videoCapture stopSession];
    [self.session connectionStateForUser:userID],
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
    if ([ComingFromApprovelView isEqualToString:@"Yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"reject" forKey:@"call"];
    }
    else
    {
    }
    AcceptRejectView.hidden=YES;
    
    if ([ComingFromSide isEqualToString:@"Lawyer Side"])
    {
        NSArray *aRR=[self.navigationController viewControllers];
        NSLog(@"arr is%@ ",aRR);
        [self.navigationController popToViewController:[aRR lastObject] animated:YES];
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
        }
    }
}

#pragma mark -
#pragma mark QBRTCClientDelegate

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.session) {
        
        [QBRTCSoundRouter.instance deinitialize];
        [self.dialignTimer invalidate];
        if (self.beepTimer) {
            
            [self.beepTimer invalidate];
            self.beepTimer = nil;
            [QMSysPlayer stopAllSounds];
            [QBRTCClient deinitializeRTC];
            self.session = nil;
        }
    }
}
/**
 *  Called in case when connection initiated
 */
- (void)session:(QBRTCSession *)session startedConnectionToUser:(NSNumber *)userID {
    
    if (session == self.session) {
        NSLog(@"Start Connected");
        [self.session connectionStateForUser:userID];
    }
}

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    NSLog(@"efgr");
    if (self.session) {
        // we already have a video/audio call session, so we reject another one
        NSDictionary *userInfo = @{ @"key" : @"value" };
        [session rejectCall:userInfo];
        return;
    }
    self.session = session;
}

//---------------------------- test delegates---------------------------//

#pragma mark - QBRTCClientDelegate

- (void)session:(QBRTCSession *)session updatedStatsReport:(QBRTCStatsReport *)report forUserID:(NSNumber *)userID {
    
    NSMutableString *result = [NSMutableString string];
//    NSString *systemStatsFormat = @"(cpu)%ld%%\n";
    // Connection stats.
    NSString *connStatsFormat = @"CN %@ms | %@->%@/%@ | (s)%@ | (r)%@\n";
    [result appendString:[NSString stringWithFormat:connStatsFormat,
                          report.connectionRoundTripTime,
                          report.localCandidateType, report.remoteCandidateType, report.transportType,
                          report.connectionSendBitrate, report.connectionReceivedBitrate]];
    
    if (session.conferenceType == QBRTCConferenceTypeVideo) {
        
        // Video send stats.
        NSString *videoSendFormat = @"VS (input) %@x%@@%@fps | (sent) %@x%@@%@fps\n"
        "VS (enc) %@/%@ | (sent) %@/%@ | %@ms | %@\n";
        [result appendString:[NSString stringWithFormat:videoSendFormat,
                              report.videoSendInputWidth, report.videoSendInputHeight, report.videoSendInputFps,
                              report.videoSendWidth, report.videoSendHeight, report.videoSendFps,
                              report.actualEncodingBitrate, report.targetEncodingBitrate,
                              report.videoSendBitrate, report.availableSendBandwidth,
                              report.videoSendEncodeMs,
                              report.videoSendCodec]];
        
        // Video receive stats.
        NSString *videoReceiveFormat =
        @"VR (recv) %@x%@@%@fps | (decoded)%@ | (output)%@fps | %@/%@ | %@ms\n";
        [result appendString:[NSString stringWithFormat:videoReceiveFormat,
                              report.videoReceivedWidth, report.videoReceivedHeight, report.videoReceivedFps,
                              report.videoReceivedDecodedFps,
                              report.videoReceivedOutputFps,
                              report.videoReceivedBitrate, report.availableReceiveBandwidth,
                              report.videoReceivedDecodeMs]];
    }
    // Audio send stats.
    NSString *audioSendFormat = @"AS %@ | %@\n";
    [result appendString:[NSString stringWithFormat:audioSendFormat,
                          report.audioSendBitrate, report.audioSendCodec]];
    
    // Audio receive stats.
    NSString *audioReceiveFormat = @"AR %@ | %@ | %@ms | (expandrate)%@";
    [result appendString:[NSString stringWithFormat:audioReceiveFormat,
                          report.audioReceivedBitrate, report.audioReceivedCodec, report.audioReceivedCurrentDelay,
                          report.audioReceivedExpandRate]];
    NSLog(@"%@", result);
}

- (void)session:(QBRTCSession *)session initializedLocalMediaStream:(QBRTCMediaStream *)mediaStream {
    
    NSLog(@"Initialized local media stream %@", mediaStream);
    mediaStream.videoTrack.videoCapture = self.videoCapture;
}

- (void)session:(QBRTCSession *)session startedConnectingToUser:(NSNumber *)userID {
    
    NSLog(@"Started connecting to user %@", userID);
}

- (void)session:(QBRTCSession *)session disconnectedFromUser:(NSNumber *)userID {
    
    if (session == self.session) {
        
        [QBRTCSoundRouter.instance deinitialize];
        [self.dialignTimer invalidate];
        if (self.beepTimer) {
            
            [self.beepTimer invalidate];
            self.beepTimer = nil;
            [QMSysPlayer stopAllSounds];
            [QBRTCClient deinitializeRTC];
            self.session = nil;
            
                }
        if ([ComingFromSide isEqualToString:@"Lawyer Side"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            if ([_delegate respondsToSelector:@selector(MainViewControllerDidEndCall)]){
                [_delegate MainViewControllerDidEndCall];
            }
        }

    }

    NSLog(@"Disconnected");
}


- (void)session:(QBRTCSession *)session disconnectedByTimeoutFromUser:(NSNumber *)userID {
    
    NSLog(@"disconnectedByTimeoutFromUser");
}

- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection*)connection{
    
    NSLog(@"CMSampleBufferRef called");
}

@end