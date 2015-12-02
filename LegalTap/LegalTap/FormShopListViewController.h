//
//  FormShopListViewController.h
//  LegalTap
//
//  Created by Praveen on 9/22/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Formshop_DetailListViewController.h"

typedef enum : NSUInteger {
    FormshopListView1,
    FormshopListView2,
    FormshopListView3,
    FormshopListView4
} Formshop_ListViewType;


@interface FormShopListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView_FormShopList;
@property (assign, nonatomic) BOOL chkView;
@property (strong, nonatomic) FormShopObject *obj_FormShop;

@property (assign, nonatomic) FormshopListViewType type;

@property (strong, nonatomic) NSArray *formDataArray;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSMutableArray *array_List;
@property (strong, nonatomic) UINavigationController *navigation;

@end
