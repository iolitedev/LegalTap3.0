//
//  FeedbackNetworkRequest.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/19/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "FeedbackNetworkRequest.h"

@implementation FeedbackNetworkRequest

+ (void)userFeedback_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"feedback.php";
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
