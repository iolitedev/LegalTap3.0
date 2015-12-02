//
//  LegalPracticeTableViewCell.h
//  LegalTap
//
//  Created by Apptunix on 2/27/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LegalPracticeTableViewCellDelegate <NSObject>
@optional
-(void)LegalPracticeTableViewCellDidSelect:(NSString*)LegalPractive withIndexPath:(NSIndexPath*)indexPath;

@end
#define defColor_CellBackground [UIColor colorWithRed:244.0/255.0 green:245.0/255.0 blue:249.0/255.0 alpha:1]
#define defColor_CellHighLighted defColor(0.0, 133.0, 198.0, 1.0)


#define defColor_DropDownListHeader defColor(15.0,112.0,187.0,1.0)
#define defColor_DropDownListHeaderSeleted defColor(15.0,112.0,187.0,0.6)

//[UIColor colorWithWhite:0.5 alpha:0.2]

@interface LegalPracticeTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *imageView_BackGround;
    
    IBOutlet UIImageView *imageView_ViewSadhow;
    IBOutlet UIView *view_ContentView;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imageView_Arrow;
}
@property (strong, nonatomic) NSString *accessibilityString;

@property (strong, nonatomic) NSString *textTitle;
@property (strong, nonatomic) NSString *imgName;
@property (strong, nonatomic) NSIndexPath *indexPath;


@property (strong, nonatomic) id<LegalPracticeTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *imageView_Icon;

- (IBAction)longPressGesture_CellSelection:(UILongPressGestureRecognizer *)sender;



@end
