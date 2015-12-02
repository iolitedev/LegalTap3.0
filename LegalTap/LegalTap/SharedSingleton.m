//
//  SharedSingleton.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/18/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "SharedSingleton.h"
static SharedSingleton *sharedData;

@implementation SharedSingleton

+ (instancetype)sharedClient
{
    if (!sharedData)
    {
        sharedData = [[SharedSingleton alloc] init];
    }
    return sharedData;
}

@end
