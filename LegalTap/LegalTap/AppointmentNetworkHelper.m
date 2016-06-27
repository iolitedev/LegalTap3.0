//
//  AppointmentNetworkHelper.m
//  LegalTap
//
//  Created by Apptunix on 3/10/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "AppointmentNetworkHelper.h"
#import "AppointmentNetworkRequest.h"

@implementation AppointmentNetworkHelper


//setAppointment.php
//questions answers datetime(2015-03-15 22:55:22) type userId

+(void)makeAppointmentWithUserid:(NSString*)userId withType:(NSString*)strType
                    withDatetime:(NSString*)datetime
                   withQuestions:(NSArray*)questions
                     withAnswers:(NSArray*)answers
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (datetime && datetime.length > 0)
        {
            [param setValue:datetime forKey:@"datetime"];
        }
        if (questions && questions.count > 0)
        {
            [param setObject:questions forKey:@"questions"];
        }
        if (answers && answers.count > 0)
        {
            [param setObject:answers forKey:@"answers"];
        }
        if (strType && strType.length > 0)
        {
            [param setValue:strType forKey:@"type"];
        }
    }
    [AppointmentNetworkRequest makeAppointment_WithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}


+(void)getAppointmentWithUserid:(NSString*)userId
                    withUserType:(NSString*)userType
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (userType && userType.length > 0)
        {
            [param setValue:userType forKey:@"userType"];
        }
    }
    [AppointmentNetworkRequest getAppointment_WithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
//SetAppWithFavLawyer.php
//Params : datetime,userId,lawyerId,type

+(void)makeFavoriteAppointmentWithUserid:(NSString*)userId withType:(NSString*)strType
                    withDatetime:(NSString*)datetime
                    withLawyerId:(NSString*)LawyerId
                   withQuestions:(NSArray*)questions
                     withAnswers:(NSArray*)answers
                    withUserDatetime:(NSString*)UserDateTime
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (datetime && datetime.length > 0)
        {
            [param setValue:datetime forKey:@"datetime"];
        }
        if (questions && questions.count > 0)
        {
            [param setObject:questions forKey:@"questions"];
        }
        if (answers && answers.count > 0)
        {
            [param setObject:answers forKey:@"answers"];
        }
        if (strType && strType.length > 0)
        {
            [param setValue:strType forKey:@"type"];
        }
        if (UserDateTime && UserDateTime.length > 0)
        {
            [param setValue:UserDateTime forKey:@"userDatetime"];
        }
        if (LawyerId && LawyerId.length > 0)
        {
            [param setValue:LawyerId forKey:@"lawyerId"];
        }
    }
    [AppointmentNetworkRequest makeFavoriteAppointment_WithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)checkAppointmentStatus:(NSString*)userId withAppointmentId:(NSString*)appointmentId
                   withStatus:(NSString*)status
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (appointmentId && appointmentId.length > 0)
        {
            [param setValue:appointmentId forKey:@"appointmentId"];
        }
        if (status && status.length > 0)
        {
            [param setObject:status forKey:@"status"];
        }
    }
    [AppointmentNetworkRequest checkAppointmentStatus_WithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}


@end
