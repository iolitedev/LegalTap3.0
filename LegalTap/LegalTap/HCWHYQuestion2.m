//
//  HCWHYQuestion2.m
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "HCWHYQuestion2.h"

@implementation HCWHYQuestion2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    _textView_Text.layer.borderWidth = 1.0;
    _textView_Text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundColor = [UIColor clearColor];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self textViewChangeText:textView];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    [self textViewChangeText:textView];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self textViewChangeText:textView];
}


-(void)textViewChangeText:(UITextView*)textView
{
    if ([textView.text isEqualToString:@""])
    {
        lbl_TextViewPlaceHolder.hidden = NO;
    }
    else
    {
        lbl_TextViewPlaceHolder.hidden = YES;
    }
}

-(void)setTextQuestion:(NSString *)textQuestion
{
    lbl_QuestionText.text = textQuestion;
}


@end
