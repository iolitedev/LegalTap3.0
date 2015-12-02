//
//  Formshop_DetailListViewController.m
//  LegalTap
//
//  Created by Praveen on 10/2/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import "Formshop_DetailListViewController.h"
#import "FormShopListTableViewCell.h"
#import "FormShopObject.h"


@interface Formshop_DetailListViewController ()
{
    FormShopObject *objFormShopObject;
}

@end

@implementation Formshop_DetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     else if (_type == FormShopsDetailView3)
     {
     form_Type = @"bundle";
     NSString *str_Forms = @"Bundles";
     NSString *main_String = [_obj_FormShop.bundle_Categorie capitalizedString];
     
     str_Forms = [[main_String stringByAppendingString:@" "] stringByAppendingString:str_Forms];
     
     self.navigationItem.title = str_Forms;
     }

     */
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor colorWithRed:0/255.0f green:133/255.0f blue:198/255.0f alpha:1.0f]];
    [self.navigationItem setLeftBarButtonItem:backButton];

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
    self.navigationItem.title = str_Forms;
    NSLog(@"%@,",[_formDataArray valueForKey:@"bundle_Categorie"]);
    //self.navigationItem.title = @"Form Categories";
    
}
- (void)backBarButton
{
   // [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
     [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender
{
    // [CommonHelper animateToHomeTabWithTabBarController:self.navigationController.tabBarController];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
   objFormShopObject = [_formDataArray objectAtIndex:indexPath.row];
    UIFont *font;
    UIFont *font2;
    if (indexPath.row%2)
    {
        cell.imageView_Form.image = [UIImage imageNamed:@"white_bundle_Image.png"];
    }
    else
    {
        cell.imageView_Form.image = [UIImage imageNamed:@"bundle_dark.png"];
    }
    font = [UIFont  fontWithName:@"OpenSans" size: 13.0f];
    font2 = [UIFont fontWithName:@"OpenSans" size:12.0f];
    NSMutableAttributedString *mainString = [[NSMutableAttributedString alloc] initWithString:objFormShopObject.formTypeName attributes:@{NSFontAttributeName:font}];
    NSMutableAttributedString *objNewLine = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *appendString = [[NSMutableAttributedString alloc] initWithString:[objFormShopObject.bundle_Categorie capitalizedString] attributes:@{NSFontAttributeName:font2,NSForegroundColorAttributeName:[UIColor grayColor]}];
    [mainString appendAttributedString:objNewLine];
    [mainString appendAttributedString:appendString];
    cell.lbl_FormName.attributedText = mainString;
    cell.lbl_FormName.adjustsFontSizeToFitWidth = YES;
    cell.lbl_FormName.numberOfLines = 3;
    cell.lbl_FormName.minimumScaleFactor = 0.5;
    cell.imageView_Form.layer.cornerRadius = 5.0;
    NSString *str_Doller = @"$";
    NSString *main_String = objFormShopObject.bundle_Amount;
    if ([main_String containsString:@"$"])
    {
        cell.lbl_FormPrice.text = main_String;
    }
    else
    {
        str_Doller = [str_Doller stringByAppendingString:main_String];
        cell.lbl_FormPrice.text = str_Doller;

    }
        cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.layer setBorderColor:[UIColor clearColor].CGColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        FormDetailViewController *objFormDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormDetailVC"];
        FormShopObject *objFormShop = [self.formDataArray objectAtIndex:indexPath.row];
        objFormDetailViewController.obj_FormShop = objFormShop;
        objFormDetailViewController.type = Formshop_ListView2;
        [self.navigationController pushViewController:objFormDetailViewController animated:YES];
}
@end