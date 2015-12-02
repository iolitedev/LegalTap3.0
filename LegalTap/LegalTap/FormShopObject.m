//
//  FormShopObject.m
//  LegalTap
//
//  Created by Praveen on 9/29/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "FormShopObject.h"

@implementation FormShopObject

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        
        NSString *strDate = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"dateTime"]];
        {
            NSDateFormatter *dateFormatter= [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
            self.bundle_CreatedDate = [dateFormatter dateFromString:strDate];
        }
        
        self.bundle_Amount = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"bundles_amt"]];
        self.bundle_Categorie = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"bundles_cat"]];
        self.bundles_description = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"bundles_description"]];
        self.bundles_id = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"bundles_id"]];

        self.bundles_name = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"bundles_name"]];
        self.bundles_image = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"image"]];

        self.formType = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"formType"]];
    }
    return self;
}

-(instancetype)initWithDictionaryForFormTypeCat:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
    
        self.bundle_Amount = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"price"]];
        self.bundles_description = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"description"]];
        self.bundles_id = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"id"]];
        self.bundles_name = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"FormName"]];
        self.bundle_Categorie = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"Category"]];

        //Category
    }
    return self;
}
-(instancetype)initWithDictionaryForFormTypeCategory:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        _formTypeId = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"formType"]];
        _formTypeName = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"formTypeName"]];
    }
    return self;
}

-(instancetype)initWithDictionaryForBundleTypeCategory:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        _bundleTypeId = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"bundleType"]];
        _bundleTypeName = [CommonHelper replaceNullToBlankString:[dict valueForKey:@"bundleTypeName"]];
    }
    return self;
}

@end
