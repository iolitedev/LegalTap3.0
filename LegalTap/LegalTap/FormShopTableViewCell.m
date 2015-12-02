//
//  FormShopTableViewCell.m
//  LegalTap
//
//  Created by Praveen on 9/21/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "FormShopTableViewCell.h"
#import "FormShopCollectionViewCell.h"
#import "FormDetailViewController.h"
#import "AppDelegate.h"
#import "FormShopObject.h"
#import "FormShopListViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation FormShopTableViewCell
{
    FormShopObject *objFormShopObject;
}

- (void)awakeFromNib {
    // Initialization code
    self.collectionView_Categories.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGSize size = CGSizeMake(([[UIScreen mainScreen] bounds].size.width - 16*5)/4, ([[UIScreen mainScreen] bounds].size.width*98)/320);
    if ([CommonHelper isiPhone6Plus])
    {
        flowLayout.minimumLineSpacing = 13.f;
    }
    else
    {
        flowLayout.minimumLineSpacing = 16.f;
    }
    flowLayout.minimumInteritemSpacing = 2.f;
    flowLayout.itemSize = size;
    [self.collectionView_Categories setCollectionViewLayout:flowLayout];
    // Register the collection cell
    [_collectionView_Categories registerNib:[UINib nibWithNibName:@"FormShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FormShopCollectionViewCell"];
    self.collectionView_Categories.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)GetFormsAccessToCase:(FormShopObject *)FormType
{
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
                     }
                     controller.formDataArray = _array_List;
                    controller.type = FormShopTableViewCellType2;
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

#pragma mark Collection View deligate and data sources

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bundle_arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FormShopCollectionViewCell *cell = (FormShopCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FormShopCollectionViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *arrayNibs = [[NSBundle mainBundle] loadNibNamed:@"FormShopCollectionViewCell" owner:self options:nil];
        cell = [arrayNibs firstObject];
        //  cell = [[FormShopCollectionViewCell alloc] init];
    }
    cell.imageView_Tranding.layer.cornerRadius = 5.0;
    cell.imageView_Tranding.image = [UIImage imageNamed:@"bundle_dark.png"];
    //Attribute string Font
    UIFont *font;
    UIFont *font2;
    if ([CommonHelper isiPhone5or5s])
    {
        font = [UIFont  fontWithName:@"OpenSans-Semibold" size: 8.35f];
        font2 = [UIFont fontWithName:@"OpenSans-Semibold" size: 8.0f];
    }
    else
    {
        font = [UIFont  fontWithName:@"OpenSans-Semibold" size: 10.0f];
        font2 = [UIFont fontWithName:@"OpenSans-Semibold" size:9.0f];
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //   [style setLineSpacing:-6];
    NSMutableAttributedString *mainString;
    FormShopObject *obj = [self.bundle_arrayData objectAtIndex:indexPath.row];
    if (_type == FormShopTableViewCellType1)
    {
        mainString = [[NSMutableAttributedString alloc] initWithString:obj.bundles_name attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        NSMutableAttributedString *objNewLine = [[NSMutableAttributedString alloc] initWithString:@"\n"];
        NSMutableAttributedString *appendString = [[NSMutableAttributedString alloc] initWithString:obj.bundle_Categorie attributes:@{NSFontAttributeName:font2,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [mainString appendAttributedString:objNewLine];
        [mainString appendAttributedString:appendString];
        {
            [style setLineSpacing:-3];
            [mainString addAttribute:NSParagraphStyleAttributeName
                               value:style
                               range:NSMakeRange(0, mainString.length)];
        }
    }
    else
    {
        //Categories
        mainString = [[NSMutableAttributedString alloc] initWithString:[[obj formTypeName] capitalizedString] attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        {
            [style setLineSpacing :-6];
            [mainString addAttribute:NSParagraphStyleAttributeName
                               value:style
                               range:NSMakeRange(0, mainString.length)];
        }
    }
    cell.lbl_FormName.attributedText = mainString;
    cell.lbl_FormName.textAlignment = NSTextAlignmentCenter;
    [cell.layer setBorderColor:[UIColor whiteColor].CGColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == FormShopTableViewCellType1)
    {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        FormDetailViewController *controller = (FormDetailViewController*)[mainStoryboard
                                                                           instantiateViewControllerWithIdentifier: @"FormDetailVC"];
        controller.type = FormShopTableViewCellType1;
        FormShopObject *objFormShop = [self.bundle_arrayData objectAtIndex:indexPath.row];
        controller.obj_FormShop = objFormShop;
        NSLog(@"%@",objFormShop.bundles_name);
        [self.navigation pushViewController:controller animated:YES];
    }
    else
    {
        FormShopObject *obj = [self.bundle_arrayData objectAtIndex:indexPath.row];
        [self GetFormsAccessToCase:obj];
        
    }
}
@end