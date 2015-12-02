//
//  HCWHYQuestion3.m
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "HCWHYQuestion3.h"

@implementation HCWHYQuestion3

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
    viewMonthList = [array1 firstObject];
    {
        viewMonthList.frame = view_TempMonth.frame;
        [viewMonthList layoutIfNeeded];
        NSMutableArray *arrayList = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 12; i++)
        {
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            dateFormater.dateFormat = @"MM";
            NSDate *date = [dateFormater dateFromString:[NSString stringWithFormat:@"%d",i]];
            dateFormater.dateFormat = @"MMMM";
            NSString *strMonth = [dateFormater stringFromDate:date];
            [arrayList addObject:strMonth];
        }
        [viewMonthList loadList:arrayList];
    }
    [self addSubview:viewMonthList];
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
    viewDayList = [array firstObject];
    {
        viewDayList.frame = view_TempDay.frame;
        [viewDayList layoutIfNeeded];
        
        NSMutableArray *arrayList = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 31; i++)
        {
            [arrayList addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [viewDayList loadList:arrayList];
    }
    [self addSubview:viewDayList];    
    
    NSArray *array2 = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
    viewYearList = [array2 firstObject];
    {
        viewYearList.frame = view_TempYear.frame;
        [viewYearList layoutIfNeeded];
        NSMutableArray *arrayList = [[NSMutableArray alloc] init];
        for (int i = 2000; i <= 2015; i++)
        {
            [arrayList addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [viewYearList loadList:arrayList];
    }
    [self addSubview:viewYearList];
}

@end
