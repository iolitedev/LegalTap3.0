//
//  FavoriteLawyerViewController.m
//  LegalTap
//
//  Created by Vikram on 07/04/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "FavoriteLawyerViewController.h"

@interface FavoriteLawyerViewController ()

@end

@implementation FavoriteLawyerViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:32/255.0 green:122/255.0 blue:192/255.0 alpha:1]];
    UIImage *navBarImg = [UIImage imageNamed:@""];
    [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    
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
    
    statusBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueImage2"]];
    [self.navigationController.navigationBar addSubview:statusBarView];

    [super viewDidLoad];
    
    _array_List=[[NSMutableArray alloc] init];
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *ClientId=user_Profile.userId;
    [self GetFavoriteLawyers:ClientId];
    // Do any additional setup after loading the view.
}
- (void)backBarButton
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)GetFavoriteLawyers:(NSString*)UserId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper GetFavoriteLawyersList:UserId andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 NSArray *detailUser = [responseObject objectForKey:@"data"];
                 if (detailUser && detailUser.count)
                 {
                     _array_List = [detailUser mutableCopy];
                     [tableViewFav reloadData];
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
//                 [alert show];
                 //[self.navigationController popViewControllerAnimated:YES];
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
-(void)MakeLawyerToFavorite:(NSString *)LawyerId
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    NSString *UserId = user_Profile.userId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper MakeLawyerToFavorite:UserId withLawyerId:LawyerId withFavorite:@"1" andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 if ([[responseObject valueForKey:@"success"] integerValue] == 1)
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
//                 [alert show];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *FirstName=[[_array_List objectAtIndex:indexPath.row] valueForKey:@"firstName"];
    NSString *LastName=[[_array_List objectAtIndex:indexPath.row] valueForKey:@"lastname"];
    NSString *FullName=[NSString stringWithFormat:@"%@ %@",FirstName,LastName];
    CGFloat newMessage;
    if (IS_IPHONE_6P)
    {
        newMessage = [self calculateRowHeightWithNewMethod:FullName font:[UIFont systemFontOfSize:14] width:200];
    }
    else
        newMessage = [self calculateRowHeightWithNewMethod:FullName font:[UIFont systemFontOfSize:14] width:170];
        return newMessage +20;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array_List count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(favBtnClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Schedule An Appointment" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:(70/255.0) green:(130/255.0) blue:(180/255.0) alpha:1]];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.frame = CGRectMake(25, 0, 160, 30);
    button.layer.cornerRadius=3.0;
    button.tag=indexPath.row;
    cell.accessoryView = button;
    NSString *FirstName=[[_array_List objectAtIndex:indexPath.row] valueForKey:@"firstName"];
    NSString *LastName=[[_array_List objectAtIndex:indexPath.row] valueForKey:@"lastname"];
    NSString *FullName=[NSString stringWithFormat:@"%@ %@",FirstName,LastName];
    CGFloat newMessage;
    UILabel *labelName;
    if (IS_IPHONE_6P)
    {
        newMessage = [self calculateRowHeightWithNewMethod:FullName font:[UIFont systemFontOfSize:14] width:200];
        labelName = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, newMessage)];
    }
    else
    {
        newMessage = [self calculateRowHeightWithNewMethod:FullName font:[UIFont systemFontOfSize:14] width:170];
        labelName = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 170, newMessage)];
    }
    
    labelName.text = FullName;
    labelName.numberOfLines = 0;
    [labelName setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:labelName];
    
    return cell;
}
-(IBAction)favBtnClicked:(id)sender
{
    NSInteger index=[sender tag];
    NSLog(@"%ld",(long)index);
    NSString *LawyerId=[[_array_List objectAtIndex:index] valueForKey:@"lawyerId"];
   // [[NSUserDefaults standardUserDefaults] setValue:LawyerId forKey:@"FavLawyerId"];
   // [self MakeLawyerToFavorite:LawyerId];
       // UIViewController * fromView = self.tabBarController.selectedViewController;
    UINavigationController * toView = [self.tabBarController.viewControllers objectAtIndex:1];
    NSArray *arr = @[[toView.viewControllers firstObject]];
    toView.viewControllers = arr;
    MyAppointmentViewController *myap = [arr firstObject];
    myap.LawyerIdFromSettings = LawyerId;
    [self.tabBarController setSelectedIndex:1];
//    [self.tabBarController setSelectedViewController:toView];
        //        toView.lau = @"5";
}

#pragma mark --calculateRowHeight
- (CGFloat)calculateRowHeightWithNewMethod:(NSString *)text font:(UIFont *)font width:(CGFloat)width
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 10)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGRect frame = label.frame;
    CGSize size = frame.size;
       {
        if(size.height<21)
        {
            return 21;
        }
    }
    return size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
