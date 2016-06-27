//
//  UserProfile.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/18/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.userId = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"id"]];
        self.name = [dict valueForKey:@"firstName"];
        self.email = [dict valueForKey:@"emailId"];
        self.imageURL = [dict valueForKey:@"userImage"];
        self.userType = [dict valueForKey:@"userType"];
        self.appointmentId = [dict valueForKey:@"appointmentId"];
        self.address = [dict valueForKey:@"address"];
        self.city = [dict valueForKey:@"city"];
        self.mobileNumber = [dict valueForKey:@"contactNumber"];
        self.status = [dict valueForKey:@"status"];
        
        self.quickBlox_Id = [dict valueForKey:@"quickBloxId"];
        self.quickBlox_UserName = [dict valueForKey:@"quickBloxUserName"];
        self.onlineStatus = YES;
    }
    return self;
}

@end
