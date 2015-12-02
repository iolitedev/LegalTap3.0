//
//  FeedbackNetworkRequest.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/19/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackNetworkRequest : NSObject

+ (void)userFeedback_WithParameters:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

@end
