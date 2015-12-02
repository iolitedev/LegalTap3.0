
//
//  HomeLegalInquryTableViewCell.m
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "HomeLegalInquryTableViewCell.h"

@implementation HomeLegalInquryTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    view_Content.frame = CGRectMake(0,
                                    0,
                                    CGRectGetWidth(self.frame),
                                    CGRectGetHeight(self.frame));
}

#pragma mark - Gesture recongnizers

- (IBAction)press_PersonalInquiry:(UILongPressGestureRecognizer*)sender
{

    [[NSUserDefaults standardUserDefaults] setValue:@"PERSONAL INJURY" forKey:@"LawyerType"];

    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"PERSONAL INJURY" properties:@{
                                                            @"method": @"WILL AND TRUSTS",
                                                            }];

            _imageView_PersonalInquiry.image = [UIImage imageNamed:@"Home_Personal_Enquiry_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            _imageView_PersonalInquiry.image = [UIImage imageNamed:@"Home_Personal_Enquiry_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"PERSONAL INJURY";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
        }
        default:
        break;
    }
}

- (IBAction)press_Immigration:(UILongPressGestureRecognizer*)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Immigration" forKey:@"LawyerType"];
    
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Immigration" properties:@{
                                                        @"method": @"Immigration",
                                                        }];
            
            _imageView_Immigration.image = [UIImage imageNamed:@"Home_Immigration_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
            _imageView_Immigration.image = [UIImage imageNamed:@"Home_Immigration_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"IMMIGRATION";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
            default:
            break;
    }
}

- (IBAction)press_Wills:(UILongPressGestureRecognizer*)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Will and Trusts" forKey:@"LawyerType"];
    
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Wills And Trusts" properties:@{
                                                        @"method": @"Wills and Trusts",
                                                        }];
            
            _imageView_Wills.image = [UIImage imageNamed:@"Home_Wills_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
            _imageView_Wills.image = [UIImage imageNamed:@"Home_Wills_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"WILL AND TRUSTS";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
        default:
            break;
    }
}




- (IBAction)press_Tax:(UILongPressGestureRecognizer*)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Tax" forKey:@"LawyerType"];

    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Tax" properties:@{
                                                @"method": @"Tax",
                                                }];

            _imageView_Tax.image = [UIImage imageNamed:@"Home_Tax_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
            _imageView_Tax.image = [UIImage imageNamed:@"Home_Tax_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"TAX";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
        default:
            break;
    }
}

- (IBAction)press_Small_Business:(UILongPressGestureRecognizer*)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Business" forKey:@"LawyerType"];

    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Business" properties:@{
                                                     @"method": @"Business",
                                                     }];

            _imageView_Small_Business.image = [UIImage imageNamed:@"Home_Small_Business_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
            _imageView_Small_Business.image = [UIImage imageNamed:@"Home_Small_Business_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"SMALL BUSINESS";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
        default:
            break;
    }
}

- (IBAction)press_DUI:(UILongPressGestureRecognizer*)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"DUI" forKey:@"LawyerType"];
    
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"DUI" properties:@{
                                                @"method": @"DUI",
                                                }];
           _imageView_DUI.image = [UIImage imageNamed:@"Home_DUI_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
            _imageView_DUI.image = [UIImage imageNamed:@"Home_DUI_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"DUI";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
        default:
            break;
    }
}

- (IBAction)press_Family:(UILongPressGestureRecognizer*)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Family" forKey:@"LawyerType"];
    
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Family" properties:@{
                                                @"method": @"Family",
                                                }];
            _imageView_Family.image = [UIImage imageNamed:@"Home_Family_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
            _imageView_Family.image = [UIImage imageNamed:@"Home_Family_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"FAMILY";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
        default:
            break;
    }
}


- (IBAction)press_Divorce:(UILongPressGestureRecognizer*)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Divorce" forKey:@"LawyerType"];

    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Divorce" properties:@{
                                                    @"method": @"Divorce",
                                                    }];

            _imageView_Divorce.image = [UIImage imageNamed:@"Home_Divorce_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
            _imageView_Divorce.image = [UIImage imageNamed:@"Home_Divorce_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"FAMILY";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
        default:
            break;
    }
}
- (IBAction)press_Emploment:(UILongPressGestureRecognizer*)sender
{
   
    [[NSUserDefaults standardUserDefaults] setValue:@"Employment" forKey:@"LawyerType"];

    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Mixpanel analytics
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            
            [mixpanel track:@"Employment" properties:@{
                                                       @"method": @"Employment",
                                                       }];
            _imageView_Employment.image = [UIImage imageNamed:@"Home_Employment_Off"];
            break;
        }
        case UIGestureRecognizerStateEnded:
            _imageView_Employment.image = [UIImage imageNamed:@"Home_Employment_On"];
            if ([_delegate respondsToSelector:@selector(HomeLegalInquryTableViewCellDidSelect:)])
            {
                NSString *strLegalP = @"EMPLOYMENT";
                [_delegate HomeLegalInquryTableViewCellDidSelect:strLegalP];
            }
            break;
        default:
            break;
    }
}
@end
