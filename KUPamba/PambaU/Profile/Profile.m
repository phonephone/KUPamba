//
//  Profile.m
//  Pamba
//
//  Created by Firststep Consulting on 7/14/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "Profile.h"
#import "Web.h"
#import "UIImageView+WebCache.h"
#import "RightMenu.h"

@interface Profile ()

@end

@implementation Profile

@synthesize headerView,headerTitle,headerLBtn,headerRBtn,myScroll,myPage,profilePic,star1,star2,star3,star4,star5,reviewCount,profileL1,profileL2,profileL3,profileL4,profileR1,profileR2,profileR3,profileR4,carTitle,carL1,carL2,carL3,carL4,carR1,carR2,carR3,carR4;

- (void)viewWillLayoutSubviews
{
    //Circle
    profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
    profilePic.layer.masksToBounds = YES;
    
    //Border
    //profilePic.layer.borderWidth = 3.0f;
    //profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    myScroll.contentSize = CGSizeMake(myScroll.frame.size.width*picNumber,myScroll.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    
    [self loadProfile];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    myPage.currentPageIndicatorTintColor = sharedManager.mainThemeColor;
    
    [self updateProfile];
}

- (void)loadProfile
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@viewProfile",HOST_DOMAIN];
    NSDictionary *parameters = @{@"uid":sharedManager.memberID,
                                 @"me":@"1"
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"profileJSON %@",responseObject);
         sharedManager.profileJSON = [[[responseObject objectForKey:@"data"] objectAtIndex:0] mutableCopy];
         [SVProgressHUD dismiss];
         
         [self updateProfile];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             
             [self loadProfile];
         }];
         [alertController addAction:ok];
         [self presentViewController:alertController animated:YES completion:nil];
     }];
}

- (void)updateProfile
{
    //profilePic.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:[NSURL URLWithString:[sharedManager.profileJSON objectForKey:@"userPic"]]]];
    [profilePic sd_setImageWithURL:[NSURL URLWithString:[sharedManager.profileJSON objectForKey:@"userPic"]] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    
    reviewCount.text = [NSString stringWithFormat:@"(%@ รีวิว)",[[[sharedManager.profileJSON objectForKey:@"rate"]objectAtIndex:0] objectForKey:@"total_review"]];
    
    int star = [[[[sharedManager.profileJSON objectForKey:@"rate"] objectAtIndex:0] objectForKey:@"rate"] intValue];
    
    UIImage *starON = [UIImage imageNamed:@"cell_star"];
    UIImage *starOFF = [UIImage imageNamed:@"cell_star_off"];
    star1.image = starOFF;
    star2.image = starOFF;
    star3.image = starOFF;
    star4.image = starOFF;
    star5.image = starOFF;
    
    switch (star) {
        case 0:
            break;
            
        case 1:
            star1.image = starON;
            break;
            
        case 2:
            star1.image = starON;
            star2.image = starON;
            break;
            
        case 3:
            star1.image = starON;
            star2.image = starON;
            star3.image = starON;
            break;
            
        case 4:
            star1.image = starON;
            star2.image = starON;
            star3.image = starON;
            star4.image = starON;
            break;
            
        case 5:
            star1.image = starON;
            star2.image = starON;
            star3.image = starON;
            star4.image = starON;
            star5.image = starON;
            break;
            
        default:
            star1.image = starON;
            star2.image = nil;
            star3.image = starON;
            star4.image = nil;
            star5.image = starON;
            break;
    }
    //PROFILE
    profileL1.text = @"ชื่อ - นามสกุล";
    profileR1.text = [sharedManager.profileJSON objectForKey:@"name"];
    
    profileL2.text = @"อีเมล";
    profileR2.text = [sharedManager.profileJSON objectForKey:@"email"];
    
    profileL3.text = @"เบอร์โทร";
    profileR3.text = [sharedManager.profileJSON objectForKey:@"mobile"];
    
    profileL4.text = @"หมายเลขพร้อมเพย์";
    int promptpayType = [[sharedManager.profileJSON objectForKey:@"promtpayType"] intValue];
    switch (promptpayType) {
        case 0:
            profileR4.text = @"ไม่ระบุ";
            break;
        case 1://Mobile
            profileR4.text = [sharedManager.profileJSON objectForKey:@"promtpayMobileNumber"];
            break;
        case 2://ID Card
            profileR4.text = [sharedManager.profileJSON objectForKey:@"citizenID"];
            break;
        
        default:
            break;
    }
    
    //CAR
    NSDictionary *carArray = [[sharedManager.profileJSON objectForKey:@"carDetail"] objectAtIndex:0];
    
    carL1.text = @"ประเภท";
    int carType = [[carArray objectForKey:@"type"] intValue];
    switch (carType) {
        case 1:
            carR1.text = @"รถยนต์";
            break;
        case 2:
            carR1.text = @"รถตู้";
            break;
        case 3:
            carR1.text = @"แท็กซี่";
            break;
        case 4:
            carR1.text = @"จักรยานยนต์";
            break;
        default:
            break;
    }
    
    carL2.text = @"ยี่ห้อ";
    carR2.text = [carArray objectForKey:@"brand"];
    
    carL3.text = @"รุ่น";
    carR3.text = [carArray objectForKey:@"model"];
    
    carL4.text = @"ป้ายทะเบียน";
    carR4.text = [carArray objectForKey:@"plateNo"];
        
    for (UIView *v in myScroll.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    
    NSMutableArray *picArray = [carArray objectForKey:@"pic"];
    
    for (int i=0; i<[picArray count]; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(myScroll.frame.size.width*i, 0, myScroll.frame.size.width, myScroll.frame.size.height)];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:[[picArray objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"xicon1024.png"]];
        
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        [myScroll addSubview:imgView];
    }
    picNumber = [picArray count];
    myPage.numberOfPages = [picArray count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = myScroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = myScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    myPage.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (IBAction)profileEdit:(id)sender
{
    Web *web = [self.storyboard instantiateViewControllerWithIdentifier:@"Web"];
    web.webTitle = @"แก้ไขข้อมูล";
    web.urlString = [NSString stringWithFormat:@"%@profileWebview/viewProfile?userEmail=%@",HOST_DOMAIN_INDEX,sharedManager.memberID];
    [self.navigationController pushViewController:web animated:YES];
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
