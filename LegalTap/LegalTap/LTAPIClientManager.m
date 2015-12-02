//
//  LTAPIClientManager.m
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "LTAPIClientManager.h"
#import "AppDelegate.h"

//Development Link


////Staging Link
//static NSString * const CSAPIBaseURLString = @"http://legaltap.co/apis/staging/apis/";



static NSString * const KEY = @"e8b6bfe8-caa1-4038-acda-70acafc8fee3";
static NSString * const SIGNATURE = @"12754093-43e6-4100-8de9-7489901210f9";

static BOOL alertViewed = NO;


@implementation LTAPIClientManager
{
    int retry;
}

+ (instancetype)sharedClient
{
    static LTAPIClientManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:CSAPIBaseURLString]];
        /*
         * If we want to do pinning, switch to AFSSLPinningModePublicKey. However, then the public
         * key has to be added to the bundle, and if the public key ever changes old versions of the app
         * will stop working - malmer
         */
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
//        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//        _sharedClient.responseSerializer.acceptableContentTypes = [_share10dClient.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-www-form-urlencoded"];


    });
    AFNetworkReachabilityManager *reachabilityManager = _sharedClient.reachabilityManager;
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        NSOperationQueue *operationQueue = _sharedClient.operationQueue;
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                NSLog(@"");
//                CSAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//                [CSProgressHUD hideAllHUDsForView:appDelegate.mainNavigationController.topViewController.view
//                                         animated:YES];
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    [reachabilityManager startMonitoring];
    return _sharedClient;
}

- (BOOL)connected
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

//Override to include key and signature as parameters when making api calls.
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                      failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for(NSString *key in [parameters allKeys])
    {
        [params setObject:[parameters objectForKey:key] forKey:key];
    }
    
    if ([self connected])
    {
        [[self requestSerializer] setTimeoutInterval:30];
        
        [LTAPIClientManager alertViewed:NO];
        
        return [super GET:(NSString *)URLString parameters:(NSDictionary *)params
                  success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                  failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure];
    }
    
    if (![self connected])
    {
        if (retry < 3)
        {
            // try again in a few
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self GET:URLString parameters:parameters success:success failure:failure];
            });
            
            retry++;
        }
        else
        {
            NSLog(@"No more retries");
            
            [self dismissLoading];
            
            if (![LTAPIClientManager wasAlertViewed])
            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"DefaultNavigationBarSetupNotification" object:nil];
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your Internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [error show];
            }
            retry = 0;
        }
    }
    
    return nil;
}

+ (int)wasAlertViewed
{
    return alertViewed;
}

+ (void)alertViewed:(BOOL)viewed
{
    alertViewed = viewed;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [LTAPIClientManager alertViewed:YES];
}

//Override to include key and signature as parameters when making api calls.
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                       failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSMutableDictionary *authentication = [NSMutableDictionary dictionaryWithDictionary:@{@"key":KEY,@"signature":SIGNATURE}];
//    ProfileUser *profileUser = [ProfileUserHelper getProfileUser];
//    if  (profileUser != nil)
//    {
//        [authentication setValue:profileUser.userID forKey:@"user_id"];
//        [authentication setValue:profileUser.apiToken forKey:@"api_token"];
//    }
//    
//    [params setDictionary:authentication];
    
    for(NSString *key in [parameters allKeys])
    {
        [params setObject:[parameters objectForKey:key] forKey:key];
    }
    
    if ([self connected])
    {
        [[self requestSerializer] setTimeoutInterval:30];
        
        [LTAPIClientManager alertViewed:NO];
        
        return [super POST:(NSString *)URLString parameters:(NSDictionary *)params
                   success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                   failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure];
        
        
    }
    
    if (![self connected])
    {
        if (retry < 3)
        {
            // try again in a few
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self POST:URLString parameters:parameters success:success failure:failure];
            });
            retry++;
        }
        else
        {
            NSLog(@"No more retries");
            [self dismissLoading];
            
            if (![LTAPIClientManager wasAlertViewed])
            {
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your Internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [error show];
                [self dismissLoading];

            }
            retry = 0;
        }
    }
    
    return nil;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void ( ^ ) ( id<AFMultipartFormData> formData ))block
                       success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                       failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    for(NSString *key in [parameters allKeys])
    {
        [params setObject:[parameters objectForKey:key] forKey:key];
    }
    
    if ([self connected])
    {
        [[self requestSerializer] setTimeoutInterval:30];
        
        [LTAPIClientManager alertViewed:NO];
        
        return [super POST:(NSString *)URLString
                parameters:(NSDictionary *)params
 constructingBodyWithBlock:(void ( ^ ) ( id<AFMultipartFormData> formData ))block
                   success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                   failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure];
        
    }
    
    if (![self connected])
    {
        if (retry < 3)
        {
            // try again in a few
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self POST:URLString parameters:parameters success:success failure:failure];
            });
            retry++;
        }
        else
        {
            NSLog(@"No more retries");
            [self dismissLoading];
            
            if (![LTAPIClientManager wasAlertViewed])
            {
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your Internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [error show];
            }
            retry = 0;
        }
    }
    
    return nil;
}

+(void)addContentTypeWithMultiPart
{
    if (![[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes containsObject:@"text/html"])
    {
        [LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes = [[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    if (![[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes containsObject:@"application/json"])
    {
        [LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes = [[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    }
    
    if (![[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes containsObject:@"multipart/form-data"])
    {
        [LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes = [[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes setByAddingObject:@"multipart/form-data"];
    }
}

+(void)addContentTypeWithOutMultiPart
{
    if (![[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes containsObject:@"text/html"])
    {
        [LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes = [[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
//    if (![[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes containsObject:@"application/json"])
//    {
//        [LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes = [[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//    }
//    if ([[LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes containsObject:@"multipart/form-data"])
//    {
//        NSSet *set = [LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes;
//        NSMutableSet *mutableSet = [[NSMutableSet alloc] initWithSet:set];
//        [mutableSet removeObject:@"multipart/form-data"];
//        
//        NSSet *resultSet = mutableSet;
//        
//        [LTAPIClientManager sharedClient].responseSerializer.acceptableContentTypes = resultSet;
//    }
}

- (void)dismissLoading
{
    NSLog(@"dismissLoading");
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    
//    UIViewController *root = appDelegate.window.rootViewController;
    
//    [root hideLoading];
    
//    [root setupNavigationBar];
    
//    NSLog(@"o q tem nesse button? %@", root.rightButton);
}

@end
