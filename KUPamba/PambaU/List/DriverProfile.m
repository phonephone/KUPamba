//
//  DriverProfile.m
//  Pamba
//
//  Created by Firststep Consulting on 7/18/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "DriverProfile.h"
#import "UIImageView+WebCache.h"
#import "Web.h"

@interface DriverProfile ()

@end

@implementation DriverProfile

@synthesize userType,driverID,headerView,headerTitle,headerLBtn,myScroll,myPage,profilePic,star1,star2,star3,star4,star5,reviewCount,carDetail,profileName,universityName,offerCount,requestCount,chatBtn,chatBtnIcon,chatBtnLabel,callBtn,callBtnIcon,callBtnLabel;

- (void)viewWillLayoutSubviews
{
    //Circle
    profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
    profilePic.layer.masksToBounds = YES;
    
    //fbPic.layer.cornerRadius = profilePic.frame.size.height/2;
    //fbPic.layer.masksToBounds = YES;
    
    //Border
    //profilePic.layer.borderWidth = 3.0f;
    //profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)viewDidLayoutSubviews
{
    myScroll.contentSize = CGSizeMake(myScroll.frame.size.width*picNumber,myScroll.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    chatBtn.backgroundColor = sharedManager.btnThemeColor;
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    chatBtnLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    
    callBtn.backgroundColor = sharedManager.mainThemeColor;
    callBtn.titleLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    callBtnLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    
    profileName.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    reviewCount.font = [UIFont systemFontOfSize:sharedManager.fontSize13 weight:UIFontWeightRegular];
    offerCount.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    requestCount.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    carDetail.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    
    myPage.currentPageIndicatorTintColor = sharedManager.mainThemeColor;
    
    if ([userType isEqualToString:@"driver"]) {
        headerTitle.text = @"ข้อมูลผู้ขับ";
        //callBtnLabel.text = @"โทรหาXXX";
    }
    else
    {
        headerTitle.text = @"ข้อมูลผู้โดยสาร";
        //callBtnLabel.text = @"โทรหาXXX";
    }
    
    [self loadProfile];
}

- (void)loadProfile
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@viewProfile",HOST_DOMAIN];
    NSDictionary *parameters = @{@"uid":driverID,
                                 @"me":@"0"
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"driverJSON %@",responseObject);
         driverJSON = [[[responseObject objectForKey:@"data"] objectAtIndex:0] mutableCopy];
         carArray = [[driverJSON objectForKey:@"carDetail"] objectAtIndex:0];
         
         [self setDriver];
         
         [SVProgressHUD dismiss];
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

- (void)setDriver
{
    profilePic.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:[NSURL URLWithString:[driverJSON objectForKey:@"userPic"]]]];
    //[profilePic sd_setImageWithURL:[NSURL URLWithString:[driverJSON objectForKey:@"userPic"]] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    
    profileName.text = [driverJSON objectForKey:@"name"];
    
    NSString *university = [driverJSON objectForKey:@"university"];
    if ([university isEqualToString:@"ไม่ระบุ"]) {
        universityName.text = @"ไม่ระบุมหาวิทยาลัย";
    }
    else
    {
        universityName.text = [NSString stringWithFormat:@"มหาวิทยาลัย%@",university];
    }
    
    reviewCount.text = [NSString stringWithFormat:@"(%@ รีวิว)",[[[driverJSON objectForKey:@"rate"]objectAtIndex:0] objectForKey:@"total_review"]];
    
    int star = [[[[driverJSON objectForKey:@"rate"] objectAtIndex:0] objectForKey:@"rate"] intValue];
    
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
    
    offerCount.text = [NSString stringWithFormat:@"เสนอที่นั่ง %@ ครั้ง",[driverJSON objectForKey:@"totalOffer"]];
    requestCount.text = [NSString stringWithFormat:@"โดยสารรถ %@ ครั้ง",[driverJSON objectForKey:@"totalRequest"]];
    
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
    
    NSString *car1 = @"ยี่ห้อ :";
    NSString *car2 = @"รุ่น :";
    NSString *car3 = @"ป้ายทะเบียน :";
    
    NSMutableAttributedString *attrString;
    NSMutableAttributedString *attrString2;
    NSMutableAttributedString *attrString3;
    
    if (![[carArray objectForKey:@"brand"] isEqualToString:@""]) {
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@    ",car1,[carArray objectForKey:@"brand"]]];
    }
    else{
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ -    ",car1]];
    }
    
    if (![[carArray objectForKey:@"model"] isEqualToString:@""]) {
        attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@\n",car2,[carArray objectForKey:@"model"]]];
    }
    else{
        attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ -\n",car2]];
    }
    
    if (![[carArray objectForKey:@"plateNo"] isEqualToString:@""]) {
        attrString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",car3,[carArray objectForKey:@"plateNo"]]];
    }
    else{
        attrString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ -",car3]];
    }
    
    [attrString appendAttributedString:attrString2];
    [attrString appendAttributedString:attrString3];
    
    [carDetail setAttributedText:attrString];
    
    if ([[driverJSON objectForKey:@"mobile"] isEqualToString:@""]) {
        [callBtn setBackgroundColor:[UIColor grayColor]];
        callBtn.enabled = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = myScroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = myScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    myPage.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (IBAction)messageClick:(id)sender {
    Web *web = [self.storyboard instantiateViewControllerWithIdentifier:@"Web"];
    web.webTitle = @"กล่องข้อความ";
    web.urlString = [NSString stringWithFormat:@"%@ChatWV/message?userFrom=%@&userTo=%@",HOST_DOMAIN_INDEX,sharedManager.memberID,[driverJSON objectForKey:@"user"]];
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)callClick:(id)sender {
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",[driverJSON objectForKey:@"mobile"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}

- (IBAction)payBySCB:(id)sender
{
    //[SCBPayHelper pay];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:SCB_APP_URL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SCB_APP_URL]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SCB_STORE_URL]];
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
