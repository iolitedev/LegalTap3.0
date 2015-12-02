//
//  FormShopRequest.m
//  LegalTap
//
//  Created by Praveen on 9/29/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "FormShopRequest.h"

@implementation FormShopRequest


+ (void)formShop_trandingBundles:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"bundles.php";
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

+ (void)formShop_Categories:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"getFormTypeGroupBy.php";
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

+ (void)bundle_Categories:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"GetBundleCategories.php";
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
