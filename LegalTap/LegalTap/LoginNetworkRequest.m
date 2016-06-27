//
//  LoginNetworkRequest.m
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "LoginNetworkRequest.h"

@implementation LoginNetworkRequest

+ (void)registerUserWithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"adduser.php";
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
             scoresData = [NSDictionary dictionaryWithDictionary:json];
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

+ (void)getQuickBoxTokenWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"usersession.php";
    [LTAPIClientManager addContentTypeWithOutMultiPart];
    [[LTAPIClientManager sharedClient] POST:sorce parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
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

+ (void)loginUserWithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"login.php";
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

+ (void)upLoadImageForRegisterOfUserWithImage:(UIImage*)image andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"uploadimage.php";
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);//UIImagePNGRepresentation(image);
    
    [LTAPIClientManager addContentTypeWithOutMultiPart];
    
    NSSet *set = [LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes;

    NSLog(@"set - %@",set);
    [[LTAPIClientManager sharedClient] POST:sorce parameters:nil
                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:imageData
                                    name:@"image"
                                fileName:@"image.jpeg"
                                mimeType:@"image/jpeg"];
    }
                                    success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        NSDictionary *scoresData;
        NSError *error;
        NSDictionary *json = [NSDictionary dictionaryWithDictionary:responseObject];
        
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
                                    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"Request Code: %@", task.response.debugDescription);
        NSLog(@"Request URL: %@", [[task.originalRequest URL] absoluteString]);
        NSLog(@"Request Body: %@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
        NSLog(@"Error: %@", error.description);
        completionBlock(error, nil);
    }];
}

+(void)changePasswordWithParameters:(NSDictionary*)parameters
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"changepassword.php";
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

+(void)updateUserDetailWithParameters:(NSDictionary*)parameters
             andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"updateprofile.php";
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

//changeStatusWithUserId
+(void)changeStatusWithParameters:(NSDictionary*)parameters
             andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"updateuserstatus.php";
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

//Get Forms List

+(void)GetFormsList:(NSDictionary*)parameters
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"getFormsByFormType.php";
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

+(void)GetBundleList:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"getbundlesBybundleType.php";
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

+(void)GetClientsListLinkedWithLawyer:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"getLawyerClients.php";
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

+(void)RequestFormToClient:(NSDictionary*)parameters
               andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"recommendforms.php";
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
+(void)RequestToPurchaseFormByClient:(NSDictionary*)parameters
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"clientForms.php";
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

+(void)RequestToGetLawyersList:(NSDictionary*)parameters
              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"lawyerList.php";
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

+(void)AppTerminate:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"lawyerNotification.php";
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
+(void)AppTerminateByLawyer:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"appTerminatedNotification.php";
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


+(void)RequestToRandomCallToLawyer:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"lawyerCall.php";
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


+(void)RequestToCallToUser:(NSDictionary*)parameters
              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"userCall.php";
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
+(void)RequestCallToUser:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"clientCall.php";
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

+(void)CallResponseToClient:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"clientResponse.php";
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
+(void)UserList:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"userList.php";
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


+(void)RequestToGetFavLawyersList:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"getfavlawyer.php";
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

+(void)MakeLawyerToFavorite:(NSDictionary*)parameters
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"addfavorite.php";
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
+(void)GiveFeedbackToLawyer:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
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
+(void)LawyerDetailWithQuickBloxId:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"getDataByQuickId.php";
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
+(void)SendContactDetailToLawyer:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"sendContactInfo.php";
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
+(void)ForgotPassword:(NSDictionary*)parameters
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"forgotPassword.php";
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
+(void)DirectPayFromCard:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"directPay.php";
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
+(void)ApplyCuponCode:(NSDictionary*)parameters
  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"applycoupon.php";
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
+(void)VerifyCode:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"updatePassword.php";
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
+(void)AskFromLayerToSendContactRequest:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"shareContactRequest.php";
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
+(void)AskFromUserAboutReccomendForm:(NSDictionary*)parameters
                 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"recomendFormRequest.php";
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
+(void)AcceptFormRequestFromLawyer:(NSDictionary*)parameters
              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"acceptRecomendFormRequest.php";
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
+(void)TokenRequestToServer:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"paymentRequestToken.php";
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
+(void)PayWithPaypalAccount:(NSDictionary*)parameters
  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"payByPayPal.php";
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
+(void)PayWithCoupon:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"payUsingAccount.php";
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

+(void)AccountBalance:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"accountDetails.php";
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
+(void)SetPaymentMethod:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"addPaymentMethod.php";
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
+(void)GetPaymentMethod:(NSDictionary*)parameters
 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSString *sorce = @"getPaymentMethod.php";
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
