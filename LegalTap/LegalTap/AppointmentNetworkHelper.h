//
//  AppointmentNetworkHelper.h
//  LegalTap
//
//  Created by Apptunix on 3/10/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppointmentNetworkRequest.h"

@interface AppointmentNetworkHelper : NSObject

+(void)makeAppointmentWithUserid:(NSString*)userId withType:(NSString*)strType
                    withDatetime:(NSString*)datetime
                   withQuestions:(NSArray*)questions
                     withAnswers:(NSArray*)answers
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;


+(void)getAppointmentWithUserid:(NSString*)userId
                   withUserType:(NSString*)userType
         andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)makeFavoriteAppointmentWithUserid:(NSString*)userId withType:(NSString*)strType
                            withDatetime:(NSString*)datetime
                            withLawyerId:(NSString*)LawyerId
                           withQuestions:(NSArray*)questions
                             withAnswers:(NSArray*)answers
                        withUserDatetime:(NSString*)UserDateTime
                  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)checkAppointmentStatus:(NSString*)userId withAppointmentId:(NSString*)appointmentId
                   withStatus:(NSString*)status
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

@end
