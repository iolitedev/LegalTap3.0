//
//  FormListViewController.h
//  LegalTap
//
//  Created by Sandeep Kumar on 3/25/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegalPracticeTableViewCell.h"
#import "SignInAndSignUpHelper.h"


@protocol FormListViewControllerDelegate <NSObject>
@optional
-(void)FormListViewControllerDidSelect:(NSString *)LegalPractive withId:(NSString *)Id withDesc:(NSString *)Desc withPrice:(NSString *)Price withIndexPath:(NSIndexPath *)indexPath;

@end

@interface FormListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LegalPracticeTableViewCellDelegate>
{
    IBOutlet UITableView *tableView_List;
    
    NSString *Type;
    NSString *SelectedFormType;

    
}

@property(nonatomic,retain) NSString *Type;
@property(nonatomic,retain) NSString *SelectedFormType;

@property (strong, nonatomic) NSMutableArray *array_List;
@property (strong, nonatomic) id<FormListViewControllerDelegate>delegate;

@end
