//
//  FormShopTableViewCell.h
//  LegalTap
//
//  Created by Praveen on 9/21/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FormShopTableViewCellType1,
    FormShopTableViewCellType2,
} FormShopTableViewCellType;


@protocol FormShopTableViewCellDelegate <NSObject>
@optional

-(void)FormShopTableViewCell_DidSelectCell:(NSString*)state withIndexPath:(NSIndexPath*)indexPath;

@end

@interface FormShopTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) NSString *strState;

@property (strong, nonatomic) IBOutlet UIImageView *imageView_FormShop;

@property (strong, nonatomic) IBOutlet UILabel *lbl_FormName;

@property (assign, nonatomic) FormShopTableViewCellType type;
@property (strong, nonatomic) NSMutableArray *array_List;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView_Categories;
@property (strong, nonatomic) NSMutableArray *bundle_arrayData;
@property (strong, nonatomic) NSMutableArray *categories_arrayData;

@property (strong, nonatomic) UINavigationController *navigation;

@property (strong, nonatomic) id<FormShopTableViewCellDelegate>delegate;

@end
