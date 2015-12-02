//
//  LTAPIClientManager.h
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "AFHTTPSessionManager.h"

static NSString * const CSBaseURLStringWithoutAPi = @"https://legaltap.co/";
static NSString * const CSAPIBaseURLString = @"https://legaltap.co/apis/";

//static NSString * const CSBaseURLStringWithoutAPi = @"http://dev.legaltap.co.207-244-69-7.creativehaus.com";
//static NSString * const CSAPIBaseURLString = @"http://dev.legaltap.co.207-244-69-7.creativehaus.com/apis/";


typedef void (^RequestCompletionHandler_ResponseDictonary) (NSError *error, NSDictionary *responseObject);
typedef void (^RequestCompletionHandler_ResponseArray) (NSError *error, NSArray *responseObject);
typedef void (^RequestCompletionHandler_ResponseID) (NSError *error, id responseObject);

@interface LTAPIClientManager : AFHTTPSessionManager

+ (instancetype)sharedClient;
+ (int)wasAlertViewed;

+ (void)alertViewed:(BOOL)viewed;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                       failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                      failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void ( ^ ) ( id<AFMultipartFormData> formData ))block
                       success:(void ( ^ ) ( NSURLSessionDataTask *task , id responseObject ))success
                       failure:(void ( ^ ) ( NSURLSessionDataTask *task , NSError *error ))failure;

+(void)addContentTypeWithOutMultiPart;
+(void)addContentTypeWithMultiPart;

-(BOOL)connected;


@end
