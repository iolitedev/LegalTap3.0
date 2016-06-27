//
//  MeetUsViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/2/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "MeetUsViewController.h"

@interface MeetUsViewController ()
{
    BOOL isNavigationBarHidden;
}
@end

@implementation MeetUsViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    NSString *userType = [SharedSingleton sharedClient].user_Profile.userType;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"New_BackButton_blue"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [backButton setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:backButton];
    if ([userType isEqualToString:@"lawyer"])
    {
    }
    else
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:32/255.0 green:122/255.0 blue:192/255.0 alpha:1]];
        UIImage *navBarImg = [UIImage imageNamed:@""];
        [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
        UIView *statusBarView;
        if (IS_IPHONE_6)
        {
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 380, 22)];
        }
        else if (IS_IPHONE_6P)
        {
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 420, 22)];
        }
        else
        {
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 22)];
        }
        statusBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueImage2"]];
        [self.navigationController.navigationBar addSubview:statusBarView];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _array_List = @[@"MEET OUR PROVIDERS"
                    ,@"HOW IT WORKS?"
                    ,@"LEGAL TAP"
                    ,@"OUR BLOG"
                    ,@"FAQ"
                    ];
    [tableView_List reloadData];
    if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
    {
        
    }
    else if ([_identifierPreviousVC isEqualToString:@"HomeTab"])
    {
        
    }
    [self AddLinkToLabel];
}
- (void)backBarButton
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)AddLinkToLabel
{

   // Assign attributedText to UILabel
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"If you are having issues with the app please email info@legaltap.co with your question and we will promptly get in touch with you." attributes:nil];
    NSRange linkRange = NSMakeRange(51, 16); // for the word "link" in the string above
    
    NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    [attributedString setAttributes:linkAttributes range:linkRange];
    // Assign attributedText to UILabel
    helpTextLabel.attributedText = attributedString;
    helpTextLabel.userInteractionEnabled = YES;
    [helpTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LinkClicked:)]];
}

-(IBAction)LinkClicked:(id)sender
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://legaltap.co"]];
//
//}
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"LegalTap"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"info@legaltap.co",nil];
        [mailer setToRecipients:toRecipients];
         [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device doesn't support the Mail"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isNavigationBarHidden = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = isNavigationBarHidden;
}

#pragma mark Table View Data Source Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section)
    {
        case 0:
            number = _array_List.count;
            break;
            
        default:
            number = 0;
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat headerHeight = 0.0f;
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == _array_List.count)
            {
                headerHeight = 20.0;
            }
            else
            {
                headerHeight = 58.0;
            }
            break;
        }
        default:
            headerHeight = 0.0;
            break;
    }
    return headerHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0://List
        {
            NSString *identifier = @"LegalPracticeTableViewCell";
            LegalPracticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
                cell = [array firstObject];
            }
            cell.delegate = self;
            NSString *strTitle =  _array_List[indexPath.row];
            cell.textTitle = strTitle;
            cell.accessibilityIdentifier = strTitle;
            NSString *strImageName = [strTitle lowercaseString];
            {
                // strImageName = [strImageName stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
                strImageName = [strImageName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                strImageName = [NSString stringWithFormat:@"LP_%@",strImageName];
            }
            cell.imageView_Icon.image = [UIImage imageNamed:strImageName];
            cell.imgName = strImageName;
            
            cell.indexPath = indexPath;
            
            [cell layoutIfNeeded];
            return cell;
        }
        default:
        {
            return nil;
        }
    }
}

#pragma Table View Delegates
-(void)LegalPracticeTableViewCellDidSelect:(NSString *)LegalPractive withIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
        }
        default:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}
@end
