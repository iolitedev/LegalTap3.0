//
//  LetsStartedViewController.h
//  LegalTap
//
//  Created by Apptunix on 2/27/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegalPracticeTableViewCell.h"

@interface LetsStartedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tableViewList;
    
}
@property (strong, nonatomic) NSArray *array_LegalPracticeList;

@end
