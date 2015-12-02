//
//  LTPageControl.m
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "LTPageControl.h"

@implementation LTPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    activeImage = [UIImage imageNamed:@"Dot_Active"];
    inactiveImage = [UIImage imageNamed:@"Dot_Inactive"];
    [self updateDots];
    
}

// Update the background images to be placed at the right position
-(void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        
        for (UIView* subview in dotView.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView*)subview;
                dot.backgroundColor = [UIColor clearColor];
                dotView.backgroundColor = [UIColor clearColor];
                break;
            }
        }
        
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0, 5.0)];
            [dotView addSubview:dot];
            dotView.backgroundColor = [UIColor clearColor];
        }
        
        if (i == self.currentPage)
        {
            if(activeImage)
                dot.image = activeImage;
        }
        else
        {
            if (inactiveImage)
                dot.image = inactiveImage;
        }
    }
}

// overide the setCurrentPage
-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}



@end
