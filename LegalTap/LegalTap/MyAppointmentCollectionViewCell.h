//
//  MyAppointmentCollectionViewCell.h
//  LegalTap
//
//  Created by Apptunix on 3/9/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Appointment.h"

typedef enum {
    MyAppointmentCollectionViewCellCalenderType,
    MyAppointmentCollectionViewCellListType
}MyAppointmentCollectionViewCellType;

@interface MyAppointmentCollectionViewCell : UICollectionViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIView *view_Title;
@property (strong, nonatomic) IBOutlet UIView *view_Time;
@property (strong, nonatomic) IBOutlet UIView *view_Arrow;

//Title
@property (strong, nonatomic) IBOutlet UILabel *lbl_Day;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Title;

//Time
@property (strong, nonatomic) IBOutlet UILabel *lbl_Time;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_TimeIcon;
@property (strong, nonatomic) IBOutlet UILabel *SepraterLabel;


//Arrow
@property (strong, nonatomic) IBOutlet UIImageView *imageView_ArrowIcon;

@property (nonatomic) MyAppointmentCollectionViewCellType cellType;
@property (nonatomic) Appointment *clientAppointment;

@property (nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) IBOutlet UILabel *pendingFlagLabel;


-(void)setViewLayoutByType;

@end
