//
//  FeedbackHelper.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/19/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "FeedbackHelper.h"
#import "FeedbackNetworkRequest.h"

@implementation FeedbackHelper

+(void)userLoginWithUserId:(NSString*)userId
              withLawyerId:(NSString*)lawyerId
                withRating:(NSString*)rating
              withFeedback:(NSString*)feedback
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (lawyerId && lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"lawyerId"];
        }
        if (rating && rating.length > 0)
        {
            [param setValue:rating forKey:@"rating"];
        }
        if (feedback && feedback.length > 0)
        {
            [param setValue:feedback forKey:@"feedback"];
        }
    }
    [FeedbackNetworkRequest userFeedback_WithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

@end
