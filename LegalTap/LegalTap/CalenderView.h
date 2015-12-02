//
//  CalenderView.h
//  LegalTap
//
//  Created by Apptunix on 3/9/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

@protocol CalenderViewDelegates;

#import <UIKit/UIKit.h>
@class AppDelegate;

#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekdayOrdinal)

@interface CalenderView : UIView
{
    IBOutlet UILabel *lbl_SelectedMonthYear;
    
    NSInteger intDaySelect;
    NSInteger intMonthSelect;
    NSInteger intYearSelect;
    
    NSInteger intMonthForHeader;
    NSInteger intYearForHeader;
    
    IBOutlet UIImageView *imgBackGround;
    
    IBOutlet UICollectionView *collectionView_CalenderDays;
    NSArray *arrCurrentMonthDays;
    
    NSMutableArray *arrDatesWithEvents;
    AppDelegate *obj_App;
    
    //Header Of Table
    IBOutlet UILabel *lbl_HeaderWithMonthAndYear;

    //Edit Event
    BOOL flag_Edit;
    NSString *str_GuestId;
    NSString *str_guestSelected;
    
    IBOutlet UIView *view_Header;
    IBOutlet UIView *view_Calender;
    
}
-(void)setCalenderWithDateReminderArray:(NSArray*)reminderArray;


@property (strong, nonatomic) id<CalenderViewDelegates> delegate;

- (IBAction)previousMonthButtonClicked:(id)sender;
- (IBAction)nextMonthButtonClicked:(id)sender;

@end

@protocol CalenderViewDelegates <NSObject>
@optional
-(void)CalenderView:(CalenderView *)CalenderView didSelectDate:(NSDate *)date;



@end
