//
//  VideoCallingViewController.h
//  LegalTap
//
//  Created by Vikram on 23/03/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCallingViewController : UIViewController<QBActionStatusDelegate, QBChatDelegate>
{
    IBOutlet UIButton *loginAsUser1Button;
    IBOutlet UIButton *loginAsUser2Button;
}


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loginAsUser1:(id)sender;
- (IBAction)loginAsUser2:(id)sender;


@end
