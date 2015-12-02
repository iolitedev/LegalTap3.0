//
//  MyAccountViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/17/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegalPracticeTableViewCell.h"

@interface MyAccountViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,LegalPracticeTableViewCellDelegate>
{
    __weak IBOutlet UIImageView *imageView_bgProfilePic;
    __weak IBOutlet UIImageView *imageView_ProfilePic;
    
    __weak IBOutlet UITableView *tableView_MyAccount;
    NSArray *array_MyAccountList;
    
    
}
@end
