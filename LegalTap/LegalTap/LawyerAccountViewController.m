//
//  LawyerAccountViewController.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/25/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "LawyerAccountViewController.h"

@interface LawyerAccountViewController ()

@end

@implementation LawyerAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:backButton];
        lbl_LoginStatus.layer.borderWidth = 1.0;
    lbl_LoginStatus.layer.borderColor = [UIColor greenColor].CGColor;
    [self setUserImage];
    
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    [self changeStateWithBool:user_Profile.onlineStatus];
    lbl_Name.text = user_Profile.name;
}
- (void)backBarButton
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchChangeStatusForUserLogin:(UISwitch *)sender
{
    [self changeStateWithBool:sender.on];
}

-(void)changeStateWithBool:(BOOL)flag
{
    switch_LoginStatusChange.userInteractionEnabled = NO;
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    if (user_Profile && user_Profile.userId.length)
    {
        [SignInAndSignUpHelper changeStatusWithUserId:user_Profile.userId
                                           withStatus:flag andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             if (!error)
             {
                 NSLog(@"%@\nLogin Status",responseObject);
                 if (flag)
                 {
                     lbl_LoginStatus.text = @"Online";
                     lbl_LoginStatus.layer.borderColor = [UIColor greenColor].CGColor;
                     lbl_LoginStatus.textColor = [UIColor greenColor];
                 }
                 else
                 {
                     lbl_LoginStatus.text = @"Offline";
                     lbl_LoginStatus.layer.borderColor = [UIColor redColor].CGColor;
                     lbl_LoginStatus.textColor = [UIColor redColor];
                 }
                 user_Profile.onlineStatus = flag;
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Try Again.."
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
             switch_LoginStatusChange.userInteractionEnabled = YES;
         }];
    }
}

//UserImage
-(void)setUserImage
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    if (user_Profile.image)
    {
        imageView_UserImage.image = user_Profile.image;
        imageView_UserBGImage.image = user_Profile.image;
    }
    else
    {
        NSString *strUrl = user_Profile.imageURL;
        
        if(![strUrl isEqualToString:@""])
        {
            NSString *imgStr = strUrl;
            NSURL *url = [NSURL URLWithString:imgStr];
            NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@"image_placeholder"];
            
            __weak UIImageView *weakCell = imageView_UserImage;
            
            
            [weakCell setImageWithURLRequest:request1
                            placeholderImage:placeholderImage
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 
                 weakCell.image = image;
                 imageView_UserImage.image = image;
                 imageView_UserBGImage.image = image;
                 user_Profile.image = image;
                 
                 [weakCell setNeedsLayout];
             } failure:nil];
        }
    }
}

@end
