//
//  SettingsViewController.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/18/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "SettingsViewController.h"
#import "LegalViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Mixpanel analytics
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [mixpanel track:@"Settings" properties:@{@"method": @"Settings",}];
    // Do any additional setup after loading the view.
    NSString *userType = [SharedSingleton sharedClient].user_Profile.userType;
    if ([userType isEqualToString:@"lawyer"])
    {
        array_MyAccountList = @[@"HELP"
                                ,@"MY ACCOUNT",@"LEGAL"
                                ,@"LOGOUT"];
    }
    else
    {
        array_MyAccountList = @[@"HELP"
                                ,@"MY ACCOUNT"
                                ,@"MY FAVORITE LAWYERS",@"LEGAL",@"LOGOUT"];
    }

    [tableView_Settings reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //SettingsToMeetUs
    //SettingsToMyAccount
    if ([segue.identifier isEqualToString:@"SettingsToMeetUs"])
    {
        
    }
    else if([segue.identifier isEqualToString:@"SettingsToMyAccount"])
    {
        
    }
    else if([segue.identifier isEqualToString:@"SettingToLawyerAccount"])
    {
        
    }
}

- (IBAction)btnClicked_Logout:(UIButton *)sender
{
//    if ([[SharedSingleton sharedClient].user_Profile.userType isEqualToString:@"lawyer"])
//    {
//        UserProfile *user_Profile = [[UserProfile alloc] init];
//        user_Profile.userType = @"user";
//        [SharedSingleton sharedClient].user_Profile = user_Profile;
//        [self.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        UserProfile *user_Profile = [[UserProfile alloc] init];
//        user_Profile.userType = @"lawyer";
//        [SharedSingleton sharedClient].user_Profile = user_Profile;
//        [self.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:YES];
//    }
    
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    if (user_Profile && user_Profile.userId.length)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [SignInAndSignUpHelper changeStatusWithUserId:user_Profile.userId
                                           withStatus:NO andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

             NSLog(@"%@\nLogin Status",responseObject);
             
             [CommonHelper removeUserDetail];
             [SharedSingleton sharedClient].user_Profile = nil;

             [self.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:YES];
         }];
    }
}

- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender
{
    [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
    
}

- (IBAction)LinkButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CSBaseURLStringWithoutAPi]];

}
-(void)changeStateWithBool:(BOOL)flag
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    
    if (user_Profile && user_Profile.userId.length)
    {
        [SignInAndSignUpHelper changeStatusWithUserId:user_Profile.userId
                                           withStatus:flag andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             if (!error)
             {
                 NSLog(@"%@\nLogin Status",responseObject);
//                 if (flag)
//                 {
//                     lbl_LoginStatus.text = @"Online";
//                     lbl_LoginStatus.layer.borderColor = [UIColor greenColor].CGColor;
//                     lbl_LoginStatus.textColor = [UIColor greenColor];
//                 }
//                 else
//                 {
//                     lbl_LoginStatus.text = @"Offline";
//                     lbl_LoginStatus.layer.borderColor = [UIColor redColor].CGColor;
//                     lbl_LoginStatus.textColor = [UIColor redColor];
//                 }
//                 user_Profile.onlineStatus = flag;
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Try Again.."
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
}


#pragma mark Table View Data Source Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section)
    {
        case 0:
            number = array_MyAccountList.count+1;
            break;
            
        default:
            number = 0;
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat headerHeight = 0.0f;
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == array_MyAccountList.count)
            {
                headerHeight = 20.0;
                
            }
            else
            {
                headerHeight = 58.0;
            }
            break;
        }
        default:
            headerHeight = 0.0;
            break;
    }
    return headerHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0://List
        {
            if (indexPath.row == array_MyAccountList.count)
            {
                NSString *identifier = @"cellIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                }
                for (UIView *view in cell.contentView.subviews)
                {
                    [view removeFromSuperview];
                }
                UIImageView *imageView_Logo = [[UIImageView alloc] init];
                {
                    imageView_Logo.frame = CGRectMake(10,
                                                      -4,
                                                      CGRectGetWidth(tableView.frame)-20,
                                                      14);
                    imageView_Logo.layer.cornerRadius = 4;
                    
                    imageView_Logo.backgroundColor = defColor_CellBackground;
                    
                }
                [cell.contentView addSubview:imageView_Logo];
                cell.clipsToBounds = YES;
                return cell;
            }
            else
            {
                NSString *identifier = @"LegalPracticeTableViewCell";
                LegalPracticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell)
                {
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
                    cell = [array firstObject];
                }
                
                cell.delegate = self;
                NSString *strTitle =  array_MyAccountList[indexPath.row];
                cell.textTitle = strTitle;
                cell.indexPath = indexPath;
                cell.accessibilityIdentifier = strTitle;
                
                [cell layoutIfNeeded];
                return cell;
            }
            
        }
        default:
        {
            return nil;
        }
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma Table View Delegates
-(void)LegalPracticeTableViewCellDidSelect:(NSString *)LegalPractive withIndexPath:(NSIndexPath *)indexPath
{

    //    array_MyAccountList = @[@"MEET US"
//                            ,@"MY ACCOUNT"
//                            ,@"LOGOUT"];
    
    //SettingsToMeetUs
    //SettingsToMyAccount
    NSString *userType = [SharedSingleton sharedClient].user_Profile.userType;
    if ([userType isEqualToString:@"lawyer"])
    {
        switch (indexPath.row)
        {
            case 0:
            {
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Lawyer Help" properties:@{
                                                            @"method": @"Lawyer Help",
                                                            }];

                //HELP
                [self performSegueWithIdentifier:@"SettingsToMeetUs" sender:self];
                
                break;
            }
            case 1:
            {
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Lawyer Account" properties:@{
                                                            @"method": @"Lawyer Account",
                                                            }];

                //MY ACCOUNT
                
                UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
                
                if ([user_Profile.userType isEqualToString:@"user"])
                {
                    [self performSegueWithIdentifier:@"SettingsToMyAccount" sender:self];
                }
                else
                {
                    [self performSegueWithIdentifier:@"SettingToLawyerAccount" sender:self];
                }
                break;
            }
            case 2:
            {
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Lawyer Legal" properties:@{
                                                               @"method": @"Lawyer Legal",
                                                               }];

                //LEGAL
                
                LegalViewController *LegalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LegalVc"];
                [self.navigationController pushViewController:LegalVC animated:YES];
                
              break;
            }
            case 3:
            {
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Lawyer Logout" properties:@{
                                                               @"method": @"Lawyer Logout",
                                                               }];

                //LOGOUT
                [self changeStateWithBool:NO];
                [CommonHelper removeUserDetail];
                [SharedSingleton sharedClient].user_Profile = nil;
                [[QBChat instance] logout];
                [self.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:YES];
                break;
            }
            default:
                break;
        }
  
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
            {
                //Help
                
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Client Help" properties:@{
                                                         @"method": @"Client Help",
                                                         }];

                [self performSegueWithIdentifier:@"SettingsToMeetUs" sender:self];
                
                break;
            }
            case 1:
            {
      
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Client Account" properties:@{
                                                     @"method": @"Client Account",
                                                     }];
                //MY ACCOUNT
                UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
                
                if ([user_Profile.userType isEqualToString:@"user"])
                {
                    [self performSegueWithIdentifier:@"SettingsToMyAccount" sender:self];
                }
                else
                {
                    [self performSegueWithIdentifier:@"SettingToLawyerAccount" sender:self];
                }
                break;
            }
                
            case 2:
            {
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Client Favorite Lawyer" properties:@{
                                                           @"method": @"Client Favorite Lawyer",
                                                           }];

                //FAVORITE LAWYERS
                
                //type=@"UserSettigs";
                //            FormListViewController *FormListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FormListVC"];
                //            FormListVC.delegate = self;
                //            FormListVC.Type=type;
                //            [self.navigationController pushViewController:FormListVC animated:YES];
                
                FavoriteLawyerViewController *FavListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FavLawyer"];
                [self.navigationController pushViewController:FavListVC animated:YES];
                
                
                
                break;
            }
            case 3:
            {
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Client Legal" properties:@{
                                                                @"method": @"Client Legal",
                                                                }];

                //LEGAL
                
                LegalViewController *LegalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LegalVc"];
                [self.navigationController pushViewController:LegalVC animated:YES];
                
                break;
            }
            case 4:
            {
                //Mixpanel analytics
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                
                [mixpanel track:@"Client Logout" properties:@{
                                                      @"method": @"Client Logout",
                                                      }];

                //LOGOUT
                [CommonHelper removeUserDetail];
                [SharedSingleton sharedClient].user_Profile = nil;
                [[QBChat instance] logout];
                [self.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:YES];
                break;
            }


            default:
                break;
        }

    }
    
   }

@end
