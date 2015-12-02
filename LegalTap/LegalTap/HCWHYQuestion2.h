//
//  HCWHYQuestion2.h
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCWHYQuestion2 : UIView<UITextViewDelegate>
{
    
    IBOutlet UILabel *lbl_QuestionText;
    IBOutlet UILabel *lbl_TextViewPlaceHolder;
}
@property (strong, nonatomic) IBOutlet UITextView *textView_Text;
@property (strong, nonatomic) NSString *textQuestion;

@end
