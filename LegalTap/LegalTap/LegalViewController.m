//
//  LegalViewController.m
//  LegalTap
//
//  Created by Vikram on 08/04/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "LegalViewController.h"

@interface LegalViewController ()

@end

@implementation LegalViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    
    NSString *userType = [SharedSingleton sharedClient].user_Profile.userType;
    if ([userType isEqualToString:@"lawyer"])
    {
    }
    else
    {
        UIView *statusBarView;
        if (IS_IPHONE_6)
        {
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 380, 22)];
        }
        else if (IS_IPHONE_6P)
        {
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 420, 22)];
        }
        
        else
        {
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 22)];
        }
        statusBarView.backgroundColor = [UIColor colorWithRed:70/255.0f green:130/255.0f blue:180/255.0f alpha:1.0f];
        [self.navigationController.navigationBar addSubview:statusBarView];
        UIImage *navBarImg = [UIImage imageNamed:@"Navigation_bg_white"];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    }
    self.title=@"Legal";
    label1.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
    label2.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
    label3.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
    label4.font = [UIFont fontWithName:@"OpenSans-Light" size:13];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        ScrollView.contentSize = CGSizeMake(320,600);
    }
    else if (IS_IPHONE_5)
    {
        ScrollView.contentSize = CGSizeMake(320,620);
    }
    else if (IS_IPHONE_6)
    {
        ScrollView.contentSize = CGSizeMake(320,620);
        label1.frame=CGRectMake(label1.frame.origin.x,label1.frame.origin.y+15,label1.frame.size.width,label1.frame.size.height);
    }
    else{
        ScrollView.contentSize = CGSizeMake(320,620);
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)PrivacyPolicy:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@privacy-policy/#slogan",CSAPIBaseURLString]]];
}

- (IBAction)UserTermsOfUse:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@terms-of-use/#slogan",CSAPIBaseURLString]]];
}

- (IBAction)LawyerTermsOfUse:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@attorney-terms-of-use/#slogan",CSAPIBaseURLString]]];
}

- (IBAction)BackBarButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
