//
//  SignInAndSignUpHelper.h
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginNetworkRequest.h"

@interface SignInAndSignUpHelper : NSObject

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
        andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)getQuickBoxTokenWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)upLoadImageForRegisterOfUserWithImage:(UIImage*)image andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)userLoginWithUserEmail:(NSString*)email
                 withPassword:(NSString*)password
               withDeviceType:(NSString*)deviceType
              withDeviceToken:(NSString*)deviceToken
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

//emailId, userId, curPassword, newPassword, conPassword
+(void)changePasswordWithEmailId:(NSString*)emailId
                    withUserId:(NSString*)userId
                    withCurrentPassword:(NSString*)curPassword
                    withNewPassword:(NSString*)newPassword
                    withConformPassword:(NSString*)conPassword
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)updateUserDetailWithUserId:(NSString*)userId
                         withName:(NSString*)firstName
                      withAddress:(NSString*)address
                         withCity:(NSString*)city
                        withState:(NSString*)state
                     withimageUrl:(NSString*)image
                withContactNumber:(NSString*)contactNumber
                     withLastName:(NSString*)LastName
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)changeStatusWithUserId:(NSString*)userId
                   withStatus:(BOOL)status
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBloc;
+(void)FormTypeWithName:(NSString*)Name andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)BundleTypeWithName:(NSString*)Name andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)ClientsListLinkedWithLawyer:(NSString*)Name andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)RequestFormToClient:(NSString*)UserId
               withLawerId:(NSString*)LawyerId
                withFormId:(NSString*)FormId
           withDescription:(NSString*)Description
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)PurchaseFormByClient:(NSString*)ClientId
                 withFormId:(NSString*)FormId
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)GetLawyersList:(NSString*)Type
            withState:(NSString*)State
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;



+(void)RandomCallToLawyer:(NSMutableArray*)lawyerIds
               withUserId:(NSString*)userId
        WithQuestionArray:(NSArray*)questionArray
          WithAnswerArray:(NSArray*)AnswerArray
   andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)CallResponseToClient:(NSString*)clientId
                 withUserId:(NSString*)userId
               withResponse:(NSString*)response
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GetFavoriteLawyersList:(NSString*)UserId
       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)MakeLawyerToFavorite:(NSString*)userId
               withLawyerId:(NSString*)lawyerId
               withFavorite:(NSString*)favorite
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)FeedBackToLawyer:(NSString*)userId
           withLawyerId:(NSString*)lawyerId
           withFeedback:(NSString*)feedback
             withRating:(NSString*)rating
 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)LawyerDetailWithQuickBloxId:(NSString*)QuickBloxId
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)SendContactDetailsToLawyer:(NSString*)userId
                     withLawyerId:(NSString*)lawyerId
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GetForgotenPassword:(NSString*)EmailId
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)DirectPayWithCard:(NSString*)userId
              withAmount:(NSString*)amount
                withtype:(NSString*)type
              withFormId:(NSString*)FormId
            withBundleId:(NSString*)bundleId
            withLawyerId:(NSString*)LawyerId
  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)ApplyCuponCode:(NSString*)userId
        withCuponCode:(NSString*)Code
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)VerificationWithCodeWithEmail:(NSString*)emailId
                           withToken:(NSString*)token
                        withPassword:(NSString*)password
              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)AskFromLawyerToSendContactInfo:(NSString*)userId
                         withLawyerId:(NSString*)lawyerId
                          withMessage:(NSString*)msg
               andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)AskFromUserAboutReccommndForm:(NSString*)userId
                        withLawyerId:(NSString*)lawyerId
                         withMessage:(NSString*)msg
              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)RequestFormRequestFromLawyer:(NSString*)userId
                       withLawyerId:(NSString*)lawyerId
                        withMessage:(NSString*)msg
                        withRequest:(NSString*)request

             andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)SendAuthTokenToServer:(NSString*)Token
                  withUserId:(NSString*)UserId
      andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)PayWithPaypal:(NSString*)userId
          withAmount:(NSString*)amount
            withtype:(NSString*)type
          withFormId:(NSString*)FormId
        withBundleId:(NSString*)bundleId
        withLawyerId:(NSString*)LawyerId
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GetAccountBalance:(NSString*)userId
  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;


+(void)PayWithCoupons:(NSString*)userId
           withAmount:(NSString*)amount
             withtype:(NSString*)type
           withFormId:(NSString*)formId
         withBundleId:(NSString*)bundleId
         withLawyerId:(NSString*)lawyerId
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)SendPaymentMethodToServer:(NSString*)userId
                  withMethodType:(NSString*)type
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GetPaymentMethod:(NSString*)userId
 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;





@end
