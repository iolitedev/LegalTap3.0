//
//  HCWHYQuestion3.h
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownList.h"

@interface HCWHYQuestion3 : UIView
{
    IBOutlet UIView *view_TempDay;
    IBOutlet UIView *view_TempYear;
    IBOutlet UIView *view_TempMonth;
    
    DropDownList *viewDayList;
    DropDownList *viewMonthList;
    DropDownList *viewYearList;
    
}
@end
