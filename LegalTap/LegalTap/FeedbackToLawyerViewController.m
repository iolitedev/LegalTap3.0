//
//  FeedbackToLawyerViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/16/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "FeedbackToLawyerViewController.h"

@interface FeedbackToLawyerViewController ()

@end

@implementation FeedbackToLawyerViewController
@synthesize LawyerQuickBloxId;
- (void)viewDidLoad
{
    RatingValue=@"3";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    blurView.blurRadius = 8.0;
    blurView.tintColor = [UIColor colorWithRed:0.0/255.0f green:133/255.0f blue:198/255.0f alpha:1];
    DescBg.layer.borderWidth=2.0;
    DescBg.layer.cornerRadius=5.0;
    DescBg.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    [self GetLawyerDetailWithQuickBloxId:@"2603666"];
    [self GetLawyerDetailWithQuickBloxId:LawyerQuickBloxId];
}

-(void)GetLawyerDetailWithQuickBloxId:(NSString *)lawyerQuickBloxId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper LawyerDetailWithQuickBloxId:lawyerQuickBloxId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     NSString *UserName=[[responseObject valueForKey:@"data"] valueForKey:@"firstName"];
                     lbl_LawyerName.text=UserName;
                 //    NSString *imageUrl=[[responseObject valueForKey:@"data"] valueForKey:@"userImage"];
                     LawyerId=[[responseObject valueForKey:@"data"] valueForKey:@"id"];
                 }
                 else
                 {
                     //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //  message:@"Try Again."
                     //  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     // [alert show];
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:errorMsg
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Try Again.."
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (IBAction)btnClicked_RateLawyer:(UIButton *)sender
{    
    UIImage *onImage = [UIImage imageNamed:@"RateStar_On"];
    UIImage *offImage = [UIImage imageNamed:@"RateStar_Off"];
    [self blankStars];
    RatingValue=[NSString stringWithFormat:@"%ld",(long)[sender tag]];
    switch (sender.tag)
    {
        case 5:
            //Star 1
            [btn_Star5 setImage:onImage forState:UIControlStateNormal];
            [btn_Star5 setImage:offImage forState:UIControlStateHighlighted];
        case 4:
            //Star 2
            [btn_Star4 setImage:onImage forState:UIControlStateNormal];
            [btn_Star4 setImage:offImage forState:UIControlStateHighlighted];
        case 3:
            //Star 3
            [btn_Star3 setImage:onImage forState:UIControlStateNormal];
            [btn_Star3 setImage:offImage forState:UIControlStateHighlighted];
        case 2:
            //Star 4
            [btn_Star2 setImage:onImage forState:UIControlStateNormal];
            [btn_Star2 setImage:offImage forState:UIControlStateHighlighted];
        case 1:
            //Star 5
            [btn_Star1 setImage:onImage forState:UIControlStateNormal];
            [btn_Star1 setImage:offImage forState:UIControlStateHighlighted];
            break;
        default:
            break;
    }
}

- (IBAction)btnClickedFev:(UIButton *)sender
{
    UIImage *selectedImage = [UIImage imageNamed:@"Heart_On"];
    UIImage *highlightedImage = [UIImage imageNamed:@"Heart_Off"];
    
    if (sender.tag == 1)
    {
        [sender setImage:highlightedImage forState:UIControlStateNormal];
        [sender setImage:selectedImage forState:UIControlStateHighlighted];
        sender.tag = 0;
        [self RemoveLawyerToFavorite];
        
    }
    else
    {
        [sender setImage:selectedImage forState:UIControlStateNormal];
        [sender setImage:highlightedImage forState:UIControlStateHighlighted];
        sender.tag = 1;
        [self MakeLawyerToFavorite];

    }
}

-(void)blankStars
{
    UIImage *onImage = [UIImage imageNamed:@"RateStar_On"];
    UIImage *offImage = [UIImage imageNamed:@"RateStar_Off"];
    [btn_Star1 setImage:offImage forState:UIControlStateNormal];
    [btn_Star2 setImage:offImage forState:UIControlStateNormal];
    [btn_Star3 setImage:offImage forState:UIControlStateNormal];
    [btn_Star4 setImage:offImage forState:UIControlStateNormal];
    [btn_Star5 setImage:offImage forState:UIControlStateNormal];
    [btn_Star1 setImage:onImage forState:UIControlStateHighlighted];
    [btn_Star2 setImage:onImage forState:UIControlStateHighlighted];
    [btn_Star3 setImage:onImage forState:UIControlStateHighlighted];
    [btn_Star4 setImage:onImage forState:UIControlStateHighlighted];
    [btn_Star5 setImage:onImage forState:UIControlStateHighlighted];
}
- (IBAction)SubmitButton:(id)sender
{
    if ([textView_Info.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Feedback" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self FeedBackToLawyer];
}

-(void)FeedBackToLawyer
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *UserId=user_Profile.userId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper FeedBackToLawyer:UserId withLawyerId:LawyerId withFeedback:textView_Info.text withRating:RatingValue andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Your Feedback Sent" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                     textView_Info.text=@"";
//                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                 }
                 else
                 {
                 }
              }
             else
             {
                 //Empty Response
//                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
//                 
//                 NSString *errorMsg = [responseObject valueForKey:@"message"];
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                 message:errorMsg
//                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                 [alert show];
                 UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Your Feedback Sent" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
                 textView_Info.text=@"";
             }
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Try Again.."
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSArray *array = self.navigationController.viewControllers;
        UITabBarController *tabBarViewControl;
        for (id obj in array)
        {
            if ([obj isKindOfClass:[UITabBarController class]])
            {
                tabBarViewControl = (UITabBarController*)obj;
            }
        }

        if (tabBarViewControl)
        {
//            tabBarViewControl.viewControllers
            NSArray *arr = tabBarViewControl.viewControllers;
            UINavigationController *myHomeNavigationController = [arr objectAtIndex:0];
            [myHomeNavigationController popToRootViewControllerAnimated:YES];
            HomeViewController *homeVC = [myHomeNavigationController.viewControllers firstObject];
            homeVC.isListExpended = NO;
            [homeVC reloadtableView];
            [self.navigationController popToViewController:tabBarViewControl animated:YES];
        }
    }
}

-(void)MakeLawyerToFavorite
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *UserId=user_Profile.userId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper MakeLawyerToFavorite:UserId withLawyerId:LawyerId withFavorite:@"1" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Lawyer Added to Favorite" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 else
                 {
                     //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //  message:@"Try Again."
                     //  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     // [alert show];
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 
                 NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:errorMsg
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Try Again.."
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}
-(void)RemoveLawyerToFavorite
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *UserId=user_Profile.userId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper MakeLawyerToFavorite:UserId withLawyerId:LawyerId withFavorite:@"0" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue]==1)
                 {
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Lawyer Removed to Favorite" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 else
                 {
                     //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                     //  message:@"Try Again."
                     //  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     // [alert show];
                 }
             }
             else
             {
                 //Empty Response
                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
                 
                 NSString *errorMsg = [responseObject valueForKey:@"message"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:errorMsg
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }
         else
         {
             //Error
             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Try Again.."
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

#pragma mark - Text View Delegates

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self textViewChangeText:textView];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    [self textViewChangeText:textView];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self textViewChangeText:textView];
}

-(void)textViewChangeText:(UITextView*)textView
{
    if ([textView.text isEqualToString:@""])
    {
         lbl_PlaceholderTextView.hidden = NO;
    }
    else
    {
        lbl_PlaceholderTextView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
