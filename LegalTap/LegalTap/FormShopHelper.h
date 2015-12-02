//
//  FormShopHelper.h
//  LegalTap
//
//  Created by Praveen on 9/29/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormShopHelper : NSObject

+(void)get_FormShopBundles:(NSString*)userId
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)get_FormShopCategories:(NSString*)userId
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)get_BundleCategories:(NSString*)userId
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

@end
