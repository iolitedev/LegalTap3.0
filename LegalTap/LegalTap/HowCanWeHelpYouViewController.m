//
//  HowCanWeHelpYouViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/11/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "HowCanWeHelpYouViewController.h"

@interface HowCanWeHelpYouViewController ()
{
    NSArray *array_QuestionsData;
}
@end

@implementation HowCanWeHelpYouViewController

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
    
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

    statusBarView.backgroundColor = [UIColor colorWithRed:70/255.0f green:130/255.0f blue:180/255.0f alpha:1.0f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    UIImage *navBarImg = [UIImage imageNamed:@"Navigation_bg_white"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];

//    [self.navigationController.navigationBar addSubview:statusBarView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _strSelectedPractice;
    NSString *strKey = _strSelectedPractice;
    
    if ([strKey isEqualToString:@"All"])
    {
        self.title = @"";
        
        NSDictionary *dict = @{@"Number":@"1"
                               ,@"Question":[@"BRIEFLY DESCRIBE YOUR PROBLEM" capitalizedString]
                               ,@"Type":@"INFO"
                               ,@"List":@[]};
        array_QuestionsData = @[dict];
    }
    else
    {
        array_QuestionsData = [CommonHelper getQuestionsFromLegalPracticeDataWithKey:strKey];
    }
    
    if (array_QuestionsData.count)
    {
        _array_QuestionsList = [NSMutableArray array];
        
        for (NSDictionary *dict in array_QuestionsData)
        {
            [_array_QuestionsList addObject:dict[@"Question"]];
        }
        _array_AnswersList = [[NSMutableArray alloc] init];
        [self loadQuestionsFirst];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    UIImage *navBarImg = [UIImage imageNamed:@"Navigation_bg"];
    [self.navigationController.navigationBar setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault];
    
    

    self.navigationController.navigationBarHidden = NO;

    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
   // self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
   // self.navigationController.navigationBar.alpha = 1;


}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"HCHelpToLetPay"])
    {
        AlmostAtEndViewController *viewController = [segue destinationViewController];
        viewController.identifierPreviousVC = _identifierPreviousVC;
        viewController.array_QuestionsList = _array_QuestionsList;
        viewController.array_AnswersList = _array_AnswersList;
        viewController.strSelectedPractice = _strSelectedPractice;

        
        if ([_identifierPreviousVC isEqualToString:@"MyAppointmentToHome"])
        {
            viewController.appointmentDate = _appointmentDate;

        }
        else
        {
//            viewController.appointmentDate = [NSDate date];

        }
    }
}

-(void)loadQuestionsFirst
{
    [self removeQuestions2];
    array_ViewQuestions = [[NSMutableArray alloc] init];
    NSDictionary *dict_Question = [array_QuestionsData objectAtIndex:0];
    NSString *strType = dict_Question[@"Type"];
    NSString *strQuestion = dict_Question[@"Question"];
    if ([strType isEqualToString:@"INFO"])
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCWHYQuestion2 class]) owner:self options:nil];
        HCWHYQuestion2 *view_TypeQuestion2 = [array firstObject];
        {
            
            if ([strQuestion isEqualToString:[@"BRIEFLY DESCRIBE YOUR PROBLEM" capitalizedString]])
            {
                view_TypeQuestion2.textQuestion = @"";

            }
            else
            {
                view_TypeQuestion2.textQuestion = strQuestion;
            }
            view_TypeQuestion2.frame = view_QuestionArea.bounds;
            
            [view_TypeQuestion2 layoutIfNeeded];
        }
        [view_QuestionArea addSubview:view_TypeQuestion2];
        
        view_TypeQuestion2.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            view_TypeQuestion2.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        [array_ViewQuestions addObject:view_TypeQuestion2];
        questionNumber = 1;
    }
    else
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCWHYQuestion1 class]) owner:self options:nil];
        HCWHYQuestion1 *view_TypeQuestion1 = [array firstObject];
        {
            view_TypeQuestion1.frame = view_QuestionArea.bounds;
            [view_TypeQuestion1 layoutIfNeeded];
            view_TypeQuestion1.textQuestion = strQuestion;
            view_TypeQuestion1.viewList.lbl_Text.textAlignment = NSTextAlignmentLeft;
            [view_TypeQuestion1.viewList setImageViewCornerRadiouswithRadious:4.0];

        }
        [view_QuestionArea addSubview:view_TypeQuestion1];
        
        view_TypeQuestion1.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            view_TypeQuestion1.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        [array_ViewQuestions addObject:view_TypeQuestion1];
        questionNumber = 1;
    }
}

-(void)loadQuestionsNext
{
    [self removeQuestions2];
    NSDictionary *dict_Question = [array_QuestionsData objectAtIndex:questionNumber-1];
    NSString *strType = dict_Question[@"Type"];
    NSString *strQuestion = dict_Question[@"Question"];

    if ([strType isEqualToString:@"INFO"])
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCWHYQuestion2 class]) owner:self options:nil];
        HCWHYQuestion2 *view_TypeQuestion2 = [array firstObject];
        {
            view_TypeQuestion2.frame = view_QuestionArea.bounds;
            [view_TypeQuestion2 layoutIfNeeded];
            view_TypeQuestion2.textQuestion = strQuestion;

        }
        [view_QuestionArea addSubview:view_TypeQuestion2];
        
        view_TypeQuestion2.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            view_TypeQuestion2.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        [array_ViewQuestions addObject:view_TypeQuestion2];
    }
    else
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HCWHYQuestion1 class]) owner:self options:nil];
        HCWHYQuestion1 *view_TypeQuestion1 = [array firstObject];
        {
            view_TypeQuestion1.frame = view_QuestionArea.bounds;
            [view_TypeQuestion1 layoutIfNeeded];
            view_TypeQuestion1.textQuestion = strQuestion;
            
            [view_TypeQuestion1.viewList setImageViewCornerRadiouswithRadious:4.0];
        }
        [view_QuestionArea addSubview:view_TypeQuestion1];
        view_TypeQuestion1.viewList.lbl_Text.textAlignment = NSTextAlignmentLeft;
        
        view_TypeQuestion1.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            view_TypeQuestion1.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        [array_ViewQuestions addObject:view_TypeQuestion1];
    }
    
    
}

-(void)removeQuestions2
{
    for (UIView *view in view_QuestionArea.subviews)
    {
        [view removeFromSuperview];
    }
}

- (IBAction)LinkButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CSBaseURLStringWithoutAPi]];
}

- (IBAction)btnClicked_NextQuestion:(id)sender
{
    if (array_QuestionsData.count == 0)
    {
        //No Questions
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSDictionary *dict_Question = [array_QuestionsData objectAtIndex:questionNumber-1];
        NSString *strType = dict_Question[@"Type"];
        NSString *strAnsaa;
        if ([strType isEqualToString:@"INFO"])
        {
            
            strAnsaa = ((HCWHYQuestion2*)[array_ViewQuestions objectAtIndex:questionNumber-1]).textView_Text.text;
        }
        else
        {//lbl_Text
            strAnsaa = ((HCWHYQuestion1*)[array_ViewQuestions objectAtIndex:questionNumber-1]).viewList.lbl_Text.text;
            //                strAnsaa = @"YES";
        }
        
        if (![strAnsaa isEqualToString:@""])
        {
            [_array_AnswersList addObject:strAnsaa];
            //                _array_AnswersList = [[NSMutableArray alloc] initWithArray:@[[view_Question2.textView_Text.text capitalizedString]]];
            if (array_QuestionsData.count == questionNumber)
            {
                [self performSegueWithIdentifier:@"HCHelpToLetPay" sender:self];
            }
            else
            {
                questionNumber++;
                [self loadQuestionsNext];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please answer the question to continue."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (IBAction)BackBarButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
