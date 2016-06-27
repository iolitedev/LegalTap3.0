//
//  FormListViewController.m
//  LegalTap
//
//  Created by Sandeep Kumar on 3/25/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "FormListViewController.h"
#import "FormShopObject.h"

@interface FormListViewController ()

@end

@implementation FormListViewController
@synthesize Type,SelectedFormType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        
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

    
   
    
    // Do any additional setup after loading the view.
    
    if ([Type isEqualToString:@"FormType"])
    {
        _array_List = [[CommonHelper legalPracticeList] mutableCopy];
        [_array_List removeObjectAtIndex:0];
    }
    else if ([Type isEqualToString:@"FormList"])
    {
        if ([SelectedFormType isEqualToString:@"WILL AND TRUSTS"])
        {
           SelectedFormType=@"WILL";
        }
        else if ([SelectedFormType isEqualToString:@"TRADEMARKS & COPYRIGHTS"])
        {
            SelectedFormType=@"TRADEMARKS AND COPYRIGHTS";
        }
        
        [self GetFormsAccToCase:SelectedFormType];
    }
    else if ([Type isEqualToString:@"UserSettigs"])
    {
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        NSString *LawyerId=user_Profile.userId;
        [self GetFavoriteLawyers:LawyerId];
        
    }
    else
    {
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        NSString *LawyerId=user_Profile.userId;
        [self GetClientsList:LawyerId];
    }
    
    [tableView_List reloadData];
}
//getfavlawyer.php
//param: userId
-(void)GetFormsAccToCase:(FormShopObject*)FormType
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [SignInAndSignUpHelper FormTypeWithName:FormType.formTypeId
                           andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
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
                     [tableView_List reloadData];
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
//             [alert show];
         }
     }];
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
                     [tableView_List reloadData];
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

-(void)GetClientsList:(NSString *)LawyerId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper ClientsListLinkedWithLawyer:LawyerId
                     andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
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
                     [tableView_List reloadData];
                     
                     
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            number = _array_List.count;
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
            if (indexPath.row == _array_List.count)
            {
                headerHeight = 20.0;
                
            }
            else
            {
//                if (indexPath.row == 0)
//                {
//                    headerHeight = 108.0;
//                }
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
            NSString *identifier = @"LegalPracticeTableViewCell";
            LegalPracticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
                cell = [array firstObject];
            }
            
            cell.delegate = self;
            
            NSString *strTitle;
            if ([Type isEqualToString:@"FormType"])
            {
                strTitle =  _array_List[indexPath.row];
 
            }
            else if ([Type isEqualToString:@"FormList"])
            {
                if (_array_List.count>0)
                {
                    strTitle =  [[_array_List objectAtIndex:indexPath.row] valueForKey:@"FormName"];

                }
            }
            else if ([Type isEqualToString:@"UserSettigs"])
            {
                NSString *FirstName=[[_array_List objectAtIndex:indexPath.row] valueForKey:@"firstName"];
                NSString *LastName=[[_array_List objectAtIndex:indexPath.row] valueForKey:@"lastname"];
                
                NSString *FullName=[NSString stringWithFormat:@"%@ %@",FirstName,LastName];
                strTitle =  FullName;

            }

            else
            {
                if (_array_List.count>0)
                {
                    strTitle =  [[_array_List objectAtIndex:indexPath.row] valueForKey:@"userName"];
                    
                }
            }

            cell.textTitle = strTitle;
            cell.accessibilityIdentifier = strTitle;
            
            
//            if (indexPath.row == 0)
//            {
//                cell.textTitle = @"Legal Practice Table View Cell Legal Practice Table View Cell";
//                cell.contentView.frame = CGRectMake(0,
//                                                    0, CGRectGetWidth(tableView.frame), 108);
//                [cell.contentView layoutIfNeeded];
//
//                cell.frame = CGRectMake(CGRectGetMinX(cell.frame),
//                                        CGRectGetMinY(cell.frame), CGRectGetWidth(tableView.frame), 108);
//            }

            cell.indexPath = indexPath;
            
            [cell layoutIfNeeded];
            return cell;
            
        }
        default:
        {
            return nil;
        }
    }
}

#pragma Table View Delegates

-(void)LegalPracticeTableViewCellDidSelect:(NSString *)LegalPractive withIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            
        }
        default:
        {
            if ([_delegate respondsToSelector:@selector(FormListViewControllerDidSelect:withId:withDesc:withPrice:withIndexPath:)])
            {
                if ([Type isEqualToString:@"FormType"])
                {
                   // [_delegate FormListViewControllerDidSelect:_array_List[indexPath.row] withIndexPath:indexPath];
                    [_delegate FormListViewControllerDidSelect:_array_List[indexPath.row] withId:@"" withDesc:@"" withPrice:@"" withIndexPath:indexPath];
                    
 
                }
                else if ([Type isEqualToString:@"FormList"])
                {
                   // [_delegate FormListViewControllerDidSelect:[[_array_List objectAtIndex:indexPath.row] valueForKey:@"FormName"] withIndexPath:indexPath];
                    
                    [_delegate FormListViewControllerDidSelect:[[_array_List objectAtIndex:indexPath.row] valueForKey:@"FormName"] withId:[[_array_List objectAtIndex:indexPath.row] valueForKey:@"id"] withDesc:[[_array_List objectAtIndex:indexPath.row] valueForKey:@"description"] withPrice:[[_array_List objectAtIndex:indexPath.row] valueForKey:@"price"] withIndexPath:indexPath];
                }
                else
                {
                   // [_delegate FormListViewControllerDidSelect:[[_array_List objectAtIndex:indexPath.row] valueForKey:@"userName"] withIndexPath:indexPath];
                    [_delegate FormListViewControllerDidSelect:[[_array_List objectAtIndex:indexPath.row] valueForKey:@"userName"] withId:[[_array_List objectAtIndex:indexPath.row] valueForKey:@"userId"] withDesc:@"" withPrice:@"" withIndexPath:indexPath];

  
                }

            }
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

@end
