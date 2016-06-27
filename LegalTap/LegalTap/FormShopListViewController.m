//
//  FormShopListViewController.m
//  LegalTap
//
//  Created by Praveen on 9/22/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "FormShopListViewController.h"
#import "FormShopListTableViewCell.h"
#import "FormDetailViewController.h"
#import "FormShopObject.h"

@interface FormShopListViewController ()
{
    NSString *main_String;
}
@end

@implementation FormShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor colorWithRed:0/255.0f green:133/255.0f blue:198/255.0f alpha:1.0f]];
    [self.navigationItem setLeftBarButtonItem:backButton];

    
    if (_type == FormshopListView1)
    {
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@ Bundles",[_category capitalizedString]];//@"Bundles Categories";
    }
    else if (_type == FormshopListView4)
    {
        self.navigationItem.title = @"Bundle Categories";
    }
    else
    {
        NSString *str_Forms = @"Forms";
        NSString *main_String = [_category capitalizedString];
        NSString *shortString;
        if ([_category isEqualToString:@"TRADEMARKS AND COPYRIGHTS"]) {
            shortString = @"Trademarks";
            str_Forms = [[shortString stringByAppendingString:@" "] stringByAppendingString:str_Forms];
        }
        else
        {
            str_Forms = [[main_String stringByAppendingString:@" "] stringByAppendingString:str_Forms];
        }
        if (_category == nil)
        {
             self.navigationItem.title = @"Form Categories";
        }
        else
        {
        self.navigationItem.title = str_Forms;
        
        }
    }
    NSLog(@"%@",_formDataArray);
}
- (void)backBarButton
{
    //[CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
        [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender
{
    // [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _formDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell Identifier";
    FormShopListTableViewCell *cell = (FormShopListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *arrayNibs = [[NSBundle mainBundle]loadNibNamed:@"FormShopListTableViewCell" owner:self options:nil];
        cell = [arrayNibs firstObject];
    }
    UIFont *font;
    UIFont *font2;
    if (![[_formDataArray objectAtIndex:indexPath.row] isKindOfClass:[FormShopObject class]]) {
        cell.lbl_FormName.text = [[_formDataArray objectAtIndex:indexPath.row] capitalizedString];
        if (indexPath.row%2)
        {
            cell.imageView_Form.image = [UIImage imageNamed:@"white_bundle_Image.png"];
        }
        else
        {
            cell.imageView_Form.image = [UIImage imageNamed:@"bundle_dark.png"];
        }
    }
    else
    {
        FormShopObject *objFormShopObject = [_formDataArray objectAtIndex:indexPath.row];
        if (indexPath.row % 2)
        {
            cell.imageView_Form.image = [UIImage imageNamed:@"white_bundle_Image.png"];
        }
        else
        {
            cell.imageView_Form.image = [UIImage imageNamed:@"bundle_dark.png"];
        }
        font = [UIFont  fontWithName:@"OpenSans" size: 13.0f];
        font2 = [UIFont fontWithName:@"OpenSans" size:12.0f];
        NSMutableAttributedString *mainString;
        NSString *str_Doller = @"";
        if (_type == FormshopListView3)
        {
            mainString = [[NSMutableAttributedString alloc] initWithString:objFormShopObject.formTypeName attributes:@{NSFontAttributeName:font}];
//            NSMutableAttributedString *objNewLine = [[NSMutableAttributedString alloc] initWithString:@"\n"];
//            NSMutableAttributedString *appendString = [[NSMutableAttributedString alloc] initWithString:[objFormShopObject.formTypeName capitalizedString] attributes:@{NSFontAttributeName:font2,NSForegroundColorAttributeName:[UIColor grayColor]}];
//            [mainString appendAttributedString:objNewLine];
//            [mainString appendAttributedString:appendString];
        }
        else if (_type == FormshopListView4)
        {
            mainString = [[NSMutableAttributedString alloc] initWithString:objFormShopObject.bundleTypeName attributes:@{NSFontAttributeName:font}];

        }
        else
        {
            str_Doller = @"$";
            mainString = [[NSMutableAttributedString alloc] initWithString:objFormShopObject.bundles_name attributes:@{NSFontAttributeName:font}];
            NSMutableAttributedString *objNewLine = [[NSMutableAttributedString alloc] initWithString:@"\n"];
            NSMutableAttributedString *appendString = [[NSMutableAttributedString alloc] initWithString:[objFormShopObject.bundle_Categorie capitalizedString] attributes:@{NSFontAttributeName:font2,NSForegroundColorAttributeName:[UIColor grayColor]}];
            [mainString appendAttributedString:objNewLine];
            [mainString appendAttributedString:appendString];
            main_String = objFormShopObject.bundle_Amount;
            str_Doller = [str_Doller stringByAppendingString:main_String];
        }
        
        if ([main_String containsString:@"$"])
        {
            cell.lbl_FormPrice.text = main_String;
        }
        else
        {
            cell.lbl_FormPrice.text = str_Doller;
        }
        cell.lbl_FormName.attributedText = mainString;
        cell.lbl_FormName.adjustsFontSizeToFitWidth = YES;
        cell.lbl_FormName.numberOfLines = 3;
        cell.lbl_FormName.minimumScaleFactor = 0.5;
        cell.imageView_Form.layer.cornerRadius = 5.0;
       
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.layer setBorderColor:[UIColor clearColor].CGColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == FormshopListView1)
    {
        FormDetailViewController *objFormDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormDetailVC"];
        FormShopObject *objFormShop = [self.formDataArray objectAtIndex:indexPath.row];
        objFormDetailViewController.obj_FormShop = objFormShop;
        objFormDetailViewController.type = FormshopListView1;
        [self.navigationController pushViewController:objFormDetailViewController animated:YES];
    }
    else if (_type == FormshopListView4)
    {
        FormShopObject *FormType = [self.formDataArray objectAtIndex:indexPath.row];
        //            NSString *FormType= [[self.formDataArray objectAtIndex:indexPath.row] capitalizedString];
        [self GetBundleAccToCase:FormType];
    }
    else if (_type == FormshopListView3)
    {
//        if ([[_formDataArray objectAtIndex:indexPath.row] isKindOfClass:[FormShopObject class]]) {
//            
//            FormDetailViewController *objFormDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormDetailVC"];
//            
//            FormShopObject *objFormShop = [self.formDataArray objectAtIndex:indexPath.row];
//            
//            objFormDetailViewController.obj_FormShop = objFormShop;
//            
//            objFormDetailViewController.type = FormshopListView2;
//            
//            [self.navigationController pushViewController:objFormDetailViewController animated:YES];
//        }
//        else
        {
            FormShopObject *FormType = [self.formDataArray objectAtIndex:indexPath.row];
//            NSString *FormType= [[self.formDataArray objectAtIndex:indexPath.row] capitalizedString];
            [self GetFormsAccToCase:FormType];
        }
    }
    else
    {
        if ([[_formDataArray objectAtIndex:indexPath.row] isKindOfClass:[FormShopObject class]]) {
            FormDetailViewController *objFormDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormDetailVC"];
            FormShopObject *objFormShop = [self.formDataArray objectAtIndex:indexPath.row];
            objFormDetailViewController.obj_FormShop = objFormShop;
            objFormDetailViewController.type = FormshopListView2;
            [self.navigationController pushViewController:objFormDetailViewController animated:YES];
        }
        else
        {
            NSString *FormType= [[self.formDataArray objectAtIndex:indexPath.row] capitalizedString];
            [self GetFormsAccToCase:FormType];
        }
    }
}

-(void)GetFormsAccToCase:(FormShopObject *)FormType
{
    //    {
    //        FormType=@"15";
    //    }
    //    else if ([FormType isEqualToString:@"TRADEMARKS & COPYRIGHTS"])
    //    {
    //        FormType=@"TRADEMARKS AND COPYRIGHTS";
    //    }
    
    [MBProgressHUD showHUDAddedTo:((UIViewController *)[self.navigation.viewControllers lastObject]).view animated:YES];
    [SignInAndSignUpHelper FormTypeWithName:FormType.formTypeId
                     andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:((UIViewController *)[self.navigation.viewControllers lastObject]).view animated:YES];
         //   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 NSArray *detailUser = [responseObject objectForKey:@"data"];
                 if (detailUser && detailUser.count)
                 {
                     _array_List = [[NSMutableArray alloc]init];
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     FormShopListViewController *controller = (FormShopListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"FormShopListVC"];
                     controller.navigation = self.navigation;
                     NSArray *objFormData = detailUser;
                     controller.category = FormType.formTypeName;
                     
                     NSMutableArray *finalArray = [[NSMutableArray alloc]init];
                     for (NSDictionary *dict in objFormData)
                     {
                         /*
                          {
                          FormName = "Employment Contract";
                          description = "Contract between an employer and an employee.";
                          id = 58;
                          price = 25;
                          }
                          */
                         NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
                         NSString *formname = [dict valueForKey:@"FormName"];
                         NSString *description = [dict valueForKey:@"description"];
                         NSString *strid = [dict valueForKey:@"id"];
                         NSString *price = [dict valueForKey:@"price"];
                         [dictData setValue:formname forKey:@"FormName"];
                         [dictData setValue:description forKey:@"description"];
                         [dictData setValue:strid forKey:@"id"];
                         [dictData setValue:price forKey:@"price"];
                         [dictData setValue:FormType.formTypeName forKey:@"Category"];
                         [finalArray addObject:dictData];
                     }
                     for (NSDictionary *dict in finalArray)
                     {
                         [_array_List addObject:[[FormShopObject alloc] initWithDictionaryForFormTypeCat:dict]];
                         // PickerBgView.hidden=NO;
                         //  self.tabBarController.tabBar.hidden = YES;
                         //  [PickerView reloadAllComponents];
                     }
                     controller.formDataArray = _array_List;
                     controller.type = 1;
                     [self.navigation pushViewController:controller animated:YES];
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
                 _array_List=nil;
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

-(void)GetBundleAccToCase:(FormShopObject *)FormType
{
    [MBProgressHUD showHUDAddedTo:((UIViewController *)[self.navigation.viewControllers lastObject]).view animated:YES];
    [SignInAndSignUpHelper BundleTypeWithName:FormType.bundleTypeId
                     andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         [MBProgressHUD hideAllHUDsForView:((UIViewController *)[self.navigation.viewControllers lastObject]).view animated:YES];
         //   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {
                 NSArray *detailUser = [responseObject objectForKey:@"data"];
                 if (detailUser && detailUser.count)
                 {
                     _array_List = [[NSMutableArray alloc]init];
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                     FormShopListViewController *controller = (FormShopListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"FormShopListVC"];
                     controller.navigation = self.navigation;
                     
                     
                     
                     NSArray *objFormData = detailUser;
                     controller.category = FormType.bundleTypeName;
                     
                     NSMutableArray *finalArray = [[NSMutableArray alloc]init];
                     for (NSDictionary *dict in objFormData)
                     {
                         /*
                          {
                          FormName = "Employment Contract";
                          description = "Contract between an employer and an employee.";
                          id = 58;
                          price = 25;
                          }
                          */
                         NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
                         NSString *formname = [dict valueForKey:@"bundles_name"];
                         NSString *description = [dict valueForKey:@"bundles_description"];
                         NSString *strid = [dict valueForKey:@"bundles_id"];
                         NSString *price = [dict valueForKey:@"bundles_amt"];
                         NSString *created_date = [dict valueForKey:@"created_date"];

                         
                         [dictData setValue:formname forKey:@"bundles_name"];
                         [dictData setValue:description forKey:@"bundles_description"];
                         [dictData setValue:strid forKey:@"bundles_id"];
                         [dictData setValue:price forKey:@"bundles_amt"];
                         [dictData setValue:FormType.bundleTypeName forKey:@"bundles_cat"];
                         [dictData setValue:created_date forKey:@"dateTime"];

                         
                         [finalArray addObject:dictData];
                     }
                     for (NSDictionary *dict in finalArray)
                     {
                         [_array_List addObject:[[FormShopObject alloc] initWithDictionary:dict]];
                         // PickerBgView.hidden=NO;
                         //  self.tabBarController.tabBar.hidden = YES;
                         //  [PickerView reloadAllComponents];
                     }
                     controller.formDataArray = _array_List;
                     controller.type = FormshopListView1;
                     [self.navigation pushViewController:controller animated:YES];
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
                 _array_List=nil;
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


//-(void)GetFormsAccToCase:(FormShopObject *)FormType
//{
////    if ([FormType isEqualToString:@"Will And Trusts"])
////    {
////        FormType=@"WILL";
////    }
////    else if ([FormType isEqualToString:@"Trademarks & Copyrights"])
////    {
////        FormType=@"TRADEMARKS AND COPYRIGHTS";
////    }
//
//    //    [MBProgressHUD showHUDAddedTo:((UIViewController *)[self.navigation.viewControllers lastObject]).view animated:YES];
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [SignInAndSignUpHelper FormTypeWithName:FormType.formTypeId
//                     andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
//     {
//         //         [MBProgressHUD hideAllHUDsForView:((UIViewController *)[self.navigation.viewControllers lastObject]).view animated:YES];
//         
//         
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//         if (!error)
//         {
//             NSString *strSuccess = [responseObject valueForKey:@"success"];
//             if (responseObject.count && strSuccess.integerValue)
//             {
//                 NSArray *detailUser = [responseObject objectForKey:@"data"];
//                 if (detailUser && detailUser.count)
//                 {
//                     _array_List = [[NSMutableArray alloc]init];
//                     
//                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//                     
//                     Formshop_DetailListViewController *controller = (Formshop_DetailListViewController*)[mainStoryboard
//                                                                                                          instantiateViewControllerWithIdentifier: @"FormShopDetailListVC"];
//                     NSArray *objFormData = detailUser;
//                     
//                     NSMutableDictionary *dictData = [[NSMutableDictionary alloc]init];
//                     NSMutableArray *finalArray = [[NSMutableArray alloc]init];
//                     
//                     for (NSDictionary *dict in objFormData)
//                     {
//                         
//                         /*
//                          {
//                          FormName = "Employment Contract";
//                          description = "Contract between an employer and an employee.";
//                          id = 58;
//                          price = 25;
//                          }
//                          
//                          */
//                         
//                         NSString *formname = [dict valueForKey:@"FormName"];
//                         NSString *description = [dict valueForKey:@"description"];
//                         NSString *strid = [dict valueForKey:@"id"];
//                         NSString *price = [dict valueForKey:@"price"];
//                         
//                         [dictData setValue:formname forKey:@"FormName"];
//                         [dictData setValue:description forKey:@"description"];
//                         [dictData setValue:strid forKey:@"id"];
//                         [dictData setValue:price forKey:@"price"];
//                         
//                         [dictData setValue:FormType.formTypeName forKey:@"Category"];
//                         
//                         [finalArray addObject:dictData];
//                         
//                     }
//                     
//                     for (NSDictionary *dict in finalArray)
//                     {
//                         [_array_List addObject:[[FormShopObject alloc] initWithDictionaryForFormTypeCat:dict]];
//                         
//                         controller.formDataArray = _array_List;
//                         
//                         // PickerBgView.hidden=NO;
//                         //  self.tabBarController.tabBar.hidden = YES;
//                         //  [PickerView reloadAllComponents];
//                     }
//                     controller.category = FormType.formTypeName;
//                     [self.navigationController pushViewController:controller animated:YES];
//                     
//                 }
//                 else
//                 {
//                     //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                     //  message:@"Try Again."
//                     //  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                     // [alert show];
//                 }
//             }
//             else
//             {
//                 //Empty Response
//                 NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,@"Empty Response");
//                 _array_List=nil;
//                 NSString *errorMsg = [responseObject valueForKey:@"message"];
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                 message:errorMsg
//                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                 [alert show];
//             }
//         }
//         else
//         {
//             //Error
//             NSLog(@"%s - Error - %@",__PRETTY_FUNCTION__,error.description);
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                             message:@"Try Again.."
//                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//             [alert show];
//         }
//     }];
//}
@end