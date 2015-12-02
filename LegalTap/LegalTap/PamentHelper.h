//
//  PamentHelper.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/19/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PamentHelper : NSObject

+(void)updateUserCardDetailWithUserId:(NSString*)userId withCardNumber:(NSString*)cardNumber withMonthYear:(NSString*)monthYear withZipCode:(NSString*)zipCode withCvv:(NSString*)Cvv withCardType:(NSString*)CardType andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)getserCardDetailWithUserId:(NSString*)userId
               andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

@end
