//
//  CommonHelper.h
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXBlurView.h"

#import "UserProfile.h"

#define defColor(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define defColor_LightMagenta defColor(184.0, 0.0, 123.0, 0.9)
#define defColor_TOPBAR [UIColor whiteColor]


#define defLOGIN_USERID @"USER_ID"
#define defLOGIN_USERTYPE @"USER_TYPE"
#define defLOGIN_USERIMAGE @"USER_IMAGE"

#define defLOGIN_NAME @"USER_NAME"
#define defLOGIN_LASTNAME @"USER_LASTNAME"


#define defLOGIN_EMAIL @"USER_EMAIL"
#define defLOGIN_PASSWORD @"USER_PASSWORD"
#define defLOGIN_REMEMBER @"USER_REMEMBER"

#define defLOGIN_QUICKBLOX_ID @"defLOGIN_QUICKBLOX_ID"
#define defLOGIN_QUICKBLOX_USERNAME @"defLOGIN_QUICKBLOX_USERNAME"


#define defLOGIN_ADDRESS @"USER_ADDRES"
#define defLOGIN_CITY @"USER_CITY"

#define defLOGIN_STATE @"USER_STATE"

#define defLOGIN_CONTACTNUMBER @"CONTACH_NUMBER"
//quickBlox


//App delegats
#define defApplicationDidEnterBackground @"applicationDidEnterBackground"
#define defApplicationWillEnterForeground @"applicationWillEnterForeground"
#define defApplicationDidBecomeActive @"applicationDidBecomeActive"
#define defApplicationWillTerminate @"applicationWillTerminate"


typedef enum {
    iPhonetype5,
    iPhonetype5S,
}iPhonetype;

@interface CommonHelper : NSObject

#pragma mark - Device Access
+(BOOL)isiPhone5or5s;
+(BOOL)isiPhone6Plus;
+(NSArray*)legalPracticeList;
+(NSArray*)formShopList;
+(NSArray*)stateList;

+ (BOOL)validEmail:(NSString*)emailString;

#pragma mark - User Default Access
+(void)saveUserId:(UserProfile *)userProfile withUserPassword:(NSString*)password withremember:(BOOL)remember;
+(NSString*)getUserPassword;

+(BOOL)isRemember;
+(UserProfile*)getUserProfileFromUserDefault;
+(void)removeUserDetail;

#pragma mark - View Controllers Access
+(void)animateToHomeTabWithTabBarController:(UITabBarController*)tabBarController;

#pragma mark - String Formating
+(NSNumber*)replaceNullToNumber:(NSNumber*)number;
+(NSString*)replaceNullToBlankString:(id)obj;
+(NSString*)replaceNullOrBlankStringWithZero:(id)obj;

#pragma mark - Plist Access
+(NSArray*)getQuestionsFromLegalPracticeDataWithKey:(NSString*)key;

#pragma mark - get View By Question and Ans
+(UIView*)loadAnswersOnViewWithArray:(NSArray*)array withWidth:(CGFloat)Width;
+(UIView*)loadAnswersOnViewWithWindowArray:(NSArray*)array withWidth:(CGFloat)Width;



@end
