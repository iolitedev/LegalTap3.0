//
//  FormShopObject.h
//  LegalTap
//
//  Created by Praveen on 9/29/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormShopObject : NSObject


@property (strong, nonatomic) NSMutableArray *array_TrandingBundle;

@property (strong, nonatomic) NSString *bundle_Amount;
@property (strong, nonatomic) NSDate *bundle_CreatedDate;
@property (strong, nonatomic) NSString *bundle_Categorie;
@property (strong, nonatomic) NSString *bundles_description;
@property (strong, nonatomic) NSString *bundles_id;
@property (strong, nonatomic) NSArray *questionare;
@property (strong, nonatomic) NSString *bundles_name;
@property (strong, nonatomic) NSString *bundles_image;
@property (strong, nonatomic) NSString *formTypeName;
@property (strong, nonatomic) NSString *formTypeId;

@property (strong, nonatomic) NSString *formType;
@property (strong, nonatomic) NSString *bundleTypeName;
@property (strong, nonatomic) NSString *bundleTypeId;



-(instancetype)initWithDictionaryForFormTypeCat:(NSDictionary*)dict;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

-(instancetype)initWithDictionaryForFormTypeCategory:(NSDictionary*)dict;
-(instancetype)initWithDictionaryForBundleTypeCategory:(NSDictionary*)dict;

@end
