//
//  FormShopListTableViewCell.h
//  LegalTap
//
//  Created by Praveen on 9/22/15.
//  Copyright (c) 2015 Brighthaus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormShopListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Form;
@property (strong, nonatomic) IBOutlet UILabel *lbl_FormName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_FormType;
@property (strong, nonatomic) IBOutlet UILabel *lbl_FormPrice;


@end
