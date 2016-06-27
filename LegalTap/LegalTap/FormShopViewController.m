//
//  FormShopViewController.m
//  LegalTap
//
//  Created by Praveen on 9/21/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "FormShopViewController.h"
#import "FormShopCollectionViewCell.h"
#import "FormShopTableViewCell.h"
#import "FormShopListViewController.h"
#import "FormDetailViewController.h"
#import "FormShopHelper.h"
#import "FormShopObject.h"
#import "HomeViewController.h"
@interface FormShopViewController ()

{
    UIView *objView;
    UIButton *objplayButton;
    HomeViewController *home;
}
@end

@implementation FormShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor colorWithRed:0/255.0f green:133/255.0f blue:198/255.0f alpha:1.0f]];
    [self.navigationItem setLeftBarButtonItem:backButton];

    
    
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
    _arrayBundleList_Categories = [NSMutableArray new];
    _arrayList_Categories = [NSMutableArray new];
//    _arrayList_Categories = [[CommonHelper formShopList] mutableCopy];;
    // Home Shop ternding Bundles API
    [self getFormShop_Bundles];
    [self getFormShop_Categories];
    [self getBundleCategory];
    
    if (IS_IPHONE_4_OR_LESS)
    {
        _tableView_MainFormShop.frame = CGRectMake(0, 200, 320, 250);
        _tableView_MainFormShop.scrollEnabled = YES;
    }
    
}
- (void)backBarButton
{
    [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
//    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)viewWillAppear:(BOOL)animated
{
    UIImage *navBarImg = [UIImage imageNamed:@"Navigation_bg"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender
{
    [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
}

-(IBAction)Btn_SeeAll:(UIButton *)sender
{
    FormShopListViewController *objFormShopListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormShopListVC"];
    objFormShopListViewController.navigation = self.navigationController;
    if (sender.tag == 0)
    {
//        FormShopBundleCategoryViewController *category = [self.storyboard instantiateViewControllerWithIdentifier:@"bundleCategory"];
//        [self.navigationController pushViewController:category animated:TRUE];
        objFormShopListViewController.type  = FormshopListView4;
        objFormShopListViewController.formDataArray = _arrayBundleList_Categories;
    }
    else
    {
        objFormShopListViewController.type  = FormshopListView3;
        objFormShopListViewController.formDataArray = _arrayList_Categories ;
    }
    [self.navigationController pushViewController:objFormShopListViewController animated:YES];
}

-(void)getFormShop_Bundles
{
    if (![[LTAPIClientManager sharedClient] connected])
    {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your Internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [error show];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [FormShopHelper get_FormShopBundles:nil andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (!error)
             {
                 NSString *strSuccess = [responseObject valueForKey:@"success"];
                 if (responseObject.count && strSuccess.integerValue)
                 {
                     NSArray *objFormData = [responseObject objectForKey:@"data"];
                     _array_List = [NSMutableArray new];
                     for (NSDictionary *dict in objFormData)
                     {
                         [_array_List addObject:[[FormShopObject alloc] initWithDictionary:dict]];
                         [_tableView_MainFormShop reloadData];
                         //API for formshop Categories
//                         [self getFormShop_Categories];
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
//                     [alert show];
                 }
             }
         }];
    }
}

-(void)getFormShop_Categories
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FormShopHelper get_FormShopCategories:nil andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 NSArray *objFormData = [responseObject objectForKey:@"data"];
                 _arrayList_Categories = [NSMutableArray new];
                 for (NSDictionary *dict in objFormData)
                 {
                     [_arrayList_Categories addObject:[[FormShopObject alloc] initWithDictionaryForFormTypeCategory:dict]];
                     [_tableView_MainFormShop reloadData];
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
     }];
}
- (void)getBundleCategory
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FormShopHelper get_BundleCategories:nil andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 NSArray *objFormData = [responseObject objectForKey:@"data"];
                 _arrayBundleList_Categories = [NSMutableArray new];
                 for (NSDictionary *dict in objFormData)
                 {
                     [_arrayBundleList_Categories addObject:[[FormShopObject alloc] initWithDictionaryForBundleTypeCategory:dict]];
                     [_tableView_MainFormShop reloadData];
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
     }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([[UIScreen mainScreen] bounds].size.width*110)/320;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    objView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    objView.center = CGPointMake(self.view.center.x, self.view.center.y);
    objView.backgroundColor = [UIColor whiteColor];

    UILabel *objLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, 200, 24)];
    objLbl.textColor=[UIColor colorWithRed:121/255.0f green:121/255.0f blue:121/255.0f alpha:1.0];
    [objLbl setFont:[UIFont fontWithName:@"OpenSans" size:17]];
    objplayButton = [[UIButton alloc]init];
    [objplayButton setFrame : CGRectMake(self.view.frame.size.width-60, 9, 50,20)];
    [objplayButton setTitle:@"See all >" forState:UIControlStateNormal];
    objplayButton.tag = section;
    objplayButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:12];
    //Attribute string
    UIFont *font = [UIFont fontWithName:@"OpenSans-Light" size:13];
    UIFont *font2 = [UIFont  fontWithName:@"OpenSans-Semibold" size:13.0];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"See all"attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSMutableAttributedString *stringArrow = [[NSMutableAttributedString alloc] initWithString:@" >"attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [string appendAttributedString:stringArrow];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(string.length - 1, 1)];
    //    objplayButton.titleLabel.attributedText = string;
    [objplayButton setAttributedTitle:string forState:UIControlStateNormal];
    [objView addSubview:objplayButton];
    [objplayButton addTarget:self
                      action:@selector(Btn_SeeAll:)
            forControlEvents:UIControlEventTouchUpInside];
    if (section == 0)
    {
        objLbl.text = @"Trending Bundles";
    }
    else
    {
        objLbl.text = @"Form Categories";
    }
    [objView addSubview:objLbl];
    
    return objView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell Identifier";
    FormShopTableViewCell *cell = (FormShopTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *arrayNibs = [[NSBundle mainBundle]loadNibNamed:@"FormShopTableViewCell" owner:self options:nil];
        cell = [arrayNibs firstObject];
    }
    cell.navigation = self.navigationController;
    if (indexPath.section == 0)
    {
        cell.bundle_arrayData = _array_List;
        cell.type = FormShopTableViewCellType1;
    }
    else
    {
        cell.bundle_arrayData = _arrayList_Categories;
        cell.type = FormShopTableViewCellType2;
    }
    return cell;
}
@end