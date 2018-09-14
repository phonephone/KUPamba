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

@synthesize userID,rqDTTM,deviceID,appID,funcCode,userToken,xAuthorization,inquiryUserProfile,firstNameTh,firstNameEn,lastNameTh,lastNameEn,facultyNameTh,facultyNameEn,profileImageUrl,gender,studentCode,isSharewayAccepted,language;

@synthesize headerView,headerTitle,headerLBtn,termLabel,checkBtn,checkLabel,acceptBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"USER ID = %@",userID);
    
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
    
    if (!userID) {
        userID = @"1";//อย่าลืมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมม
    }
    
    sharedManager.loginStatus = NO;//อย่าลืมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมม
    
    sharedManager.memberID = userID;
    
    if (sharedManager.loginStatus == YES)
    {
        [self loadHome];
    }
    
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
