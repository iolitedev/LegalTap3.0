//
//  Appointment.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/20/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "Appointment.h"

@implementation Appointment

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        
//        {
//            dateTime = "1970-01-01 00:00:00";
//            lawyerId = 13;
//            lawyerImage = "http://legaltap.co/apis/userimages/1426809600image.jpeg";
//            lawyerName = abha;
//            questionare =             (
//                                       {
//                                           answer = Problem;
//                                           question = "Briefly Describe Your Problem";
//                                       }
//                                       );
//            userId = 14;
//            userImage = "http://legaltap.co/apis/userimages/1426809600image.jpeg";
//            userName = deepak;
//        }
        
        NSString *strDate = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"dateTime"]];
        {
            NSDateFormatter *dateFormatter= [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
            self.dateTime = [dateFormatter dateFromString:strDate];
        }
        
        self.lawyerId = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"lawyerId"]];
        self.lawyerImage = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"lawyerImage"]];

        self.lawyerName = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"lawyerName"]];
        
        self.questionare = [dict valueForKey:@"questionare"];
//        {
//            answer = Problem;
//            question = "Briefly Describe Your Problem";
//        }
        self.userId = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"userId"]];
        self.userImage = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"userImage"]];
        self.userName = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"userName"]];
        
        self.userQuickBloxId = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"userquickBloxId"]];
        self.userQuickBloxName = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"userquickBloxUserName"]];
        
        self.status = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"status"]];

    }
    return self;
}

@end
