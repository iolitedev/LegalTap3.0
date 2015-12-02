//
//  MyAppointmentCollectionViewCell.m
//  LegalTap
//
//  Created by Apptunix on 3/9/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "MyAppointmentCollectionViewCell.h"


@implementation MyAppointmentCollectionViewCell
@synthesize cellType;

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    dateFormatter.dateFormat = @"dd/MM/yyyy hh:mm a";
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
//    NSString *strDateSeleted = [dateFormatter stringFromDate:date];
//    _lbl_Title.text = strDateSeleted;
    
    NSString *strTime;
    NSString *strEndTime;
    {

        dateFormatter.dateFormat = @"hh:mm a";
        strTime = [dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"hh:mm a";

        strEndTime = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:15*60 sinceDate:date]];

    }
    NSString *strDay;
    {
        dateFormatter.dateFormat = @"MM/dd/yyyy";
        strDay = [dateFormatter stringFromDate:date];
        
        
    }
    _lbl_Time.text = [NSString stringWithFormat:@"%@%@ - %@ - %@",@"",strDay,strTime,strEndTime];//@"    "
    
   
    _lbl_Day.text = strDay;
    
    NSString *strTitle;
    {
//        dateFormatter.dateFormat = @"dd-MM-yyyy";
//        strTitle = [dateFormatter stringFromDate:date];
        strTitle = @"Schedule Appointment for";
    }

    if (_clientAppointment &&
        [_userType isEqualToString:@"lawyer"])
    {
        
        strTitle = [strTitle stringByAppendingString:@" call "];
        strTitle = [strTitle stringByAppendingString:_clientAppointment.userName];
        
        strTitle=[NSString stringWithFormat:@"%@%@",@"Scheduled appointment for call with ",_clientAppointment.userName];
    }
   /* else
    {
        strTitle = [strTitle stringByAppendingString:@"..."];
        
    }*/
    _lbl_Title.text = strTitle;
    
    if (([date compare:[NSDate date]] == kCFCompareEqualTo)
        || ([date compare:[NSDate date]] == kCFCompareGreaterThan))
    {
        //Pink
        _lbl_Day.textColor = defColor(184.0, 0.0, 123.0, 0.9);
        _lbl_Time.textColor = [UIColor blackColor];//defColor(184.0, 0.0, 123.0, 0.9);
    }
    else
    {
        //Black,Green
        _lbl_Day.textColor = [UIColor blackColor];
        _lbl_Time.textColor =[UIColor blackColor];// defColor(95.0, 201.0, 103.0, 0.9);
    }
    
    if (_clientAppointment && [_userType isEqualToString:@"user"])
    {
        
        if ([self.clientAppointment.status isEqualToString:@"Lawyer Assigned"])
        {
            self.pendingFlagLabel.hidden=NO;
            self.pendingFlagLabel.text=@"Confirmed";
            self.pendingFlagLabel.backgroundColor=[UIColor colorWithRed:(0/255.0) green:(128/255.0) blue:(0/255.0) alpha:1];
        }
        else
        {
            self.pendingFlagLabel.hidden=NO;
            self.pendingFlagLabel.text=@"Pending";
            self.pendingFlagLabel.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
        }
    }
}
-(void)boldFontForLabel:(UILabel *)label{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Medium",currentFont.fontName] size:currentFont.pointSize];
    label.font = newFont;
}
-(void)setViewLayoutByType
{
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor lightGrayColor];
    self.selectedBackgroundView = backView;
    
    if (cellType == MyAppointmentCollectionViewCellCalenderType)
    {
//        _view_Arrow.hidden = YES;
        _imageView_TimeIcon.hidden=YES;
       // _lbl_Time.hidden=YES;
        _lbl_Title.hidden=YES;
        [_lbl_Time setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
       // [_lbl_Time setFont:[UIFont systemFontOfSize:17]];
        [self boldFontForLabel:_lbl_Time];

        _SepraterLabel.hidden=NO;

        
        _view_Title.frame = CGRectMake(CGRectGetMinX(_view_Title.frame),
                                       CGRectGetMinY(_view_Title.frame),
                                       CGRectGetWidth(self.frame),
                                       CGRectGetHeight(_view_Title.frame));
        
        _view_Time.frame = CGRectMake(CGRectGetMinX(self.frame),
                                       10,//CGRectGetMinY(_view_Time.frame),
                                       CGRectGetWidth(self.frame),
                                       CGRectGetHeight(_view_Time.frame));
        
        _imageView_TimeIcon.frame = CGRectOffset(_imageView_TimeIcon.bounds,
                                                 10,
                                                 CGRectGetMinY(_imageView_TimeIcon.frame));
        
        _lbl_Time.frame = CGRectOffset(_lbl_Time.bounds,
                                       CGRectGetMaxX(_imageView_TimeIcon.frame),
                                       CGRectGetMinY(_lbl_Time.frame));
        
        _lbl_Time.frame=CGRectMake(0, _lbl_Time.frame.origin.y, def_DeviceWidth, _lbl_Time.frame.size.height);
        
    }
    else
    {
//        _view_Arrow.hidden = NO;
        
        _view_Title.frame = CGRectMake(CGRectGetMinX(_view_Title.frame),
                                       CGRectGetMinY(_view_Title.frame),
                                       CGRectGetWidth(self.frame) - CGRectGetWidth(_view_Arrow.frame),
                                       CGRectGetHeight(_view_Title.frame));
        
        _view_Time.frame = CGRectMake(CGRectGetMinX(_view_Time.frame),
                                      CGRectGetMinY(_view_Time.frame),
                                      CGRectGetWidth(self.frame) - CGRectGetWidth(_view_Arrow.frame),
                                      CGRectGetHeight(_view_Time.frame));
        
        _imageView_TimeIcon.frame = CGRectOffset(_imageView_TimeIcon.bounds,
                                                 CGRectGetWidth(_view_Time.frame) - CGRectGetWidth(_lbl_Time.frame) - CGRectGetWidth(_imageView_TimeIcon.frame),
                                                 CGRectGetMinY(_imageView_TimeIcon.frame));
        _lbl_Time.frame = CGRectOffset(_lbl_Time.bounds,
                                       CGRectGetMaxX(_imageView_TimeIcon.frame),
                                       CGRectGetMinY(_lbl_Time.frame));
    }
}
@end
