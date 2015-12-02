//
//  LetsStartedViewController.m
//  LegalTap
//
//  Created by Apptunix on 2/27/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "LetsStartedViewController.h"

@interface LetsStartedViewController ()

@end

@implementation LetsStartedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _array_LegalPracticeList = [CommonHelper legalPracticeList];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table View Data Source Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0f;
    switch (section)
    {
        case 1:
            headerHeight = 50.0;
            break;
            
        default:
            headerHeight = 0.0;
            break;
    }
    return headerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 1:
        {
            NSString *headerTitle = @"HOW CAN WE HELP YOU?";
            UIView *headerView = [[UIView alloc] init];
            {
                headerView.frame = CGRectMake(0,
                                              0,
                                              CGRectGetWidth(tableView.frame),
                                              50.0);
                headerView.backgroundColor = [UIColor whiteColor];
                
                UILabel *lbl_HeaderTitle = [[UILabel alloc] init];
                {
                    lbl_HeaderTitle.frame = CGRectMake(10,
                                                       0,
                                                       CGRectGetWidth(tableView.frame)-20,
                                                       50.0);
                    lbl_HeaderTitle.text = headerTitle;
                    lbl_HeaderTitle.backgroundColor = defColor_CellBackground;
                    lbl_HeaderTitle.textAlignment = NSTextAlignmentCenter;
                    
                    lbl_HeaderTitle.font = [UIFont boldSystemFontOfSize:14.0];
                    
                    //                    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:lbl_HeaderTitle.bounds];
                    //                    lbl_HeaderTitle.layer.masksToBounds = NO;
                    //                    lbl_HeaderTitle.layer.shadowColor = [UIColor blackColor].CGColor;
                    //                    lbl_HeaderTitle.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
                    //                    lbl_HeaderTitle.layer.shadowOpacity = 0.15f;
                    //                    lbl_HeaderTitle.layer.shadowPath = shadowPath.CGPath;
                    
                }
                [headerView addSubview:lbl_HeaderTitle];
            }
            return headerView;
            break;
        }
        default:
            return nil;
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 1;
    switch (section)
    {
        case 0:
            number = 1;
            break;
        case 1:
            number = _array_LegalPracticeList.count+1;
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
    switch (indexPath.section) {
        case 0:
        {
            UIImage *img_Logo = [UIImage imageNamed:@"Logo"];
            headerHeight = img_Logo.size.height;
            break;
        }
        case 1:
        {
            if (indexPath.row == _array_LegalPracticeList.count)
            {
                headerHeight = 20.0;                headerHeight = 58.0;
                
            }
            else
            {
                
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
        case 0://Logo
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
            
            UIImage *img_Logo = [UIImage imageNamed:@"Logo"];
            UIImageView *imageView_Logo = [[UIImageView alloc] init];
            {
                imageView_Logo.frame = CGRectMake(0,
                                                  0,
                                                  img_Logo.size.width*0.6,
                                                  img_Logo.size.height*0.6);
                imageView_Logo.center = CGPointMake(CGRectGetWidth(tableView.frame)/2,
                                                    img_Logo.size.height/2);
                imageView_Logo.image = img_Logo;
            }
            [cell.contentView addSubview:imageView_Logo];
            
            return cell;
        }
        case 1://List
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
                
                NSString *strTitle =  _array_LegalPracticeList[indexPath.row];
                cell.textTitle = strTitle;
                cell.indexPath = indexPath;
                cell.accessibilityIdentifier = strTitle;
                
                NSString *strImageName = [strTitle lowercaseString];
                {
                    //                    strImageName = [strImageName stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
                    strImageName = [strImageName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                    strImageName = [NSString stringWithFormat:@"LP_%@",strImageName];
                }
                cell.imageView_Icon.image = [UIImage imageNamed:strImageName];
                cell.imgName = strImageName;
                
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
