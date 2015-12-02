//
//  Formshop_DetailListViewController.h
//  LegalTap
//
//  Created by Praveen on 10/2/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDetailViewController.h"


typedef enum : NSUInteger {
    Formshop_ListView1,
    Formshop_ListView2,
} FormshopListViewType;

@interface Formshop_DetailListViewController : UIViewController
{
    
    IBOutlet UITableView *tbl_List;
}


@property (assign, nonatomic) BOOL chkView;
@property (assign, nonatomic) FormshopListViewType type;

@property (strong, nonatomic) NSArray *formDataArray;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSMutableArray *array_List;
@property (strong, nonatomic) UINavigationController *navigation;

@end
