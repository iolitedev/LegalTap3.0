//
//  LoginNetworkRequest.h
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginNetworkRequest : NSObject

+ (void)registerUserWithParameters:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+ (void)getQuickBoxTokenWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+ (void)upLoadImageForRegisterOfUserWithImage:(UIImage*)image
                       andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+ (void)loginUserWithParameters:(NSDictionary*)parameters
         andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)changePasswordWithParameters:(NSDictionary*)parameters
             andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)updateUserDetailWithParameters:(NSDictionary*)parameters
               andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;

+(void)changeStatusWithParameters:(NSDictionary*)parameters
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GetFormsList:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GetBundleList:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GetClientsListLinkedWithLawyer:(NSDictionary*)parameters
               andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)RequestFormToClient:(NSDictionary*)parameters
    andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)RequestToPurchaseFormByClient:(NSDictionary*)parameters
              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)RequestToGetLawyersList:(NSDictionary*)parameters
        andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)RequestToRandomCallToLawyer:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)CallResponseToClient:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)RequestToGetFavLawyersList:(NSDictionary*)parameters
           andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)MakeLawyerToFavorite:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GiveFeedbackToLawyer:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)LawyerDetailWithQuickBloxId:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)SendContactDetailToLawyer:(NSDictionary*)parameters
          andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)ForgotPassword:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)DirectPayFromCard:(NSDictionary*)parameters
  andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)ApplyCuponCode:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)VerifyCode:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)AskFromLayerToSendContactRequest:(NSDictionary*)parameters
                 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)AskFromUserAboutReccomendForm:(NSDictionary*)parameters
              andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)AcceptFormRequestFromLawyer:(NSDictionary*)parameters
            andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)TokenRequestToServer:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)PayWithPaypalAccount:(NSDictionary*)parameters
     andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)AccountBalance:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)PayWithCoupon:(NSDictionary*)parameters
andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)SetPaymentMethod:(NSDictionary*)parameters
 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;
+(void)GetPaymentMethod:(NSDictionary*)parameters
 andWithCompletionBlock:(RequestCompletionHandler_ResponseDictonary)completionBlock;





@end
