//
//  Pamba.m
//  PambaU
//
//  Created by Firststep Consulting on 9/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Pamba.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface Pamba ()

@end

@implementation Pamba

@synthesize userID,rqDTTM,deviceID,appID,funcCode,userToken,xAuthorization,firstNameTh,firstNameEn,lastNameTh,lastNameEn,facultyNameTh,facultyNameEn,profileImageUrl,gender,studentCode,isSharewayAccepted,language,push_ios;

@synthesize headerView,headerTitle,headerLBtn,termLabel,checkBtn,checkLabel,acceptBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    termLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:15];
    //termLabel.text = @"ข้อกำหนด\n\nข้อกำหนดและเงื่อนไขข้อกำหนด";
    //termLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Yesterday you sold %@ apps", nil), @(1000000)];
    
    [checkBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //checkBtn.imageView.image = [checkBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[checkBtn.imageView setTintColor:sharedManager.mainThemeColor];
    
    checkLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:15];
    //checkLabel.text = @"ฉันยอมรับข้อกำหนดและเงื่อนไข";
    
    acceptBtn.backgroundColor = sharedManager.btnThemeColor;
    acceptBtn.titleLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    
    //[self loadDemo];//อย่าลืมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมม
    
    [self loadLogin];
    [self loadHome];
    /*
    ISMessages* alert = [ISMessages cardAlertWithTitle:@"This is custom alert with callback"
                                               message:@"This is your message!!"
                                             iconImage:[UIImage imageNamed:@"Icon-40"]
                                              duration:3.f
                                           hideOnSwipe:YES
                                             hideOnTap:YES
                                             alertType:ISAlertTypeCustom
                                         alertPosition:ISAlertPositionTop];
    
    alert.titleLabelFont = [UIFont boldSystemFontOfSize:15.f];
    alert.titleLabelTextColor = [UIColor blackColor];
    
    alert.messageLabelFont = [UIFont italicSystemFontOfSize:13.f];
    alert.messageLabelTextColor = [UIColor whiteColor];
    
    alert.alertViewBackgroundColor = [UIColor colorWithRed:96.f/255.f
                                                     green:184.f/255.f
                                                      blue:237.f/255.f
                                                     alpha:1.f];
    
    [alert show:^{
        NSLog(@"Callback is working!");
    } didHide:^(BOOL finished) {
        NSLog(@"Custom alert without image did hide.");
    }];
     
     //[ISMessages hideAlertAnimated:YES];
     */
    
}

- (void)loadDemo
{
    studentCode = @"123456789";
    firstNameTh = @"นรุตม์ศรณ์";
    lastNameTh = @"พรหมศิริ";
    firstNameEn = @"Test";
    lastNameEn = @"Data";
    facultyNameTh = @"คอมพิวเตอร์ธุระกิจ";
    facultyNameEn = @"Bissness infomation Thecnology";
    profileImageUrl = @"https://pambashare.com/v2/images/userPic/female_logo.png?134916";
    gender = @"M";
    isSharewayAccepted = @"Y";
    rqDTTM = @"1";
    deviceID = @"1";
    appID = @"1";
    funcCode = @"1";
    userToken = @"1";
    xAuthorization = @"1";
    language = @"TH";
    push_ios = @"1a2b3c4d5e6f7g8h9i10j11k12l13m14n15o";
}

- (void)loadLogin
{
    if(!push_ios)
    {
        push_ios = @"";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@login_uApp",HOST_DOMAIN];
    NSDictionary *parameters = @{@"studentCode":studentCode,
                                 @"firstNameTh":firstNameTh,
                                 @"lastNameTh":lastNameTh,
                                 @"firstNameEn":firstNameEn,
                                 @"lastNameEn":lastNameEn,
                                 @"facultyNameTh":facultyNameTh,
                                 @"facultyNameEn":facultyNameEn,
                                 @"profileImageUrl":profileImageUrl,
                                 @"gender":gender,
                                 @"isSharewayAccepted":isSharewayAccepted,
                                 @"rqDTTM":rqDTTM,
                                 @"deviceID":deviceID,
                                 @"appID":appID,
                                 @"funcCode":funcCode,
                                 @"gender":gender,
                                 @"userToken":userToken,
                                 @"xAuthorization":xAuthorization,
                                 @"appLanguage":language,
                                 @"push_ios":push_ios
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"UAapp %@",responseObject);
         sharedManager.memberID = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"user_id"];
         
         //sharedManager.memberID = @"3";//อย่าลืมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมม
         RightMenu *rm = (RightMenu*)[sharedManager.mainRoot.childViewControllers objectAtIndex:0];
         [rm loadProfile];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
     }];
}

- (IBAction)termClick:(id)sender
{
    if (termChecked == YES) {
        [checkBtn setImage:[UIImage imageNamed:@"form_check_off"] forState:UIControlStateNormal];
        termChecked = NO;
    }
    else
    {
        [checkBtn setImage:[UIImage imageNamed:@"form_check_on"] forState:UIControlStateNormal];
        termChecked = YES;
    }
    checkBtn.imageView.image = [checkBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [checkBtn.imageView setTintColor:sharedManager.mainThemeColor];
}

- (IBAction)acceptClick:(id)sender
{
    if (termChecked == YES) {
        [self loadHome];
    }
    else{
        [ISMessages showCardAlertWithTitle:@"\nกรุณากดยอมรับข้อกำหนดและเงื่อนไข\n"
                                   message:nil
                                  duration:2.f
                               hideOnSwipe:YES
                                 hideOnTap:YES
                                 alertType:ISAlertTypeError
                             alertPosition:ISAlertPositionBottom
                                   didHide:^(BOOL finished) {
                                   }];
    }
}

- (void)loadHome
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PambaMain" bundle:[NSBundle mainBundle]];
    MFSideMenuContainerViewController *container = [storyboard instantiateViewControllerWithIdentifier:@"MFSideMenuContainerViewController"];
    
    if (IS_IPHONE) {
        //[container setLeftMenuWidth:[UIScreen mainScreen].bounds.size.width*0.7];
        [container setRightMenuWidth:[UIScreen mainScreen].bounds.size.width*0.80];
        
    }
    if (IS_IPAD) {
        //[container setLeftMenuWidth:[UIScreen mainScreen].bounds.size.width*0.4];
        [container setRightMenuWidth:[UIScreen mainScreen].bounds.size.width*0.5];
    }
    [container setMenuSlideAnimationEnabled:YES];
    [container setMenuSlideAnimationFactor:3.0f];
    [container setMenuAnimationDefaultDuration:1.0f];
    
    UIViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"Home"];
    //UIViewController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightSideMenuViewController"];
    
    //[container setLeftMenuViewController:leftSideMenuViewController];
    [container setRightMenuViewController:rightSideMenuViewController];
    [container setCenterViewController:homeViewController];
    
    [self.navigationController pushViewController:container animated:NO];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
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

@end
