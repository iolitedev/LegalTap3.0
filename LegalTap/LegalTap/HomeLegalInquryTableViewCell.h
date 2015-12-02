//
//  HomeLegalInquryTableViewCell.h
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeLegalInquryTableViewCellDelegate <NSObject>
@optional
-(void)HomeLegalInquryTableViewCellDidSelect:(NSString*)LegalPractive;
@end

@interface HomeLegalInquryTableViewCell : UITableViewCell
{
    IBOutlet UIView *view_Content;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView_PersonalInquiry;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Tax;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Small_Business;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_DUI;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Divorce;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Employment;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Immigration;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Family;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Wills;

@property (strong, nonatomic) id<HomeLegalInquryTableViewCellDelegate> delegate;

- (IBAction)press_PersonalInquiry:(id)sender;
- (IBAction)press_Tax:(id)sender;
- (IBAction)press_Small_Business:(id)sender;
- (IBAction)press_DUI:(id)sender;
- (IBAction)press_Divorce:(id)sender;
- (IBAction)press_Emploment:(id)sender;
- (IBAction)press_Immigration:(id)sender;
- (IBAction)press_Family:(id)sender;
- (IBAction)press_Wills:(id)sender;


@end
