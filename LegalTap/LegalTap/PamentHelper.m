//
//  PamentHelper.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/19/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "PamentHelper.h"
#import "PaymentRequest.h"

@implementation PamentHelper
//userId, cardNumber, monthYear, zipCode

+(void)updateUserCardDetailWithUserId:(NSString*)userId withCardNumber:(NSString*)cardNumber withMonthYear:(NSString*)monthYear withZipCode:(NSString*)zipCode withCvv:(NSString*)Cvv withCardType:(NSString*)CardType andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (cardNumber && cardNumber.length > 0)
        {
            [param setValue:cardNumber forKey:@"cardNumber"];
        }
        if (monthYear && monthYear.length > 0)
        {
            [param setValue:monthYear forKey:@"monthYear"];
        }
        if (zipCode && zipCode.length > 0)
        {
            [param setValue:zipCode forKey:@"zipCode"];
        }
        if (Cvv && Cvv.length > 0)
        {
            [param setValue:Cvv forKey:@"cvv"];
        }
        if (CardType && CardType.length > 0)
        {
            [param setValue:CardType forKey:@"cardType"];
        }
    }
    [PaymentRequest pamentUpdates_WithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)getserCardDetailWithUserId:(NSString*)userId
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
    }
    [PaymentRequest getPamentUpdates_WithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

@end
