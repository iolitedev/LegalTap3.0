//
//  MyAccountViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/17/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "MyAccountViewController.h"
#import "AccountBalanceViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    
   

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUserImage];
    
    
    array_MyAccountList = @[@"ACCOUNT BALANCE",@"APPLY COUPON"
                            ,@"CHANGE EMAIL & PASSWORD"
                            ,@"UPDATE ADDRESS"
                            ,@"UPDATE CARD DETAIL"];
    [tableView_MyAccount reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *userType = [SharedSingleton sharedClient].user_Profile.userType;
    if ([userType isEqualToString:@"lawyer"])
    {
        
    }
    else
    {
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
    }

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
    
    if ([segue.identifier isEqualToString:@"MyAccountToApplyCoupon"])
    {
        
    }
    else if ([segue.identifier isEqualToString:@"MyAccountToUpdateInfo"])
    {
        
    }
    else if ([segue.identifier isEqualToString:@"MyAccountToMyAddress"])
    {
        
    }
    else if ([segue.identifier isEqualToString:@"MyAccountToPayment"])
    {
        
    }
}

-(void)setUserImage
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    
    NSString *strUrl = user_Profile.imageURL;
    
    if(![strUrl isEqualToString:@""])
    {
        NSString *imgStr = strUrl;
        
        NSURL *url = [NSURL URLWithString:imgStr];
        NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"image_placeholder"];
        
        __weak UIImageView *weakCell = imageView_ProfilePic;
        
        [weakCell setImageWithURLRequest:request1
                        placeholderImage:placeholderImage
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
        {
             weakCell.image = image;
             imageView_ProfilePic.image = image;
             [weakCell setNeedsLayout];
             [imageView_ProfilePic setNeedsLayout];
                                     
        } failure:nil];
    }
}

#pragma mark Table View Data Source Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0f;
    switch (section)
    {
        default:
            headerHeight = 0.0;
            break;
    }
    return headerHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 1;
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
            if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
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
            NSString *identifier = @"cellIdentifier1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"TEXT";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma Table View Delegates
-(void)LegalPracticeTableViewCellDidSelect:(NSString *)LegalPractive withIndexPath:(NSIndexPath *)indexPath
{
    
//    array_MyAccountList = @[@"APPLY COUPON"
//                            ,@"CHANGE EMAIL & PASSWORD"
//                            ,@"UPDATE ADDRESS"
//                            ,@"UPDATE CARD DETAIL"];

    switch (indexPath.row)
    {
        case 0:
        {
            //@"ACCOUNT BALANCE"
            AccountBalanceViewController *AccBalView = [self.storyboard instantiateViewControllerWithIdentifier:@"AccBalView"];
            [self.navigationController pushViewController:AccBalView animated:YES];

            break;
        }

        case 1:
        {
            //@"APPLY COUPON"
            [self performSegueWithIdentifier:@"MyAccountToApplyCoupon" sender:self];

            break;
        }
        case 2:
        {
            //CHANGE EMAIL & PASSWORD
            [self performSegueWithIdentifier:@"MyAccountToUpdateInfo" sender:self];

            break;
        }
        case 3:
        {
            //UPDATE ADDRESS
            [self performSegueWithIdentifier:@"MyAccountToMyAddress" sender:self];

            break;
        }
        case 4:
        {
            //UPDATE CARD DETAIL
            [self performSegueWithIdentifier:@"MyAccountToPayment" sender:self];

            break;
        }
         default:
            break;
    }
}

@end
