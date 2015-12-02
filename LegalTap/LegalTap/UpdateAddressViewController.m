//
//  UpdateAddressViewController.m
//  LegalTap
//
//  Created by Apptunix on 3/12/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//

#import "UpdateAddressViewController.h"

@interface UpdateAddressViewController ()

@end

@implementation UpdateAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
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
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
//    txt_Name.layer.borderWidth=1.0;
//    txt_Name.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;
//    LastNameTextField.layer.borderWidth=1.0;
//    LastNameTextField.layer.borderColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f].CGColor;



    // Do any additional setup after loading the view.
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownList class]) owner:self options:nil];
    dropDownState = [array firstObject];
    {

        dropDownState.frame = view_State.frame;
        [dropDownState layoutIfNeeded];
        [dropDownState loadList:[CommonHelper stateList]];
        dropDownState.layer.cornerRadius=0;
        [dropDownState hideBackGround];
    }
    [view_State.superview addSubview:dropDownState];
    
    
    blurView.blurRadius = 8.0;
    blurView.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    
    txt_Name.layer.borderColor = [UIColor lightGrayColor].CGColor;
    LastNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;

    txt_Street.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txt_MobileNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view_Address.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [FirstNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    [LastNameText setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    [AddressText setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    [CityText setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    [StateText setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    [PhoneText setFont:[UIFont fontWithName:@"OpenSans-Light" size:20]];
    view_Address.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"TextField_BackgroundNew"]];
    view_State.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"TextField_BackgroundNew"]];

    [self showUserDetail];
    [self setUserImage];
    
    scrollView_TextFields.contentSize = CGSizeMake(CGRectGetWidth(view_TextFields.frame), CGRectGetHeight(view_TextFields.frame));
    
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

-(void)updateUserImage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SignInAndSignUpHelper upLoadImageForRegisterOfUserWithImage:userImage andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
     {
         UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;

         NSString *imageURl = @"";
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         if (!error)
         {
             NSString *strSuccess = [responseObject valueForKey:@"success"];
             if (responseObject.count && strSuccess.integerValue)
             {

                 imageURl = [responseObject objectForKey:@"image"];
                 
                 user_Profile.image = nil;
                 user_Profile.imageURL = imageURl;
                 
                 [CommonHelper saveUserId:user_Profile withUserPassword:[CommonHelper getUserPassword] withremember:[CommonHelper isRemember]];
                 [self updateUserDetail];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Image Uploading Failed.\nTry Again."
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }
         else
         {
             imageURl = @"";
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Image Uploading Failed.\nTry Again."
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

-(void)updateUserDetail
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    
    NSString *strName = txt_Name.text;
    NSString *strUserId = user_Profile.userId;
    NSString *strAddress = txt_Address.text;
    NSString *strCity = txt_Street.text;
    NSString *strMobileNum = txt_MobileNumber.text;
    NSString *strImageUrl = user_Profile.imageURL;
    NSString *LastName=LastNameTextField.text;
    NSString *state = dropDownState.lbl_Text.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [SignInAndSignUpHelper updateUserDetailWithUserId:strUserId
                                             withName:strName
                                          withAddress:strAddress
                                             withCity:strCity
                                             withState:state
                                         withimageUrl:strImageUrl
                                    withContactNumber:strMobileNum
                                         withLastName:LastName
                               andWithCompletionBlock:^(NSError *error, NSDictionary *responseObject)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *strSuccess = [responseObject valueForKey:@"success"];
        if (responseObject.count && strSuccess.integerValue)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"User Detail is Updated."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            user_Profile.name = strName;
            user_Profile.lastname = LastName;
            user_Profile.address = strAddress;
            user_Profile.city = strCity;
            user_Profile.state = state;

            user_Profile.mobileNumber = strMobileNum;
            
            [CommonHelper saveUserId:user_Profile withUserPassword:[CommonHelper getUserPassword] withremember:[CommonHelper isRemember]];
            
        }
        else
        {
            NSString *strMsg = [responseObject valueForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:strMsg
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


//UserImage
-(void)setUserImage
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    if (user_Profile.image)
    {
        imageView_UserImage.image = user_Profile.image;
        imageView_UserBGImage.image = user_Profile.image;
    }
    else
    {
        NSString *strUrl = user_Profile.imageURL;
        
        if(![strUrl isEqualToString:@""])
        {
            NSString *imgStr = strUrl;
            NSURL *url = [NSURL URLWithString:imgStr];
            NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@"image_placeholder"];
            
            __weak UIImageView *weakCell = imageView_UserImage;
            
            
            [weakCell setImageWithURLRequest:request1
                            placeholderImage:placeholderImage
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
            {
                                         
                                         weakCell.image = image;
                                         imageView_UserImage.image = image;
                                         imageView_UserBGImage.image = image;
                                         user_Profile.image = image;
                
                                         [weakCell setNeedsLayout];
            } failure:nil];
        }
    }
}

-(void)showUserDetail
{
    UserProfile *user_Profile = [SharedSingleton sharedClient].user_Profile;
    
    txt_Name.text = user_Profile.name;
    txt_Address.text = user_Profile.address;
    txt_Street.text = user_Profile.city;
    
    NSString *phoneNumber=user_Profile.mobileNumber;
    if ([phoneNumber isEqualToString:@"0"])
    {
        txt_MobileNumber.text = @"";
    }
    else
    {
        txt_MobileNumber.text = user_Profile.mobileNumber;
    }
    
    LastNameTextField.text = user_Profile.lastname;
    
    if (user_Profile.state.length)
    {
        dropDownState.lbl_Text.text = user_Profile.state;
    }
    
    if (txt_Address.text.length)
    {
        lbl_AddressPlaceHolder.hidden = YES;
    }
}

#pragma mark - UIButton Actions
- (IBAction)btnClicked_SaveUpdate:(id)sender
{
    NSString *strName = txt_Name.text;
    NSString *strAddress = txt_Address.text;
    NSString *strCity = txt_Street.text;
    NSString *strMobileNum = txt_MobileNumber.text;
    NSString *LastName=LastNameTextField.text;
    
    if (!strName.length)
    {
        //Empty Email
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Name is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!strAddress.length)
    {
        //Empty password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Address is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!strCity.length)
    {
        //Empty Name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"City is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!strMobileNum.length)
    {
        //Empty Name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Mobile Number is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (!LastName.length)
    {
        //Empty Name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                        message:@"Last Name is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([dropDownState.lbl_Text.text isEqualToString:@"Select State"])
    {
        //Empty Name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"State Field"
                                                        message:@"State is Required"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!isUserImageUpdate)
    {
        [self updateUserDetail];
    }
    else
    {
        [self updateUserImage];
    }
}

- (IBAction)btnClicked_Cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)BackBarButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnClicked_AddProfilePic:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Media Type"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose Existing Photo",nil];
    
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

#pragma mark - UIImagePickerController delegate methods
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100)
    {
        switch (buttonIndex)
        {
            case 0:
                [self takePhotoVideo];
                break;
            case 1:
                [self choosePhotoFromGalery];
                break;
            default:
                break;
        }
    }
}

-(void)takePhotoVideo
{
    UIImagePickerController *imgPickerBackgroundImage = [[UIImagePickerController alloc] init];
    imgPickerBackgroundImage.delegate = self;
    imgPickerBackgroundImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPickerBackgroundImage animated:true completion:nil];
}

-(void)choosePhotoFromGalery
{
    UIImagePickerController *imgPickerBackgroundImage = [[UIImagePickerController alloc] init];
    imgPickerBackgroundImage.delegate = self;
    imgPickerBackgroundImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPickerBackgroundImage animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:true completion:nil];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType] ;
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        imageView_UserImage.image = [[info objectForKey:UIImagePickerControllerOriginalImage] copy];
//        imageView_AddProfilePic.layer.cornerRadius = CGRectGetHeight(imageView_AddProfilePic.frame)/2;
//        imageView_AddProfilePic.clipsToBounds = YES;
//        imageView_AddProfilePic.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView_UserBGImage.image = imageView_UserImage.image;
        userImage = imageView_UserImage.image;
        isUserImageUpdate = YES;
        //     NSData *imageData = UIImagePNGRepresentation(imageView_AddProfilePic.image);
        
        
        //     self settingUserImagewithUserId:str_UserId image:imageData];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITextView delegate methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self textViewChangeText:textView];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    [self textViewChangeText:textView];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self textViewChangeText:textView];
}


-(void)textViewChangeText:(UITextView*)textView
{
    if ([textView.text isEqualToString:@""])
    {
        lbl_AddressPlaceHolder.hidden = NO;
    }
    else
    {
        lbl_AddressPlaceHolder.hidden = YES;
    }
}

@end
