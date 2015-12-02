//
//  UserProfile.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/18/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserProfile : NSObject

@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *userType;

@property (strong, nonatomic) NSString *quickBlox_Id;
@property (strong, nonatomic) NSString *quickBlox_UserName;

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *lastname;

@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) UIImage *image;

@property (nonatomic) BOOL onlineStatus;


-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
