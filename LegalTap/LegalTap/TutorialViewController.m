//
//  TutorialViewController.m
//  LegalTap
//
//  Created by Apptunix on 2/26/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "TutorialViewController.h"


@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationApplication_StateChange:) name:defApplicationWillTerminate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationApplication_StateChange:) name:defApplicationDidBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationApplication_StateChange:) name:defApplicationDidEnterBackground object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationApplication_StateChange:) name:defApplicationWillEnterForeground object:nil];

    
    [self formateViews];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if ([CommonHelper isRemember])
    {
        [SharedSingleton sharedClient].user_Profile = [CommonHelper getUserProfileFromUserDefault];
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        
        tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        if (user_Profile && [user_Profile.userType isEqualToString:@"user"])
        {
            NSArray *arraaa = tabBarController.viewControllers;

            NSArray *array = @[[arraaa objectAtIndex:0],[arraaa objectAtIndex:1],[arraaa objectAtIndex:2]];
            
            tabBarController.viewControllers = array;
            
            NSArray *arr = tabBarController.viewControllers;

            UINavigationController *myHomeNavigationController = [arr objectAtIndex:0];
            {
                UIImage *imageUnSell = [UIImage imageNamed:@"New_home_icon"];
                UIImage *imageSell = [UIImage imageNamed:@"New_home_icon"];
                
                imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                myHomeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"HOME" image:imageUnSell selectedImage:imageSell];
            }
            UINavigationController *myAppointmentNavigationController = [arr objectAtIndex:1];
            {
                UIImage *imageUnSell = [UIImage imageNamed:@"New_appointmant_icon"];
                UIImage *imageSell = [UIImage imageNamed:@"New_appointmant_icon"];
                
                imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                myAppointmentNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"APPOINTMENTS" image:imageUnSell selectedImage:imageSell];
            }
            UINavigationController *formPortalNavigationController = [arr objectAtIndex:2];
            {
                UIImage *imageUnSell = [UIImage imageNamed:@"New_formportal_icon"];
                UIImage *imageSell = [UIImage imageNamed:@"New_formportal_icon"];
                
                imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                formPortalNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"FORM SHOP" image:imageUnSell selectedImage:imageSell];
            }
//            UINavigationController *settingsNavigationController = [arr objectAtIndex:3];
//            {
//                UIImage *imageUnSell = [UIImage imageNamed:@"New_settings_icon"];
//                UIImage *imageSell = [UIImage imageNamed:@"New_settings_icon"];
//                
//                imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                
//                settingsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SETTINGS" image:imageUnSell selectedImage:imageSell];
//            }
            myHomeNavigationController.navigationBar.tintColor = defColor_TOPBAR;
            myAppointmentNavigationController.navigationBar.tintColor = defColor_TOPBAR;
            formPortalNavigationController.navigationBar.tintColor = defColor_TOPBAR;
//            settingsNavigationController.navigationBar.tintColor = defColor_TOPBAR;
            
            {
//                @"ritesharora", @"ritesharora", @2569186
//                NSString *qUserName = @"ritesharora";//user_Profile.quickBlox_UserName;
//                NSString *qPassword = @"ritesharora";//user_Profile.quickBlox_UserName;
//                if (qUserName.length && qPassword.length)
//                {
//                    [self createSeesionForClientwithUserName:qUserName withUserPassword:qPassword];
//
//                }
//                else
                {
                    [self.navigationController pushViewController:tabBarController animated:NO];
                }
            }
        }
        else
        {
            UINavigationController *myAppointmentNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAppointmentNavigationController"];
            
            
//            UINavigationController *formPortalNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"FormPortalNavigationController"];
//            
//            UIViewController *viewc = [self.storyboard instantiateViewControllerWithIdentifier:@"FormPortal"];//FormShopViewC
//            formPortalNavigationController = [[UINavigationController alloc]initWithRootViewController:viewc];
            
            UINavigationController *settingsNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigationController"];
            
            NSArray *array = @[myAppointmentNavigationController,settingsNavigationController];
            
            tabBarController.viewControllers = array;
            {

                {
                    UIImage *imageUnSell = [UIImage imageNamed:@"New_appointmant_icon"];
                    UIImage *imageSell = [UIImage imageNamed:@"New_appointmant_icon"];
                    
                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    myAppointmentNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"APPOINTMENTS" image:imageUnSell selectedImage:imageSell];
                }
//                {
//                    UIImage *imageUnSell = [UIImage imageNamed:@"New_formportal_icon"];
//                    UIImage *imageSell = [UIImage imageNamed:@"New_formportal_icon"];
//                    
//                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                    
//                    formPortalNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"FORM SHOP" image:imageUnSell selectedImage:imageSell];
//                }
//                UINavigationController *settingsNavigationController = [arr objectAtIndex:2];
                {
                    UIImage *imageUnSell = [UIImage imageNamed:@"New_settings_icon"];
                    UIImage *imageSell = [UIImage imageNamed:@"New_settings_icon"];
                    
                    imageUnSell = [imageUnSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    imageSell = [imageSell imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    
                    settingsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:imageUnSell selectedImage:imageSell];
                }
                
                myAppointmentNavigationController.navigationBar.tintColor = defColor_TOPBAR;
//                formPortalNavigationController.navigationBar.tintColor = defColor_TOPBAR;
                settingsNavigationController.navigationBar.tintColor = defColor_TOPBAR;
            }
//            UIImage *BlueBackground = [UIImage imageNamed:@"blueImage3"];
//            [[UITabBar appearance] setSelectionIndicatorImage:BlueBackground];
            NSLog(@"aar appearance] setSelectionIndicator");

            [self.navigationController pushViewController:tabBarController animated:NO];
        }

    }
    else
    {
        [SharedSingleton sharedClient].user_Profile = nil;
        [CommonHelper removeUserDetail];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - scrollView Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeBackgroundImageOriginWithContentOffset:scrollView.contentOffset];
    CGFloat drag = [scrollView.panGestureRecognizer translationInView:self.view].x;
    lbl_Title.alpha = (def_DeviceWidth - ABS(drag))/def_DeviceWidth;
    [self changeBottomButtonsFrameWithContentOffset:scrollView.contentOffset];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (NSInteger)(scrollView.contentOffset.x/def_DeviceWidth);
    [self setCurrentPageWithPageNumber:page];
    [self changeBackgroundImageOriginWithContentOffset:scrollView.contentOffset];
    [self changeBottomButtonsFrameWithContentOffset:scrollView.contentOffset];
}

#pragma mark - Methods
-(void)formateViews                     //Called in ViewDidController
{
    scrollView_Main.contentSize = CGSizeMake(def_DeviceWidth*3, CGRectGetHeight(scrollView_Main.frame)-20);
    NSInteger page = (NSInteger)(scrollView_Main.contentOffset.x/def_DeviceWidth);
    [self setCurrentPageWithPageNumber:page];
    [self changeBackgroundImageOriginWithContentOffset:scrollView_Main.contentOffset];
    
    view_FirstTut.frame = CGRectMake(0*CGRectGetWidth(scrollView_Main.frame),
                                     0,
                                     CGRectGetWidth(scrollView_Main.frame),
                                     CGRectGetHeight(scrollView_Main.frame));
    
    view_SecondTut.frame = CGRectMake(1*CGRectGetWidth(scrollView_Main.frame),
                                     0,
                                     CGRectGetWidth(scrollView_Main.frame),
                                     CGRectGetHeight(scrollView_Main.frame));
    
    view_ThirdTut.frame = CGRectMake(2*CGRectGetWidth(scrollView_Main.frame),
                                     0,
                                     CGRectGetWidth(scrollView_Main.frame),
                                     CGRectGetHeight(scrollView_Main.frame));
    
    view_FourthTut.frame = CGRectMake(3*CGRectGetWidth(scrollView_Main.frame),
                                     0,
                                     CGRectGetWidth(scrollView_Main.frame),
                                      CGRectGetHeight(scrollView_Main.frame));
    
    view_LoginSIgnUpButtons.frame = CGRectMake(CGRectGetMinX(view_LoginSIgnUpButtons.frame),
                                               def_DeviceHeight,
                                               CGRectGetWidth(view_LoginSIgnUpButtons.frame),
                                               CGRectGetHeight(view_LoginSIgnUpButtons.frame));
    
    btn_GetStarted.frame = CGRectMake(CGRectGetMinX(btn_GetStarted.frame),
                                      def_DeviceHeight - 30 - CGRectGetHeight(btn_GetStarted.frame),
                                      CGRectGetWidth(btn_GetStarted.frame),
                                      CGRectGetHeight(btn_GetStarted.frame));
    
    
    btn_GetStarted.layer.cornerRadius = 4;
    btn_GetStarted.clipsToBounds = YES;

    btn_Login.layer.borderWidth = 1.0;
    btn_Login.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    
    btn_Signup.layer.borderWidth = 1.0;
    btn_Signup.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    
    imageView_Logo.alpha = 0.0;
    [UIView animateWithDuration:1 animations:^{
        imageView_Logo.alpha = 1.0;
    }];
}

//Change Frames of GetStarted button And Bottom Button
-(void)changeBottomButtonsFrameWithContentOffset:(CGPoint)point
{
    CGFloat X = point.x;
    if (X <= CGRectGetWidth(scrollView_Main.frame))
    {
        CGFloat Y = (CGRectGetHeight(view_LoginSIgnUpButtons.frame)/CGRectGetWidth(scrollView_Main.frame))*X;
        view_LoginSIgnUpButtons.frame = CGRectMake(CGRectGetMinX(view_LoginSIgnUpButtons.frame),
                                                   def_DeviceHeight - Y,
                                                   CGRectGetWidth(view_LoginSIgnUpButtons.frame),
                                                   CGRectGetHeight(view_LoginSIgnUpButtons.frame));
        
        btn_GetStarted.frame = CGRectMake(CGRectGetMinX(btn_GetStarted.frame),
                                          def_DeviceHeight - 30 - CGRectGetHeight(btn_GetStarted.frame) - Y,
                                          CGRectGetWidth(btn_GetStarted.frame),
                                          CGRectGetHeight(btn_GetStarted.frame));

    }
}

//Change BackGround Image frame
-(void)changeBackgroundImageOriginWithContentOffset:(CGPoint)point
{
    CGFloat X = ((CGRectGetWidth(imageView_BackGround.frame)-def_DeviceWidth)/(scrollView_Main.contentSize.width))*point.x;
    if (point.x < 0
        || ((scrollView_Main.contentSize.width - def_DeviceWidth) < point.x))
    {
        X = CGRectGetMinX(imageView_BackGround.frame);
    }
    else
    {
        X = -(X);
    }
    
    
    imageView_BackGround.frame = CGRectMake(X,
                                            CGRectGetMinY(imageView_BackGround.frame),
                                            CGRectGetWidth(imageView_BackGround.frame),
                                            CGRectGetHeight(imageView_BackGround.frame));
}

//Change Current Page Number
-(void)setCurrentPageWithPageNumber:(NSInteger)page
{
    
    NSArray *array = @[@"Video Chat with a local licensed attorney now about your legal matter or schedule an appointment for the future",
                       @"Request a form from the form shop!",
                       @"Connect with a local licensed attorney if you need further legal guidance using our lawyer connect service!",
                       @"Retain a Lawyer from our\nServices"];
    
    pageControl.currentPage = page;
    [UIView animateWithDuration:0.5 animations:^{
        lbl_Title.alpha = 1.0;
        lbl_Title.text = [array objectAtIndex:page];

    }completion:^(BOOL finished) {
    }];
    
    switch (page)
    {
        case 0:
        {
//            btn_GetStarted
            
            [UIView animateWithDuration:0.5 animations:^{
                btn_GetStarted.alpha = 1.0;
            }];
            break;
        }
        case 1:
        {
            
//            break;
        }
        case 2:
        {
//            break;
        }
        case 3:
        {
            [UIView animateWithDuration:0.5 animations:^{
                btn_GetStarted.alpha = 0.0;
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Application Change State
-(void)notificationApplication_StateChange:(NSNotification*)notification
{
    if ([notification.name isEqualToString:defApplicationDidBecomeActive])
    {
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        if (user_Profile && user_Profile.userId.length)
        {
            [SignInAndSignUpHelper changeStatusWithUserId:user_Profile.userId
                                               withStatus:YES andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
             {
                  NSLog(@"%@\nLogin Status",responseObject);
                 user_Profile.onlineStatus = YES;
             }];
        }
    }
    else if ([notification.name isEqualToString:defApplicationDidEnterBackground])
    {
        
    }
    else if ([notification.name isEqualToString:defApplicationWillEnterForeground])
    {
        
    }
    else if ([notification.name isEqualToString:defApplicationWillTerminate])
    {
        UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
        if (user_Profile && user_Profile.userId.length)
        {
            [SignInAndSignUpHelper changeStatusWithUserId:user_Profile.userId
                                               withStatus:NO andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
            {
                NSLog(@"%@\nLogout Status",responseObject);
                user_Profile.onlineStatus = NO;
            }];
        }
    }
}

-(void)dealloc
{
    
}

@end
