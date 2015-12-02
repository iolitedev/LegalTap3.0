//
//  CommonHelper.m
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "CommonHelper.h"
#import <UIKit/UIKit.h>

@implementation CommonHelper
+(BOOL)isiPhone5or5s
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (width == 320)
    {
        return true;
    }
    return false;
}

+(BOOL)isiPhone6Plus
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (width == 414)
    {
        return true;
    }
    return false;
}


+(NSArray*)legalPracticeList
{
    
    return @[@"DUI",
             @"PERSONAL INJURY",
             @"IMMIGRATION",
             @"EMPLOYMENT",
             @"TAX",
             @"SMALL BUSINESS",
             @"FAMILY",
             @"WILLS AND TRUSTS"
             ];
}

+(NSArray*)formShopList
{
    
    return @[@"EMPLOYMENT",
             @"SMALL BUSINESS",
             @"REAL ESTATE",
             @"TRADEMARKS & COPYRIGHTS",
             @"WILL AND TRUSTS",
             @"FAMILY",
             ];
}

+(NSArray*)stateList
{
    return @[@"Select State"
             ,@"Alabama"
             ,@"Alaska"
             ,@"Arizona"
             ,@"Arkansas"
             ,@"California"
             ,@"Colorado"
             ,@"Connecticut"
             ,@"Delaware"
             ,@"District of Columbia"
             ,@"Florida"
             ,@"Georgia"
             ,@"Hawaii"
             ,@"Idaho"
             ,@"Illinois"
             ,@"Indiana"
             ,@"Iowa"
             ,@"Kansas"
             ,@"Kentucky"
             ,@"Louisiana"
             ,@"Maine"
             ,@"Maryland"
             ,@"Massachusetts"
             ,@"Michigan"
             ,@"Minnesota"
             ,@"Mississippi’"
             ,@"Missouri"
             ,@"Montana"
             ,@"Nebraska"
             ,@"Nevada"
             ,@"New Hampshire"
             ,@"New Jersey"
             ,@"New Mexico"
             ,@"New York"
             ,@"North Carolina"
             ,@"North Dakota"
             ,@"Ohio"
             ,@"Oklahoma"
             ,@"Oregon"
             ,@"Pennsylvania"
             ,@"Rhode Island"
             ,@"South Carolina"
             ,@"South Dakota"
             ,@"Tennessee"
             ,@"Texas"
             ,@"Utah"
             ,@"Vermont"
             ,@"Virginia"
             ,@"Washington"
             ,@"West Virginia"
             ,@"Wisconsin"
             ,@"Wyoming"];
}

+ (BOOL)validEmail:(NSString*)emailString
{
    if([emailString length]==0)
    {
        return NO;
    }
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+(void)saveUserId:(UserProfile *)userProfile withUserPassword:(NSString*)password withremember:(BOOL)remember
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    {
        [userDefault setValue:userProfile.userId forKey:defLOGIN_USERID];
        [userDefault setValue:userProfile.imageURL forKey:defLOGIN_USERIMAGE];

        [userDefault setValue:userProfile.userType forKey:defLOGIN_USERTYPE];
        
        [userDefault setValue:userProfile.lastname forKey:defLOGIN_LASTNAME];
        [userDefault setValue:userProfile.state forKey:defLOGIN_STATE];
        
        [userDefault setValue:userProfile.name forKey:defLOGIN_NAME];
        [userDefault setValue:userProfile.email forKey:defLOGIN_EMAIL];
        [userDefault setValue:password forKey:defLOGIN_PASSWORD];
        [userDefault setValue:remember?@"Yes":@"No" forKey:defLOGIN_REMEMBER];
        
        [userDefault setValue:userProfile.address forKey:defLOGIN_ADDRESS];
        [userDefault setValue:userProfile.city forKey:defLOGIN_CITY];
        [userDefault setValue:userProfile.mobileNumber forKey:defLOGIN_CONTACTNUMBER];
        
        [userDefault setValue:userProfile.quickBlox_Id forKey:defLOGIN_QUICKBLOX_ID];
        [userDefault setValue:userProfile.quickBlox_UserName forKey:defLOGIN_QUICKBLOX_USERNAME];

    }
    [userDefault synchronize];
}

+(BOOL)isRemember
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *remember = [userDefault valueForKey:defLOGIN_REMEMBER];
    if ([remember isEqualToString:@"Yes"])
    {
        return YES;
    }
    return NO;
}

+(NSString*)getUserPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault valueForKey:defLOGIN_PASSWORD];
}

+(UserProfile*)getUserProfileFromUserDefault
{
    UserProfile *user = [[UserProfile alloc] init];
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        user.userId = [userDefault valueForKey:defLOGIN_USERID];
        user.name = [userDefault valueForKey:defLOGIN_NAME];
        user.email = [userDefault valueForKey:defLOGIN_EMAIL];
        user.imageURL = [userDefault valueForKey:defLOGIN_USERIMAGE];
        user.userType = [userDefault valueForKey:defLOGIN_USERTYPE];
        
        user.lastname = [userDefault valueForKey:defLOGIN_LASTNAME];
        user.state = [userDefault valueForKey:defLOGIN_STATE];
        
        user.quickBlox_Id = [userDefault valueForKey:defLOGIN_QUICKBLOX_ID];
        user.quickBlox_UserName = [userDefault valueForKey:defLOGIN_QUICKBLOX_USERNAME];
        
        user.address = [userDefault valueForKey:defLOGIN_ADDRESS];
        user.city = [userDefault valueForKey:defLOGIN_CITY];
        user.mobileNumber = [userDefault valueForKey:defLOGIN_CONTACTNUMBER];
        user.onlineStatus = YES;
    }
    return user;
}

+(void)animateToHomeTabWithTabBarController:(UITabBarController*)tabBarController
{
    // Get the views.
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = FALSE;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake((scrollRight ? def_DeviceWidth : -def_DeviceWidth), viewSize.origin.y, def_DeviceWidth, viewSize.size.height);
    
    [UIView animateWithDuration:0.3
                     animations: ^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake((scrollRight ? -def_DeviceWidth : def_DeviceWidth), viewSize.origin.y, def_DeviceWidth, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, def_DeviceWidth, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             [tabBarController setSelectedIndex:0];
                         }
                     }];
}

+(void)removeUserDetail
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    {
        [userDefault removeObjectForKey:defLOGIN_USERID];
        [userDefault removeObjectForKey:defLOGIN_USERIMAGE];
        [userDefault removeObjectForKey:defLOGIN_USERTYPE];
        [userDefault removeObjectForKey:defLOGIN_NAME];
        [userDefault removeObjectForKey:defLOGIN_EMAIL];
        [userDefault removeObjectForKey:defLOGIN_PASSWORD];
        [userDefault removeObjectForKey:defLOGIN_REMEMBER];
        
        [userDefault removeObjectForKey:defLOGIN_LASTNAME];
        [userDefault removeObjectForKey:defLOGIN_STATE];
        
        [userDefault removeObjectForKey:defLOGIN_QUICKBLOX_ID];
        [userDefault removeObjectForKey:defLOGIN_QUICKBLOX_USERNAME];
        
        [userDefault removeObjectForKey:defLOGIN_ADDRESS];
        [userDefault removeObjectForKey:defLOGIN_CITY];
        [userDefault removeObjectForKey:defLOGIN_CONTACTNUMBER];

    }
    [userDefault synchronize];
}

#pragma mark - String Formatting

+(NSNumber*)replaceNullToNumber:(NSNumber*)number
{
    if ([number isKindOfClass:[NSNull class]] || number == nil)
    {
        return @0;
    }
    else
    {
        return number;
    }
}

+(NSString*)replaceNullToBlankString:(id)obj
{
    NSString *string = [NSString stringWithFormat:@"%@",obj];
    if ([string isKindOfClass:[NSNull class]]
        || string == nil
        || ([string isKindOfClass:[NSString class]] && ([string isEqualToString:@"?"] || [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"])))
    {
        return @"";
    }
    else
    {
        return (NSString*)string;
    }
}

+(NSString*)replaceNullOrBlankStringWithZero:(id)obj
{
    NSString *string = [NSString stringWithFormat:@"%@",obj];
    if ([string isKindOfClass:[NSNull class]] || string.length == 0 || [string isEqualToString:@"?"] || [string isEqualToString:@"(null)"])
    {
        return @"0";
    }
    else
    {
        return string;
    }
}


#pragma mark - Plist Access
+(NSArray*)getQuestionsFromLegalPracticeDataWithKey:(NSString*)key
{
    NSArray *arr;
    {
        NSString *strUrl = [[NSBundle mainBundle] pathForResource:@"LegalPractice" ofType:@"plist"];
        NSDictionary *dict_LegalPractice = [NSDictionary dictionaryWithContentsOfFile:strUrl];
        
        NSDictionary *dict_LegalPracticeAreaData= [dict_LegalPractice objectForKey:@"Practice Area List Data"];
        
        NSDictionary *dict_Detail = [dict_LegalPracticeAreaData objectForKey:key];
        
        if (dict_Detail && [dict_Detail isKindOfClass:[NSDictionary class]])
        {
            arr = [dict_Detail objectForKey:@"Questions"];
        }
        else
        {
            return @[];
        }
    }
    return arr;
}


#pragma mark - get View By Question and Ans

+(UIView*)loadAnswersOnViewWithArray:(NSMutableArray*)array withWidth:(CGFloat)Width
{
    UIView *view_AnswerList = [[UIView alloc] init];
    {
        CGFloat Y;
        if (IS_IPHONE_4_OR_LESS)
        {
            Y = 100;
   
        }
        else
        {
            Y = 130;
  
        }

        for (UIView *view in view_AnswerList.subviews)
        {
            [view removeFromSuperview];
        }
        
        for (int i= 0; i < array.count; i++)
        {
            NSDictionary *dict = array[i];
            UILabel *lbl = [[UILabel alloc] init];
            {
                lbl.frame = CGRectMake(10, Y?Y+20:10, Width-20, 20);
                lbl.text = [NSString stringWithFormat:@"%@",dict[@"questions"]];
                lbl.font = [UIFont systemFontOfSize:14];
                lbl.numberOfLines = 0;
                [lbl sizeToFit];
                lbl.frame = CGRectMake(CGRectGetMinX(lbl.frame), CGRectGetMinY(lbl.frame), Width-20, CGRectGetHeight(lbl.frame));
                
            }
            [view_AnswerList addSubview:lbl];
            
            UILabel *lblAns = [[UILabel alloc] init];
            {
                lblAns.frame = CGRectMake(10, CGRectGetMaxY(lbl.frame), Width-20, 20);
                lblAns.text = [NSString stringWithFormat:@"%@",dict[@"answers"]];
                lblAns.textColor = [UIColor lightGrayColor];
                lblAns.font = [UIFont systemFontOfSize:14.0];
            }
            [view_AnswerList addSubview:lblAns];
            Y = CGRectGetMaxY(lblAns.frame);
        }
        if (!array.count)
        {
            Y = 50;
        }
        view_AnswerList.frame = CGRectMake(CGRectGetMinX(view_AnswerList.frame),
                                           CGRectGetMinY(view_AnswerList.frame),
                                           CGRectGetWidth(view_AnswerList.frame),
                                           Y+20);
    }
    return view_AnswerList;
}
+(UIView*)loadAnswersOnViewWithWindowArray:(NSMutableArray*)array withWidth:(CGFloat)Width
{
    UIView *view_AnswerList = [[UIView alloc] init];
    {
        CGFloat Y;
        if (IS_IPHONE_4_OR_LESS)
        {
            Y = 0;
            
        }
        else
        {
            Y = 0;
            
        }
        
        for (UIView *view in view_AnswerList.subviews)
        {
            [view removeFromSuperview];
        }
        
        for (int i= 0; i < array.count; i++)
        {
            NSDictionary *dict = array[i];
            UILabel *lbl = [[UILabel alloc] init];
            {
                lbl.frame = CGRectMake(10, Y?Y+20:10, Width-20, 20);
                lbl.text = [NSString stringWithFormat:@"%@",dict[@"question"]];
                lbl.font = [UIFont systemFontOfSize:15.0];
                
            }
            [view_AnswerList addSubview:lbl];
            
            UILabel *lblAns = [[UILabel alloc] init];
            {
                lblAns.frame = CGRectMake(10, CGRectGetMaxY(lbl.frame), Width-20, 20);
                lblAns.text = [NSString stringWithFormat:@"%@",dict[@"answer"]];
                lblAns.textColor = [UIColor lightGrayColor];
                lblAns.font = [UIFont systemFontOfSize:14.0];
            }
            [view_AnswerList addSubview:lblAns];
            Y = CGRectGetMaxY(lblAns.frame);
        }
        if (!array.count)
        {
            Y = 50;
        }
        view_AnswerList.frame = CGRectMake(CGRectGetMinX(view_AnswerList.frame),
                                           CGRectGetMinY(view_AnswerList.frame),
                                           CGRectGetWidth(view_AnswerList.frame),
                                           Y+20);
    }
    return view_AnswerList;
}

@end
