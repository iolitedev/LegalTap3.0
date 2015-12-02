//
//  LegalPracticeTableViewCell.m
//  LegalTap
//
//  Created by Apptunix on 2/27/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "LegalPracticeTableViewCell.h"

@implementation LegalPracticeTableViewCell
@synthesize imageView_Icon;

- (void)awakeFromNib {
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
    imageView_BackGround.frame = CGRectMake(10,
                                            0,
                                            CGRectGetWidth(self.frame) - 20,
                                            CGRectGetHeight(self.frame));
    
    view_ContentView.frame = CGRectMake(20,
                                        5,
                                        CGRectGetWidth(self.frame) - 40,
                                        CGRectGetHeight(self.frame) - 10);
    
    imageView_ViewSadhow.frame = CGRectMake(20,
                                        7,
                                        CGRectGetWidth(self.frame) - 40,
                                        CGRectGetHeight(self.frame) - 10);
    view_ContentView.layer.cornerRadius = 6.0;
    imageView_ViewSadhow.layer.cornerRadius = 6.0;
    
    
    imageView_BackGround.backgroundColor = defColor_CellBackground;
    
}

-(void)setTextTitle:(NSString *)textTitle
{
    lblTitle.text = textTitle;
    if ([CommonHelper isiPhone5or5s])
    {
        lblTitle.font = [UIFont boldSystemFontOfSize:13.0];
    }
}

#pragma mark - Actions

- (IBAction)longPressGesture_CellSelection:(UILongPressGestureRecognizer *)sender
{
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            view_ContentView.backgroundColor = defColor_CellHighLighted;
            lblTitle.textColor = [UIColor whiteColor];
            imageView_Arrow.image = [UIImage imageNamed:@"RightArrow_On"];
            if (_imgName.length)
            {
                self.imageView_Icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-1",_imgName]];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            view_ContentView.backgroundColor = [UIColor whiteColor];
            lblTitle.textColor = [UIColor blackColor];
            imageView_Arrow.image = [UIImage imageNamed:@"RightArrow_Off"];
            if (_imgName)
            {
                self.imageView_Icon.image = [UIImage imageNamed:_imgName];
            }
            if ([_delegate respondsToSelector:@selector(LegalPracticeTableViewCellDidSelect:withIndexPath:)])
            {
//                NSString *strLegalP = @"All";
                NSString *strLegalP = self.accessibilityIdentifier;
                [_delegate LegalPracticeTableViewCellDidSelect:strLegalP withIndexPath:_indexPath];
            }
            break;
        }
        default:
            break;
    }
}
@end
