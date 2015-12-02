//
//  ErrorHelper.h
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHelper : NSObject

+ (NSError *)authenticationFailedWithDescription:(NSString *)description;

+ (NSError *)parsingErrorWithDescription:(NSString *)description;

+ (NSError *)apiErrorFromDictionary:(NSDictionary *)dictionary;

@end
