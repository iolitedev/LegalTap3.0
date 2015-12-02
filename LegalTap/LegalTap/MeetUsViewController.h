//
//  MeetUsViewController.h
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegalPracticeTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface MeetUsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LegalPracticeTableViewCellDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tableView_List;
    IBOutlet UILabel *helpTextLabel;

    
}
@property (strong, nonatomic) NSString *identifierPreviousVC;
@property (strong, nonatomic) NSArray *array_List;


@end
