//
//  SharedSingleton.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/18/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSingleton : NSObject


@property (strong, nonatomic) UserProfile *user_Profile;

//Methods
+ (instancetype)sharedClient;
@end
