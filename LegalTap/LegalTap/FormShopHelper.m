//
//  FormShopHelper.m
//  LegalTap
//
//  Created by Praveen on 9/29/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "FormShopHelper.h"
#import "FormShopRequest.h"

@implementation FormShopHelper


+(void)get_FormShopBundles:(NSString*)userId
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    
    [FormShopRequest formShop_trandingBundles:nil andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject) {
        completionBlock(error, responseObject);
    }];
}

+(void)get_FormShopCategories:(NSString*)userId
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    [FormShopRequest formShop_Categories:nil andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject) {
        completionBlock(error, responseObject);
    }];

}

+(void)get_BundleCategories:(NSString*)userId
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    [FormShopRequest bundle_Categories:nil andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject) {
        completionBlock(error, responseObject);
    }];
    
}



@end
