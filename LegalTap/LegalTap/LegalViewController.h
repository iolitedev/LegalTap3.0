//
//  LegalViewController.h
//  LegalTap
//
//  Created by Vikram on 08/04/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegalViewController : UIViewController

{
    
    IBOutlet UILabel *label1;
    IBOutlet UIScrollView *ScrollView;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;
    
    
    
}
- (IBAction)PrivacyPolicy:(id)sender;
- (IBAction)UserTermsOfUse:(id)sender;
- (IBAction)LawyerTermsOfUse:(id)sender;

@end
