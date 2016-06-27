
//
//  SignInAndSignUpHelper.m
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "SignInAndSignUpHelper.h"

@implementation SignInAndSignUpHelper

+(void)registerUserWithEmailid:(NSString*)emailId
            withPassword:(NSString*)password
           withFirstName:(NSString*)firstName
            withToken:(NSString*)token
             withAddress:(NSString*)address
                withCity:(NSString*)city
               withState:(NSString*)state
             withZipCode:(NSString*)zipcode
             withCountry:(NSString*)country
       withContactNumber:(NSString*)contactNumber
            withUserType:(NSString*)userType
          withDeviceType:(NSString*)deviceType
         withDeviceToken:(NSString*)deviceToken
               withImage:(NSString*)image
                withLastName:(NSString*)LastName
        andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (emailId && emailId.length > 0)
        {
            [param setValue:emailId forKey:@"emailId"];
        }
        if (password && password.length > 0)
        {
            [param setValue:password forKey:@"password"];
        }
        if (firstName && firstName.length > 0)
        {
            [param setValue:firstName forKey:@"firstName"];
        }
        if (token && token.length > 0)
        {
            [param setValue:token forKey:@"token"];
        }
        if (address && address.length > 0)
        {
            [param setValue:address forKey:@"address"];
        }
        if (city && city.length > 0)
        {
            [param setValue:city forKey:@"city"];
        }
        if (state && state.length > 0)
        {
            [param setValue:state forKey:@"state"];
        }
        if (zipcode && zipcode.length > 0)
        {
            [param setValue:zipcode forKey:@"zipcode"];
        }
        if (country && country.length > 0)
        {
            [param setValue:country forKey:@"country"];
        }
        if (contactNumber && contactNumber.length > 0)
        {
            [param setValue:contactNumber forKey:@"contactNumber"];
        }
        if (userType && userType.length > 0)
        {
            [param setValue:userType forKey:@"userType"];
        }
        if (deviceType && deviceType.length > 0)
        {
            [param setValue:deviceType forKey:@"deviceType"];
        }
        if (deviceToken && deviceToken.length > 0)
        {
            [param setValue:deviceToken forKey:@"deviceToken"];
        }
        if (LastName && LastName.length > 0)
        {
            [param setValue:LastName forKey:@"lastName"];
        }
//        if (image && image.length > 0)
        {
            [param setValue:image forKey:@"image"];
        }
    }
    [LoginNetworkRequest registerUserWithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
    {
        completionBlock(error, responseObject);
    }];
}

+(void)getQuickBoxTokenWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    [LoginNetworkRequest getQuickBoxTokenWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)upLoadImageForRegisterOfUserWithImage:(UIImage*)image andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    if (!image)
    {
        NSLog(@"Error parsing JSON:ProfileUser");
        
        NSError *error = [ErrorHelper parsingErrorWithDescription:@"Empty Image"];
        completionBlock(error, nil);
    }
    else
    {
        [LoginNetworkRequest upLoadImageForRegisterOfUserWithImage:image andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             completionBlock(error, responseObject);
         }];
    }
}

+(void)userLoginWithUserEmail:(NSString*)emailId
                 withPassword:(NSString*)password
               withDeviceType:(NSString*)deviceType
              withDeviceToken:(NSString*)deviceToken
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (emailId && emailId.length > 0)
        {
            [param setValue:emailId forKey:@"emailId"];
        }
        if (password && password.length > 0)
        {
            [param setValue:password forKey:@"password"];
        }
        if (deviceType && deviceType.length > 0)
        {
            [param setValue:deviceType forKey:@"deviceType"];
        }
        if (deviceToken && deviceToken.length > 0)
        {
            [param setValue:deviceToken forKey:@"deviceToken"];
        }
    }
    [LoginNetworkRequest loginUserWithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)changePasswordWithEmailId:(NSString*)emailId
                      withUserId:(NSString*)userId
             withCurrentPassword:(NSString*)curPassword
                 withNewPassword:(NSString*)newPassword
             withConformPassword:(NSString*)conPassword
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (emailId && emailId.length > 0)
        {
            [param setValue:emailId forKey:@"emailId"];
        }
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (curPassword && curPassword.length > 0)
        {
            [param setValue:curPassword forKey:@"curPassword"];
        }
        if (newPassword && newPassword.length > 0)
        {
            [param setValue:newPassword forKey:@"newPassword"];
        }
        if (conPassword && conPassword.length > 0)
        {
            [param setValue:conPassword forKey:@"conPassword"];
        }
    }
    [LoginNetworkRequest changePasswordWithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

//Updateprofile.php
//userId, firstName, address, city, contactNumber, image
+(void)updateUserDetailWithUserId:(NSString*)userId
                         withName:(NSString*)firstName
                      withAddress:(NSString*)address
                         withCity:(NSString*)city
                        withState:(NSString*)state
                         withimageUrl:(NSString*)image
                withContactNumber:(NSString*)contactNumber
                withLastName:(NSString*)LastName
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (firstName && firstName.length > 0)
        {
            [param setValue:firstName forKey:@"firstName"];
        }
        if (address && address.length > 0)
        {
            [param setValue:address forKey:@"address"];
        }
        if (city && city.length > 0)
        {
            [param setValue:city forKey:@"city"];
        }
        if (image && image.length > 0)
        {
            [param setValue:image forKey:@"image"];
        }
        if (contactNumber && contactNumber.length > 0)
        {
            [param setValue:contactNumber forKey:@"contactNumber"];
        }
        if (LastName && LastName.length > 0)
        {
            [param setValue:LastName forKey:@"lastName"];
        }
        if (state && state.length > 0)
        {
            [param setValue:state forKey:@"state"];
        }
    }
    [LoginNetworkRequest updateUserDetailWithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

//updateuserstatus.php
//userId,appStatus

+(void)changeStatusWithUserId:(NSString*)userId
             withStatus:(BOOL)status
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId && userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        [param setValue:status?@"login":@"logout" forKey:@"appStatus"];
    }
    [LoginNetworkRequest changeStatusWithParameters:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)FormTypeWithName:(NSString*)Name andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (Name.length > 0)
        {
            [param setValue:Name forKey:@"formType"];
        }
    }
    
    [LoginNetworkRequest GetFormsList:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)BundleTypeWithName:(NSString*)Name andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (Name.length > 0)
        {
            [param setValue:Name forKey:@"bundleType"];
        }
    }
    
    [LoginNetworkRequest GetBundleList:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];

}

+(void)ClientsListLinkedWithLawyer:(NSString*)Name andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (Name.length > 0)
        {
            [param setValue:Name forKey:@"lawyerId"];
        }
    }
    
    [LoginNetworkRequest GetClientsListLinkedWithLawyer:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)RequestFormToClient:(NSString*)UserId
                 withLawerId:(NSString*)LawyerId
               withFormId:(NSString*)FormId
              withDescription:(NSString*)Description
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (UserId.length>0)
        {
            [param setValue:UserId forKey:@"userId"];
        }
        if (LawyerId.length > 0)
        {
            [param setValue:LawyerId forKey:@"lawyerId"];
        }
        if (FormId.length > 0)
        {
            [param setValue:FormId forKey:@"formId"];
        }
        if (Description.length > 0)
        {
            [param setValue:Description forKey:@"description"];
        }
    }
    [LoginNetworkRequest RequestFormToClient:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

//clientResponse.php
//param: clientId, userId, response
//lawyerCall.php
//params :lawyerId,userId

+(void)PurchaseFormByClient:(NSString*)ClientId
                withFormId:(NSString*)FormId
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (ClientId.length>0)
        {
            [param setValue:ClientId forKey:@"userId"];
        }
        if (FormId.length > 0)
        {
            [param setValue:FormId forKey:@"formId"];
        }
    }
    [LoginNetworkRequest RequestToPurchaseFormByClient:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}


+(void)GetLawyersList:(NSString*)Type
           withState:(NSString*)State
   andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (Type.length>0)
        {
            [param setValue:Type forKey:@"type"];
        }
        if (State.length>0)
        {
            [param setValue:State forKey:@"state"];
        }

    }
    [LoginNetworkRequest RequestToGetLawyersList:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

//questions, answers
+(void)UserCall:(NSMutableArray*)lawyerIds
   andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (lawyerIds.count>0)
        {
            [param setValue:lawyerIds forKey:@"user_id"];
        }
    }
    [LoginNetworkRequest RequestToCallToUser:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)RandomCallToLawyer:(NSMutableArray*)lawyerIds
                 withUserId:(NSString*)userId
               LawyerType:(NSString*)type
               WithQuestionArray:(NSArray*)questionArray
            WithAnswerArray:(NSArray*)AnswerArray
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (lawyerIds.count>0)
        {
            [param setValue:lawyerIds forKey:@"lawyerId"];
        }
        if (userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (type.length>0)
        {
            [param setValue:type forKey:@"LawyerType"];
        }
        if (questionArray.count>0)
        {
            [param setValue:questionArray forKey:@"questions"];
        }
        if (AnswerArray.count>0)
        {
            [param setValue:AnswerArray forKey:@"answers"];
        }
    }
    [LoginNetworkRequest RequestToRandomCallToLawyer:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
+(void)TerminateAppByLawyer:(NSString*)UserId
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (UserId.length > 0)
        {
            [param setValue:UserId forKey:@"userId"];
        }
        
    }
    [LoginNetworkRequest AppTerminateByLawyer:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
    
}

+(void)TerminateApp:(NSString*)UserId
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (UserId.length > 0)
        {
            [param setValue:UserId forKey:@"userId"];
        }
        
    }
    [LoginNetworkRequest AppTerminate:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
    
}


+(void)CallToUser:(NSString*)userId
               withUserId:(NSString*)lawyerId
             withAppointmentId:(NSString*)appintmentId
//        WithQuestionArray:(NSArray*)questionArray
//          WithAnswerArray:(NSArray*)AnswerArray
   andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"clientId"];
        }
        if (lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"userId"];
        }
        if (appintmentId.length > 0)
        {
            [param setValue:appintmentId forKey:@"appointmentId"];
        }
//        if (questionArray.count>0)
//        {
//            [param setValue:questionArray forKey:@"questions"];
//        }
//        if (AnswerArray.count>0)
//        {
//            [param setValue:AnswerArray forKey:@"answers"];
//        }
    }
     [LoginNetworkRequest RequestCallToUser:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
         
     }];
}


+(void)CallResponseToClient:(NSString*)clientId
               withUserId:(NSString*)userId
                 withResponse:(NSString*)response
   andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (clientId.length>0)
        {
            [param setValue:clientId forKey:@"clientId"];
        }
        if (userId.length > 0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (response.length > 0)
        {
            [param setValue:response forKey:@"response"];
        }
    }
    [LoginNetworkRequest CallResponseToClient:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)GetUsersList:(NSString*)Type
            withUserId:(NSString*)UserId
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (Type.length>0)
        {
            [param setValue:Type forKey:@"type"];
        }
        if (UserId.length > 0)
        {
            [param setValue:UserId forKey:@"user_id"];
        }
        
    }
    [LoginNetworkRequest UserList:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}


+(void)GetFavoriteLawyersList:(NSString*)UserId
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (UserId.length>0)
        {
            [param setValue:UserId forKey:@"userId"];
        }
        
    }
    [LoginNetworkRequest RequestToGetFavLawyersList:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
//userId,lawyerId,favorite(0/1)

+(void)MakeLawyerToFavorite:(NSString*)userId
                 withLawyerId:(NSString*)lawyerId
               withFavorite:(NSString*)favorite
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"lawyerId"];
        }
        if (favorite.length > 0)
        {
            [param setValue:favorite forKey:@"favorite"];
        }
    }
    [LoginNetworkRequest MakeLawyerToFavorite:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
//feedback.php
//lawyerId
//rating
//feedback
//userId

+(void)FeedBackToLawyer:(NSString*)userId
               withLawyerId:(NSString*)lawyerId
               withFeedback:(NSString*)feedback
           withRating:(NSString*)rating
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"lawyerId"];
        }
        if (feedback.length > 0)
        {
            [param setValue:feedback forKey:@"feedback"];
        }
        if (rating.length > 0)
        {
            [param setValue:rating forKey:@"rating"];
        }
    }
    [LoginNetworkRequest GiveFeedbackToLawyer:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
+(void)LawyerDetailWithQuickBloxId:(NSString*)QuickBloxId
 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (QuickBloxId.length>0)
        {
            [param setValue:QuickBloxId forKey:@"quickBloxId"];
        }
     }
    
    [LoginNetworkRequest LawyerDetailWithQuickBloxId:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)SendContactDetailsToLawyer:(NSString*)userId
           withLawyerId:(NSString*)lawyerId
 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"lawyerId"];
        }
    }
    [LoginNetworkRequest SendContactDetailToLawyer:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
+(void)GetForgotenPassword:(NSString*)EmailId
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (EmailId.length>0)
        {
            [param setValue:EmailId forKey:@"emailId"];
        }
    }
    [LoginNetworkRequest ForgotPassword:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
+(void)DirectPayWithCard:(NSString*)userId
                     withAmount:(NSString*)amount
                    withtype:(NSString*)type
                    withFormId:(NSString*)FormId
            withBundleId:(NSString*)bundleId
                    withLawyerId:(NSString*)LawyerId
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (amount.length > 0)
        {
            [param setValue:amount forKey:@"amt"];
        }
        if (type.length > 0)
        {
          [param setValue:type forKey:@"type"];
        }
        if (FormId.length > 0)
        {
            [param setValue:FormId forKey:@"formId"];
        }
        if (bundleId.length > 0)
        {
            [param setValue:bundleId forKey:@"bundleId"];
        }

        if (LawyerId.length > 0)
        {
            [param setValue:LawyerId forKey:@"lawyerId"];
        }

    }
    [LoginNetworkRequest DirectPayFromCard:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
//file: applycoupon.php
//params : userId, couponCode
+(void)ApplyCuponCode:(NSString*)userId
              withCuponCode:(NSString*)Code
  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (Code.length > 0)
        {
            [param setValue:Code forKey:@"couponCode"];
        }
    }
    [LoginNetworkRequest ApplyCuponCode:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
+(void)VerificationWithCodeWithEmail:(NSString*)emailId
        withToken:(NSString*)token
        withPassword:(NSString*)password
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (emailId.length>0)
        {
            [param setValue:emailId forKey:@"emailId"];
        }
        if (token.length > 0)
        {
            [param setValue:token forKey:@"token"];
        }
        if (password.length > 0)
        {
            [param setValue:password forKey:@"password"];
        }
    }
    [LoginNetworkRequest VerifyCode:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
// shareContactRequest.php
//params: userId, lawyerId, msg

+(void)AskFromLawyerToSendContactInfo:(NSString*)userId
                           withLawyerId:(NSString*)lawyerId
                        withMessage:(NSString*)msg
              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"lawyerId"];
        }
        if (msg.length > 0)
        {
            [param setValue:msg forKey:@"msg"];
        }
    }
    [LoginNetworkRequest AskFromLayerToSendContactRequest:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
//recomendFormRequest.php
//userId, lawyerId, msg

+(void)AskFromUserAboutReccommndForm:(NSString*)userId
                         withLawyerId:(NSString*)lawyerId
                          withMessage:(NSString*)msg
               andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"lawyerId"];
        }
        if (msg.length > 0)
        {
            [param setValue:msg forKey:@"msg"];
        }
    }
    [LoginNetworkRequest AskFromUserAboutReccomendForm:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
//acceptRecomendFormRequest.php
//params : userId, lawyerId, msg,request

+(void)RequestFormRequestFromLawyer:(NSString*)userId
                        withLawyerId:(NSString*)lawyerId
                         withMessage:(NSString*)msg
                        withRequest:(NSString*)request

              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"lawyerId"];
        }
        if (msg.length > 0)
        {
            [param setValue:msg forKey:@"msg"];
        }
        if (request.length > 0)
        {
            [param setValue:request forKey:@"request"];
        }
    }
    [LoginNetworkRequest AcceptFormRequestFromLawyer:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

// paymentRequestToken.php
// param: userId , authCode

+(void)SendAuthTokenToServer:(NSString*)Token
                       withUserId:(NSString*)UserId
             andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (Token.length>0)
        {
            [param setValue:Token forKey:@"authCode"];
        }
        if (UserId.length > 0)
        {
            [param setValue:UserId forKey:@"userId"];
        }
    }
    [LoginNetworkRequest TokenRequestToServer:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
+(void)PayWithPaypal:(NSString*)userId
              withAmount:(NSString*)amount
              withtype:(NSString*)type
              withFormId:(NSString*)FormId
        withBundleId:(NSString*)bundleId
              withLawyerId:(NSString*)LawyerId
  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (amount.length > 0)
        {
            [param setValue:amount forKey:@"amt"];
        }
        if (type.length > 0)
        {
            [param setValue:type forKey:@"type"];
        }
        if (FormId.length > 0)
        {
            [param setValue:FormId forKey:@"formId"];
        }
        if (bundleId.length > 0)
        {
            [param setValue:bundleId forKey:@"bundleId"];
        }

        if (LawyerId.length > 0)
        {
            [param setValue:LawyerId forKey:@"lawyerId"];
        }
    }
    [LoginNetworkRequest PayWithPaypalAccount:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

//payUsingAccount.php
//userId, amt

+(void)PayWithCoupons:(NSString*)userId
           withAmount:(NSString*)amount
             withtype:(NSString*)type
           withFormId:(NSString*)formId
           withBundleId:(NSString*)bundleId
         withLawyerId:(NSString*)lawyerId
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
//{
//    
//}
//
//+(void)PayWithCoupons:(NSString*)userId
//          withAmount:(NSString*)amount
//             withtype:(NSString*)type
//           withFormId:(NSString*)FormId
//         withLawyerId:(NSString*)LawyerId
//andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (amount.length > 0)
        {
            [param setValue:amount forKey:@"amt"];
        }
        if (type.length > 0)
        {
            [param setValue:type forKey:@"type"];
        }
        if (formId.length > 0)
        {
            [param setValue:formId forKey:@"formId"];
        }
        if (bundleId.length > 0)
        {
            [param setValue:bundleId forKey:@"bundleId"];
        }
        if (lawyerId.length > 0)
        {
            [param setValue:lawyerId forKey:@"lawyerId"];
        }

    }
    [LoginNetworkRequest PayWithCoupon:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}


+(void)GetAccountBalance:(NSString*)userId
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
    }
    [LoginNetworkRequest AccountBalance:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}

+(void)SendPaymentMethodToServer:(NSString*)userId
                      withMethodType:(NSString*)type
  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
        if (type.length>0)
        {
            [param setValue:type forKey:@"paymentMethod"];
        }
    }
    [LoginNetworkRequest SetPaymentMethod:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}
+(void)GetPaymentMethod:(NSString*)userId
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    {
        if (userId.length>0)
        {
            [param setValue:userId forKey:@"userId"];
        }
    }
    [LoginNetworkRequest GetPaymentMethod:param andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         completionBlock(error, responseObject);
     }];
}









@end
