//
//  FormShopRequest.h
//  LegalTap
//
//  Created by Praveen on 9/29/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormShopRequest : NSObject


+ (void)formShop_trandingBundles:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+ (void)formShop_Categories:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+ (void)bundle_Categories:(NSDictionary*)parameters andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;


@end
