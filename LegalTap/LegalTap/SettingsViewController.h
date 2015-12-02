//
//  SettingsViewController.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/18/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegalPracticeTableViewCell.h"
#import "SignInAndSignUpHelper.h"
#import "FormListViewController.h"
#import "FavoriteLawyerViewController.h"


@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LegalPracticeTableViewCellDelegate,FormListViewControllerDelegate>
{
    NSArray *array_MyAccountList;
    __weak IBOutlet UITableView *tableView_Settings;
    __weak IBOutlet UIBarButtonItem *barButton_Home;
    NSString *type;
    
}
- (IBAction)btnClicked_Logout:(UIButton *)sender;
- (IBAction)navigationBar_Clicked_Home:(UIBarButtonItem *)sender;
- (IBAction)LinkButtonClicked:(id)sender;



@end
