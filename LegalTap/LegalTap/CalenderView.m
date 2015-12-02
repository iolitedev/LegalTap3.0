//
//  CalenderView.m
//  LegalTap
//
//  Created by Apptunix on 3/9/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "CalenderView.h"

@implementation CalenderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setup];
}
//*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)setCalenderWithDateReminderArray:(NSArray*)reminderArray
{
    arrDatesWithEvents = [[NSMutableArray alloc] initWithArray:reminderArray];
    [self setup];
}

-(void)setup
{
      //Temp Data For Event Small Dot
    
    NSDateComponents *todayComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
    intDaySelect = todayComponents.day;
    intMonthSelect = todayComponents.month;
    intYearSelect = todayComponents.year;
    
    intMonthForHeader = intMonthSelect;
    intYearForHeader = intYearSelect;
    
    lbl_SelectedMonthYear.text = [NSString stringWithFormat:@"%@ %ld",[self getProperMonthName:intMonthSelect],(long)intYearSelect];
    
    arrCurrentMonthDays = [self getNumberOfDaysInMonth:intMonthSelect Year:intYearSelect];
    
    [collectionView_CalenderDays registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [collectionView_CalenderDays reloadData];
//    NSLog(@"Days - %@",arrCurrentMonthDays);
}


#pragma mark - Collection View Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrCurrentMonthDays.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    ///For Show Pink circle on cell For Only Selection selected.png
    UIImageView *imgView_CellSelection = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    {
        imgView_CellSelection.center = cell.contentView.center;
        imgView_CellSelection.backgroundColor = [UIColor orangeColor];
        imgView_CellSelection.layer.cornerRadius = 12;
        imgView_CellSelection.layer.masksToBounds = YES;
    }
    [cell setSelectedBackgroundView:imgView_CellSelection];
    
    
    ///For Show Pink circle on cell selected.png
    UIImageView *imgView_CellSelectionOneTime = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    {
        imgView_CellSelectionOneTime.center = cell.contentView.center;
        imgView_CellSelectionOneTime.backgroundColor = [UIColor orangeColor];//defColor(184.0, 0.0, 123.0, 0.9);
        imgView_CellSelectionOneTime.layer.cornerRadius = 12;
        imgView_CellSelectionOneTime.layer.masksToBounds = YES;
    }
    BOOL flag_user = YES;
    
    UILabel *lblDay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    lblDay.center = cell.contentView.center;
    lblDay.textAlignment = NSTextAlignmentCenter;
    lblDay.textColor = [UIColor whiteColor];
    lblDay.font = [UIFont systemFontOfSize:14];
    
    ///For Show Pink circle on cell reminder.png
    UIImageView *imgView_CellEventIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, 6, 6)];
    {
        imgView_CellEventIndicator.frame = CGRectOffset(imgView_CellEventIndicator.bounds,
                                                        CGRectGetWidth(lblDay.frame)-4,
                                                        0);
        imgView_CellEventIndicator.backgroundColor = [UIColor orangeColor];//defColor(184.0, 0.0, 123.0, 0.9);
        imgView_CellEventIndicator.layer.cornerRadius = 3;
        imgView_CellEventIndicator.layer.masksToBounds = YES;
    }
    
    NSString *strDay = [NSString stringWithFormat:@"%@",arrCurrentMonthDays[indexPath.row]];
    lblDay.text = strDay;
    
    NSInteger indexForRow = indexPath.row;
    if (indexForRow >= 0 && indexForRow < 7)
    {
        if (((NSString*)arrCurrentMonthDays[indexPath.row]).intValue > 20 )
        {
            flag_user = NO;
            lblDay.textColor = [UIColor grayColor];
            //            NSLog(@"0 - 7 - %@",arrCurrentMonthDays[indexForRow]);
        }
        else
        {
            NSInteger day = ((NSString*)arrCurrentMonthDays[indexForRow]).integerValue;
            if ([self setReminderOnDateWithday:day month:intMonthSelect year:intYearSelect])
            {
                [lblDay addSubview:imgView_CellEventIndicator];
            }
            if (day == intDaySelect && intMonthSelect == intMonthForHeader && intYearForHeader == intYearSelect)
            {
                lblDay.textColor = [UIColor whiteColor];
                [cell.contentView addSubview:imgView_CellSelectionOneTime];
            }
        }
    }
    else if (indexForRow >= 7 && indexForRow < arrCurrentMonthDays.count-14)
    {
        NSInteger day = ((NSString*)arrCurrentMonthDays[indexForRow]).integerValue;
        if ([self setReminderOnDateWithday:day month:intMonthSelect year:intYearSelect])
        {
            [lblDay addSubview:imgView_CellEventIndicator];
        }
        
        if (day == intDaySelect && intMonthSelect == intMonthForHeader && intYearForHeader == intYearSelect)
        {
            lblDay.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:imgView_CellSelectionOneTime];
        }
    }
    if (indexPath.row >= arrCurrentMonthDays.count-14 && indexPath.row < arrCurrentMonthDays.count)
    {
        if (((NSString*)arrCurrentMonthDays[indexPath.row]).intValue < 15 )
        {
            flag_user = NO;
            lblDay.textColor = [UIColor grayColor];
//            NSLog(@"24 - 31 - %@",arrCurrentMonthDays[indexForRow]);
        }
        else
        {
            NSInteger day = ((NSString*)arrCurrentMonthDays[indexForRow]).integerValue;
            
            if ([self setReminderOnDateWithday:day month:intMonthSelect year:intYearSelect])
            {
                [lblDay addSubview:imgView_CellEventIndicator];
            }
            if (day == intDaySelect && intMonthSelect == intMonthForHeader && intYearForHeader == intYearSelect)
            {
                lblDay.textColor = [UIColor whiteColor];

                [cell.contentView addSubview:imgView_CellSelectionOneTime];
            }
        }
    }
    else
    {
        //        NSInteger day = ((NSString*)arrCurrentMonthDays[indexForRow]).integerValue;
        //        if (day == intDaySelect)
        //        {
        //
        //            [cell.contentView addSubview:imgView_CellSelectionOneTime];
        //        }
        
    }
    
    NSDateComponents *todayComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
    NSInteger currentDay = todayComponents.day;
    
    NSInteger day = ((NSString*)arrCurrentMonthDays[indexForRow]).integerValue;
    
    
    if (currentDay == day && intMonthSelect == todayComponents.month && intYearSelect == todayComponents.year)
    {
        [cell.contentView addSubview:lblDay];
        
        if (currentDay > 0 && currentDay < 7 && (indexForRow > 28))
        {
            
        }
        else if (currentDay > 22 && currentDay < 32 && (indexForRow <7))
        {
            
        }
        else if (![lblDay.textColor isEqual:[UIColor grayColor]])
        {
            //Today
            UIImageView *imgView_CurrentDay = [[UIImageView alloc] initWithFrame:lblDay.frame];
            imgView_CurrentDay.backgroundColor = [UIColor orangeColor]; //defColor(184.0, 0.0, 123.0, 0.9);
            imgView_CurrentDay.layer.cornerRadius = lblDay.frame.size.width/2;
            imgView_CurrentDay.layer.masksToBounds = YES;
            imgView_CurrentDay.alpha = 0.3;
            [cell.contentView addSubview:imgView_CurrentDay];
        }
    }
    else
    {
        [cell.contentView addSubview:lblDay];
    }
//    [tableView_EventsForDate reloadData];
    if (flag_user)
    {
    }
    
    return cell;
}

#pragma mark - Methods
//For reminder Dot Show
-(BOOL)setReminderOnDateWithday:(NSInteger)day month:(NSInteger)month year:(NSInteger)year
{
    NSMutableArray *arrOfDates = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy hh:mm:ss z";
    for (NSDate *date in arrDatesWithEvents)
    {
        dateFormatter.dateFormat = @"dd";
        NSString *strDay = [dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"MM";
        NSString *strMonth = [dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"yyyy";
        NSString *strYear = [dateFormatter stringFromDate:date];
        NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%04ld",(long)strMonth.integerValue,(long)strDay.integerValue,(long)strYear.integerValue];
        [arrOfDates addObject:strDate];
    }
    
    NSString *dateSelect = [NSString stringWithFormat:@"%02ld/%02ld/%04ld",(long)month,(long)day,(long)year];
    
    for (NSString *str in arrOfDates)
    {
        if ([dateSelect isEqualToString:str])
        {
            return YES;
        }
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexForRow= indexPath.row;
    
    if (indexForRow >= 0 && indexForRow < 7)
    {
        if (((NSString*)arrCurrentMonthDays[indexPath.row]).intValue > 20 )
        {
//            NSLog(@"0 - 7 - %@",arrCurrentMonthDays[indexForRow]);
            intDaySelect = ((NSString*)arrCurrentMonthDays[indexPath.row]).integerValue;
            [self previousMonth];

            intMonthForHeader = intMonthSelect;
            intYearForHeader = intYearSelect;
        }
        else
        {
            intDaySelect = ((NSString*)arrCurrentMonthDays[indexPath.row]).integerValue;
            intMonthForHeader = intMonthSelect;
            intYearForHeader = intYearSelect;
            intMonthForHeader = intMonthSelect;
            intYearForHeader = intYearSelect;
        }
    }
    else if(indexForRow >= 7 && indexForRow < arrCurrentMonthDays.count-14)
    {
        intDaySelect = ((NSString*)arrCurrentMonthDays[indexPath.row]).integerValue;
        intMonthForHeader = intMonthSelect;
        intYearForHeader = intYearSelect;
    }
    else if (indexPath.row >= arrCurrentMonthDays.count-14 && indexPath.row < arrCurrentMonthDays.count)
    {
        if (((NSString*)arrCurrentMonthDays[indexPath.row]).intValue < 15 )
        {
//            NSLog(@"24 - 31 - %@",arrCurrentMonthDays[indexForRow]);

            intDaySelect = ((NSString*)arrCurrentMonthDays[indexPath.row]).integerValue;
            [self nextMonth];

            intMonthForHeader = intMonthSelect;
            intYearForHeader = intYearSelect;
        }
        else
        {
            intDaySelect = ((NSString*)arrCurrentMonthDays[indexPath.row]).integerValue;
            intMonthForHeader = intMonthSelect;
            intYearForHeader = intYearSelect;
        }
    }
    else
    {
        intDaySelect = ((NSString*)arrCurrentMonthDays[indexPath.row]).integerValue;
        intMonthForHeader = intMonthSelect;
        intYearForHeader = intYearSelect;
    }
    
    NSLog(@"%ld/%ld/%ld",(long)intDaySelect,(long)intMonthSelect,(long)intYearSelect);
    if ([_delegate respondsToSelector:@selector(CalenderView:didSelectDate:)])
    {
        NSString *strDate = [NSString stringWithFormat:@"%ld/%ld/%ld 00:00:00",(long)intDaySelect,(long)intMonthSelect,(long)intYearSelect];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy hh:mm:ss";
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
        [_delegate CalenderView:self didSelectDate:[dateFormatter dateFromString:strDate]];
    }
    [collectionView reloadData];
}


#pragma mark - Methods For Get Days For Calendar

-(NSArray*)getNumberOfDaysInMonth:(NSInteger)month Year:(NSInteger)year
{
    NSMutableArray *arrOfDays = [[NSMutableArray alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger presentMonthDays;
    NSInteger previousMonthDays;
    NSInteger dayOfWeek;
    
    //Range For Present Month
    NSDateComponents *presentMonthComponents = [[NSDateComponents alloc] init];
    [presentMonthComponents setMonth:month];
    [presentMonthComponents setYear:year];
    [presentMonthComponents setDay:1];
    [presentMonthComponents setHour:10];
    [presentMonthComponents setMinute:10];
    [presentMonthComponents setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"] ];
    
    NSRange presentMonth_DaysRange = [gregorianCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[gregorianCalendar dateFromComponents:presentMonthComponents]];
    presentMonthDays = presentMonth_DaysRange.length;
    
    //Range For Previous Month
    if (month > 1)
    {
        //when mCurrentMonth is greater than one
        [presentMonthComponents setMonth:month - 1];
        NSRange previousMonthdaysRange = [gregorianCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[gregorianCalendar dateFromComponents:presentMonthComponents]];
        previousMonthDays = previousMonthdaysRange.length;
    }
    else
    {
        //when mCurrentMonth is equal to one
        previousMonthDays = 31;
    }
    NSString *strDate = [NSString stringWithFormat:@"01/%02ld/%4ld",(long)month,(long)year];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [df dateFromString:strDate];
    NSDateComponents *comps = [gregorianCalendar components:NSCalendarUnitWeekday fromDate:date];
    dayOfWeek = [comps weekday]-1;//1 = Sunday
    
    NSInteger startDay = 1;
    NSInteger startDayForNextMonth = 1;
    for (int i = 0; i < 42; i++)
    {
        NSString *str_DayOfMonth;
        
        if (i < dayOfWeek)
        {
            str_DayOfMonth = [NSString stringWithFormat:@"%ld",(previousMonthDays - (dayOfWeek - (i + 1)))];
        }
        else
        {
            if (startDay <= presentMonthDays)
            {
                str_DayOfMonth = [NSString stringWithFormat:@"%ld",(long)startDay++];
            }
            else
            {
                str_DayOfMonth = [NSString stringWithFormat:@"%ld",(long)startDayForNextMonth++];
            }
        }
        
        [arrOfDays addObject:str_DayOfMonth];
    }
    
    return arrOfDays;
}


#pragma mark - Calender Action
- (IBAction)previousMonthButtonClicked:(id)sender
{
    [self previousMonth];
    
    [collectionView_CalenderDays reloadData];
//    [tableView_EventsForDate reloadData];
    
}

-(void)previousMonth
{
    arrCurrentMonthDays = Nil;
    intMonthSelect--;
    if (intMonthSelect < 1)
    {
        intMonthSelect = 12;
        intYearSelect--;
    }
    if (intYearSelect <= 1902)
    {
        intYearSelect = [self getYearNumber];
    }
    arrCurrentMonthDays = [self getNumberOfDaysInMonth:intMonthSelect Year:intYearSelect];
    lbl_SelectedMonthYear.text = [NSString stringWithFormat:@"%@ %ld",[self getProperMonthName:intMonthSelect],(long)intYearSelect];
    
//    arrEventsForTable = [self addEventsToTableArrayWithday:intDaySelect month:intMonthSelect year:intYearSelect];
}

- (IBAction)nextMonthButtonClicked:(id)sender
{
    [self nextMonth];
    [collectionView_CalenderDays reloadData];
//    [tableView_EventsForDate reloadData];
}

-(void)nextMonth
{
    arrCurrentMonthDays = Nil;
    
    intMonthSelect++;
    if (intMonthSelect > 12)
    {
        intMonthSelect = 1;
        intYearSelect++;
    }
    if (intYearSelect >= 2050)
    {
        intYearSelect = [self getYearNumber];
    }
    arrCurrentMonthDays = [self getNumberOfDaysInMonth:intMonthSelect Year:intYearSelect];
    
    lbl_SelectedMonthYear.text = [NSString stringWithFormat:@"%@ %ld",[self getProperMonthName:intMonthSelect],(long)intYearSelect];
//    arrEventsForTable = [self addEventsToTableArrayWithday:intDaySelect month:intMonthSelect year:intYearSelect];
}

//Get Current Year
-(NSInteger)getYearNumber
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSInteger year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    return year;
}

#pragma mark - Methods For Calender Calculation
//Return month in Words
-(NSString*)getProperMonthName:(NSInteger)monthNumber
{
    NSString * dateString = [NSString stringWithFormat: @"%ld", (long)monthNumber];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSDate* myDate = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *formatterMonth = [[NSDateFormatter alloc] init];
    [formatterMonth setDateFormat:@"MMMM"];
    NSString *stringFromDate = [formatterMonth stringFromDate:myDate];
    return stringFromDate;
}

//Use For Table Header
-(NSString*)getSuffixForDay:(NSInteger)day
{
    switch (day)
    {
        case 1:
            return @"st";
            break;
        case 2:
            return @"nd";
            break;
        case 3:
            return @"rd";
            break;
        default:
            return @"th";
            break;
    }
}
@end
