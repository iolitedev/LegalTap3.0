//
//  HCWHYQuestion1.m
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "HCWHYQuestion1.h"

@implementation HCWHYQuestion1
@synthesize viewList;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

-(void)awakeFromNib
{
    // Drawing code
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
    viewList = [array firstObject];
    {
        viewList.frame = view_TempList.frame;
        [viewList layoutIfNeeded];
        [viewList loadList:@[@"Yes",@"No"]];
    }
    [self addSubview:viewList];
}

-(void)setTextQuestion:(NSString *)textQuestion
{
    lbl_QuestionText.text = textQuestion;
    [lbl_QuestionText setFont:[UIFont fontWithName:@"OpenSans-Light" size:19]];

}

-(void)layoutIfNeeded
{
    [super layoutIfNeeded];
    viewList.frame = view_TempList.frame;
}
@end
