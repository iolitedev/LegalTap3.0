//
//  AppointmentNetworkRequest.m
//  LegalTap
//
//  Created by Apptunix on 3/10/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "AppointmentNetworkRequest.h"

@implementation AppointmentNetworkRequest

+ (void)makeAppointment_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
{
    NSString *sorce = @"setAppointment.php";
    [LTAPIClientManager addContentTypeWithOutMultiPart];
    [[LTAPIClientManager sharedClient] POST:sorce parameters:parameters success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         NSDictionary *scoresData;
         NSError *error;
         NSDictionary *json = [NSDictionary dictionaryWithDictionary:JSON];
         
         if (!json)
         {
             NSLog(@"Error parsing JSON:ProfileUser");
             error = [ErrorHelper parsingErrorWithDescription:@"JSON Parsing Error"];
         }
         else
         {
             scoresData  = [NSDictionary dictionaryWithDictionary:json];
         }
         completionBlock(error, scoresData);
     }
                                    failure:^(NSURLSessionDataTask *__unused task, NSError *error)
     {
         NSLog(@"Request Code: %@", task.response.debugDescription);
         NSLog(@"Request URL: %@", [[task.originalRequest URL] absoluteString]);
         NSLog(@"Request Body: %@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
         NSLog(@"Error: %@", error.description);
         completionBlock(error, nil);
     }];
}

+ (void)getAppointment_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
{
    NSString *sorce = @"getAppointment.php";
    [LTAPIClientManager addContentTypeWithOutMultiPart];
    [[LTAPIClientManager sharedClient] POST:sorce parameters:parameters success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         NSDictionary *scoresData;
         NSError *error;
         NSDictionary *json = [NSDictionary dictionaryWithDictionary:JSON];
         
         if (!json)
         {
             NSLog(@"Error parsing JSON:ProfileUser");
             error = [ErrorHelper parsingErrorWithDescription:@"JSON Parsing Error"];
         }
         else
         {
             scoresData  = [NSDictionary dictionaryWithDictionary:json];
         }
         completionBlock(error, scoresData);
     }
                                    failure:^(NSURLSessionDataTask *__unused task, NSError *error)
     {
         NSLog(@"Request Code: %@", task.response.debugDescription);
         NSLog(@"Request URL: %@", [[task.originalRequest URL] absoluteString]);
         NSLog(@"Request Body: %@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
         NSLog(@"Error: %@", error.description);
         completionBlock(error, nil);
     }];
}

+ (void)makeFavoriteAppointment_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
{
    NSString *sorce = @"SetAppWithFavLawyer.php";
    [LTAPIClientManager addContentTypeWithOutMultiPart];
    [[LTAPIClientManager sharedClient] POST:sorce parameters:parameters success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         NSDictionary *scoresData;
         NSError *error;
         NSDictionary *json = [NSDictionary dictionaryWithDictionary:JSON];
         
         if (!json)
         {
             NSLog(@"Error parsing JSON:ProfileUser");
             error = [ErrorHelper parsingErrorWithDescription:@"JSON Parsing Error"];
         }
         else
         {
             scoresData  = [NSDictionary dictionaryWithDictionary:json];
         }
         completionBlock(error, scoresData);
     }
                                    failure:^(NSURLSessionDataTask *__unused task, NSError *error)
     {
         NSLog(@"Request Code: %@", task.response.debugDescription);
         NSLog(@"Request URL: %@", [[task.originalRequest URL] absoluteString]);
         NSLog(@"Request Body: %@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
         NSLog(@"Error: %@", error.description);
         completionBlock(error, nil);
     }];
}


+ (void)checkAppointmentStatus_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
{
    NSString *sorce = @"appointmentStatus.php";
    [LTAPIClientManager addContentTypeWithOutMultiPart];
    [[LTAPIClientManager sharedClient] POST:sorce parameters:parameters success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         NSDictionary *scoresData;
         NSError *error;
         NSDictionary *json = [NSDictionary dictionaryWithDictionary:JSON];
         
         if (!json)
         {
             NSLog(@"Error parsing JSON:ProfileUser");
             error = [ErrorHelper parsingErrorWithDescription:@"JSON Parsing Error"];
         }
         else
         {
             scoresData  = [NSDictionary dictionaryWithDictionary:json];
         }
         completionBlock(error, scoresData);
     }
                                    failure:^(NSURLSessionDataTask *__unused task, NSError *error)
     {
         NSLog(@"Request Code: %@", task.response.debugDescription);
         NSLog(@"Request URL: %@", [[task.originalRequest URL] absoluteString]);
         NSLog(@"Request Body: %@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
         NSLog(@"Error: %@", error.description);
         completionBlock(error, nil);
     }];
}



@end
