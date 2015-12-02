//
//  HomeViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeLegalInquryTableViewCell.h"
#import "LegalPracticeTableViewCell.h"
#import "HowCanWeHelpYouViewController.h"
#import "AlmostAtEndViewController.h"
#import "MeetUsViewController.h"
#import "MainViewController.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,QBActionStatusDelegate, QBChatDelegate,HomeLegalInquryTableViewCellDelegate,MainViewControllerDelegate,LegalPracticeTableViewCellDelegate>
{
    BOOL isListExpended;
    IBOutlet UITableView *tableView_ExpendedList;
    NSString *strSelectedPractice;
    
    //Video Calling
    NSUInteger videoChatOpponentID;
    enum QBVideoChatConferenceType videoChatConferenceType;
    NSString *sessionID;
    
    MainViewController *MainVC;
    BOOL ShowSliderView;
    UIButton *SliderBtn;
    IBOutlet UIButton *sliderBtn;
    
    
    UILabel *progress;
    NSTimer *timer;
    int currMinute;
    int currSeconds;
    
    IBOutlet UILabel *navigation_Title;
    
}
-(void)reloadtableView;

-(IBAction)SliderButton:(id)sender;

-(void)HideSlider;



- (IBAction)btnClickedTalkToLawyer:(id)sender;
//HomeToHCHelp
@property (assign, nonatomic) BOOL isListExpended;
@property (strong, nonatomic) NSArray *array_LegalPracticeList;

@property (strong, nonatomic) NSString *identifierPreviousVC;

@property (strong, nonatomic) NSDate *appointmentDate;;
@property (strong, nonatomic) UIWindow *window;
@property  BOOL ShowSliderView;



@end
