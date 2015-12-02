//
//  FormShopViewController.h
//  LegalTap
//
//  Created by Praveen on 9/21/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormShopHelper.h"

@interface FormShopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView_MainFormShop;

@property (strong, nonatomic) IBOutlet UIView *view_TableHeader;
@property (strong, nonatomic) IBOutlet UILabel *lbl_CategoriesName;
@property (strong, nonatomic) IBOutlet UIButton *btn_SeeAll;
@property (strong, nonatomic) NSMutableArray *array_List;
@property (strong, nonatomic) NSMutableArray *arrayList_Categories;
@property (strong, nonatomic) NSMutableArray *arrayBundleList_Categories;



@end
