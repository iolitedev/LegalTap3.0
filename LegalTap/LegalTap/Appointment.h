//
//  Appointment.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/20/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Appointment : NSObject

@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSDate *dateTime;
@property (strong, nonatomic) NSString *lawyerId;
@property (strong, nonatomic) NSString *lawyerImage;
@property (strong, nonatomic) NSString *lawyerName;
@property (strong, nonatomic) NSArray *questionare;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userImage;
@property (strong, nonatomic) NSString *userName;

@property (strong, nonatomic) NSString *userQuickBloxId;
@property (strong, nonatomic) NSString *userQuickBloxName;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
