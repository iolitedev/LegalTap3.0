//
//  HCWHYQuestion1.h
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownList.h"

@interface HCWHYQuestion1 : UIView
{
    IBOutlet UILabel *lbl_QuestionText;
    IBOutlet UIView *view_TempList;
}
@property (strong, nonatomic) NSString *textQuestion;
@property (strong, nonatomic) DropDownList *viewList;


@end
