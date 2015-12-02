//
//  FeedbackHelper.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/19/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackHelper : NSObject
//userId, lawyerId, rating, feedback

+(void)userLoginWithUserId:(NSString*)userId
            withLawyerId:(NSString*)lawyerId
             withRating:(NSString*)rating
               withFeedback:(NSString*)feedback
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

@end
