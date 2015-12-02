//
//  FavoriteLawyerViewController.h
//  LegalTap
//
//  Created by Vikram on 07/04/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInAndSignUpHelper.h"
#import "MyAppointmentViewController.h"


@interface FavoriteLawyerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *tableViewFav;
    
}
@property (strong, nonatomic) NSMutableArray *array_List;


@end
