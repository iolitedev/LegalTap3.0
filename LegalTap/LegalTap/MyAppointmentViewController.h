//
//  MyAppointmentViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/9/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderView.h"
#import "MyAppointmentCollectionViewCell.h"
#import "AppointmentWindowViewController.h"
#import "AppointmentApprovalViewController.h"
#import "HomeViewController.h"
#import "AppointmentNetworkHelper.h"
#import "Appointment.h"
#import <Quickblox/Quickblox.h>

@interface MyAppointmentViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CalenderViewDelegates,QBChatDelegate>
{
    IBOutlet UIView *view_PageControl;
    IBOutlet UIView *view_Calender;
    IBOutlet UIView *view_List;
    IBOutlet UIView *topViewOutlet;
    
    IBOutlet UISegmentedControl *pageControl_Calender;
    
    IBOutlet UIView *view_PlaceForCalenderandList;
    
    //Calender
    IBOutlet UICollectionView *collectionView_Calender;
    CalenderView *calenderView;
    NSArray *array_Calender;
    
    //List
    IBOutlet UICollectionView *collectionView_List;
    NSArray *array_List;
    
    NSMutableArray *array_CalenderAppointmentList;
    NSMutableArray *array_FullAppointmentList;
    
    UIView *viewHeaderLine;
    
    UILabel *lblEmpty_Calender;
    UILabel *lblEmpty_List;
    
    NSString *userType;
    IBOutlet UIBarButtonItem *barButton_Home;
    
    //Video Calling
    NSUInteger videoChatOpponentID;
    enum QBRTCConferenceType videoChatConferenceType;
    NSString *sessionID;
    NSString *LawyerIdFromSettings;
    IBOutlet UIScrollView *CalendarScrellView;

}
@property(nonatomic,strong) NSString *LawyerIdFromSettings;
- (IBAction)pageControl_ChangeType:(id)sender;
- (IBAction)navigationBar_Clicked_Home:(id)sender;


@end
