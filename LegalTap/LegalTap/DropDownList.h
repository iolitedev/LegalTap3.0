//
//  DropDownList.h
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownList : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIImageView *imageView_BackGround;
    IBOutlet UIImageView *imageView_DownArrow;
    IBOutlet UIButton *btn_OpenCloseList;
    UITableView *tableView_List;
    BOOL isOpen;
}
-(void)hideBackGround;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Text;
@property (strong, nonatomic) NSArray *list;

- (IBAction)btnClicked_OpenCloseList:(id)sender;

- (void)setImageViewCornerRadiouswithRadious:(CGFloat)radious;


- (void)loadList:(NSArray*)array;
@end
