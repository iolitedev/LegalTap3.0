//
//  AppointmentNetworkRequest.h
//  LegalTap
//
//  Created by Apptunix on 3/10/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentNetworkRequest : NSObject

+ (void)makeAppointment_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+ (void)getAppointment_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;;
+ (void)makeFavoriteAppointment_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+ (void)checkAppointmentStatus_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;



@end
