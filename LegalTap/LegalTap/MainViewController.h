//
//  MainViewController.h
//  LegalTap
//
//  Created by Vikram on 23/03/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "OpponentVideoView.h"
#import "QBRTCScreenCapture.h"
#import "CaptureSessionManager.h"
#import "PayPalMobile.h"

#import <QuickbloxWebRTC/QuickbloxWebRTC.h>

@protocol MainViewControllerDelegate <NSObject>
@optional
-(void)MainViewControllerDidEndCall;

@end

@interface MainViewController : UIViewController<QBChatDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate,PayPalPaymentDelegate,UIPopoverControllerDelegate,QBRTCClientDelegate>
{
    IBOutlet UIButton *callButton;
    IBOutlet UILabel *ringigngLabel;
    IBOutlet UIActivityIndicatorView *callingActivityIndicator;
    IBOutlet UIActivityIndicatorView *startingCallActivityIndicator;
    IBOutlet QBRTCRemoteVideoView *opponentVideoView;
    IBOutlet QBRTCRemoteVideoView *myVideoView;

    
//    IBOutlet UINavigationBar *navBar;
    //QBGLVideoView
    IBOutlet UISegmentedControl *audioOutput;
    IBOutlet UISegmentedControl *videoOutput;
    
    IBOutlet UIView *bottomView;
    
    AVAudioPlayer *ringingPlayer;
    IBOutlet UIView *AcceptRejectView;
    IBOutlet UIImageView *RoundUserImage;
    NSTimer *timer;
    NSString *PaymentMethod;
    BOOL chatFinished;
    NSUInteger videoChatOpponentID;
    enum QBLGeoDataSortByKind videoChatConferenceType;
    NSString *sessionID;
    BOOL badConnection;
    BOOL IsMicroPhoneEnabled;
    IBOutlet UIButton *MuteUnmuteBtn;
    NSString *ComingFromSide;
    IBOutlet UIButton *SendCntctInfo;
    IBOutlet UIButton *RecommendForm;
    IBOutlet FXBlurView *blurView;
    IBOutlet UIImageView *imageViw_CallBG;
    NSString *LawyerId;
    int flag;
    int flag1;
    NSString *UserIdFromNotif;
    NSString *LawyerIdFromNotif;
    NSString *UserIdFromAppointmentView;
    IBOutlet UIActivityIndicatorView *newIndicator;
    IBOutlet UIButton *enableDisableVideoBtn;
    BOOL EnableVideo;
    IBOutlet UILabel *TimeLeftLabel;
    NSTimer *timerLeft;
    int currMinute;
    int currSeconds;
    NSString *ComingFromApprovelView;
}


@property  (strong, nonatomic) NSString *appID;
@property NSNumber *videoCallOppId;
@property (strong, nonatomic) QBRTCSession *session;
@property (strong, nonatomic) QBRTCCameraCapture *videoCapture;
@property (strong, nonatomic) QBRTCRemoteVideoView *remoteVideoChat;
@property (assign, nonatomic) QBRendererType remoteVideoViewRendererType;
@property (nonatomic, strong, readonly) QBRTCSampleBufferRenderer *renderer;
@property (strong, nonatomic) QBRTCVideoFormat *videoChat;
@property(nonatomic,retain) id<MainViewControllerDelegate> delegate;
@property (strong) NSNumber *opponentID;
@property (weak, nonatomic) NSTimer *dialignTimer;
@property (strong) UIAlertView *callAlert;
@property(nonatomic,retain)NSString *ComingFromSide;
@property(nonatomic,retain)NSString *ComingFromApprovelView;
@property(nonatomic,retain)NSString *UserIdFromAppointmentView;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;

- (void)setAcceptCreditCards:(BOOL)processCreditCards;
- (IBAction)btnClicked_ChangeCamera:(id)sender;
- (IBAction)EnableDisableVideo:(id)sender;
- (IBAction)call:(id)sender;
- (IBAction)EndCallButton:(id)sender;
- (IBAction)AnswerButton:(id)sender;
- (IBAction)MuteUnmuteButtonAction:(id)sender;
- (IBAction)SendContactInfo:(id)sender;
- (IBAction)RecommendFormBtnAction:(id)sender;
- (void)finishVideoChat;
- (void)reject;
- (void)accept;
@end
