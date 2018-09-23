//
//  OfferDetail.m
//  Pamba
//
//  Created by Firststep Consulting on 7/9/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "OfferDetail.h"
#import "MainCell.h"
#import "NoCell.h"
#import "DetailCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DriverProfile.h"
#import "Profile.h"
#import "Web.h"
#import "EditTrip.h"

@interface OfferDetail ()

@end

@implementation OfferDetail

@synthesize offerID,headerView,headerTitle,headerLBtn,myTable,actionBtn,scbBtn,carTypeLabel,priceLabel;

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
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    actionBtn.backgroundColor = sharedManager.btnThemeColor;
    actionBtn.titleLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    
    //carTypeLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:13];
    //priceLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:13];
    
    owner = NO;
    
    [self loadList];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@viewOffer",HOST_DOMAIN];
    NSDictionary *parameters = @{@"oid":offerID,
                                 @"userEmail":sharedManager.memberID};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         listJSON = [[responseObject objectForKey:@"data"] mutableCopy];
         
         NSDictionary *cellArray = [listJSON objectAtIndex:0];
         int carType = [[cellArray objectForKey:@"type"] intValue];
         NSString *carTypeStr;
         switch (carType) {
             case 1:
                 carTypeStr = @"รถยนต์";
                 break;
             case 2:
                 carTypeStr = @"รถตู้";
                 break;
             case 3:
                 carTypeStr = @"แท็กซี่";
                 break;
             case 4:
                 carTypeStr = @"จักรยานยนต์";
                 break;
             default:
                 break;
         }
         carTypeLabel.text = [NSString stringWithFormat:@"ประเภท : %@",carTypeStr];
         
         ////Price
         UIColor *leftColor = [UIColor colorWithRed:72.0/255 green:72.0/255 blue:72.0/255 alpha:1.0];
         UIColor *rightColor = sharedManager.mainThemeColor;
         
         UIFont *detailFontL = carTypeLabel.font;
         NSDictionary *detailDictL = [NSDictionary dictionaryWithObject: detailFontL forKey:NSFontAttributeName];
         
         UIFont *detailFontR = priceLabel.font;
         NSDictionary *detailDictR = [NSDictionary dictionaryWithObject:detailFontR forKey:NSFontAttributeName];
         
         NSMutableAttributedString *priceAttrStringL = [[NSMutableAttributedString alloc] initWithString:@"ราคา " attributes: detailDictL];
         [priceAttrStringL addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, priceAttrStringL.length))];
         
         NSString *priceText = [NSString stringWithFormat:@"%@ บาท",[cellArray objectForKey:@"price"]];
         NSMutableAttributedString *priceAttrStringR = [[NSMutableAttributedString alloc] initWithString:priceText attributes: detailDictR];
         [priceAttrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, priceAttrStringR.length))];
         
         [priceAttrStringL appendAttributedString:priceAttrStringR];
         priceLabel.attributedText = priceAttrStringL;
         
         [SVProgressHUD dismiss];
         
         [myTable reloadData];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             
             [self loadList];
         }];
         [alertController addAction:ok];
         
         [self presentViewController:alertController animated:YES completion:nil];
         
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (listJSON.count != 0) {
        return 3;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //float rowHeight = myTable.frame.size.height/5;
    if (indexPath.row == 1) {
        return myTable.frame.size.width/5.25;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    MainCell *cell1 = (MainCell *)[tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    NoCell *cell2 = (NoCell *)[tableView dequeueReusableCellWithIdentifier:@"NoCell"];
    
    DetailCell *cell3 = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:0];
    
    cell1.messageBtn.hidden = NO;
    cell1.callBtn.hidden = NO;
    
    if ([[cellArray objectForKey:@"user"] isEqualToString:sharedManager.memberID]) {
        owner = YES;
        [actionBtn setTitle:@"แก้ไขการเสนอที่นั่ง" forState:UIControlStateNormal];
        [actionBtn setBackgroundColor:sharedManager.btnThemeColor];
        actionBtn.enabled = YES;
        
        cell1.messageBtn.hidden = YES;
        cell1.callBtn.hidden = YES;
        
        [actionBtn.heightAnchor constraintEqualToConstant:0].active = YES;
        
        NSLog(@"เจ้าของทริป");
    }
    else if ([[cellArray objectForKey:@"join_status"] intValue] == 1) {
        [actionBtn setTitle:@"จองที่นั่งแล้ว" forState:UIControlStateNormal];
        [actionBtn setBackgroundColor:[UIColor grayColor]];
        actionBtn.enabled = NO;
        NSLog(@"จองแล้ว");
    }
    else if ([[cellArray objectForKey:@"now_seat"] intValue] == 0) {
        [actionBtn setTitle:@"ที่นั่งเต็ม" forState:UIControlStateNormal];
        [actionBtn setBackgroundColor:[UIColor grayColor]];
        actionBtn.enabled = NO;
        NSLog(@"ที่นั่งเต็ม");
    }
    else{
        [actionBtn setTitle:@"จองที่นั่ง" forState:UIControlStateNormal];
        [actionBtn setBackgroundColor:sharedManager.btnThemeColor];
        actionBtn.enabled = YES;
        NSLog(@"ยังไม่จอง");
    }
    
    if (indexPath.row == 0) {//MAIN (Top & Mid)
        
        [self setCircleBtn:cell1.userPicBtn circleImageName:[cellArray objectForKey:@"userPic"] circleColor:sharedManager.mainThemeColor withIcon:cell1.userPicIcon iconImageName:@"icon_search"];
        
        cell1.messageBtn.layer.cornerRadius = 2;
        cell1.messageBtn.layer.masksToBounds = YES;
        cell1.messageBtn.backgroundColor = sharedManager.btnThemeColor;
        
        if ([[cellArray objectForKey:@"mobile"] isEqualToString:@""]) {
            [cell1.callBtn setBackgroundColor:[UIColor grayColor]];
            cell1.callBtn.enabled = NO;
        }
        else{
            cell1.callBtn.backgroundColor = sharedManager.btnThemeColor;
            cell1.callBtn.enabled = YES;
        }
        cell1.callBtn.layer.cornerRadius = 2;
        cell1.callBtn.layer.masksToBounds = YES;
        
        cell1.nameLabel.text = [cellArray objectForKey:@"name"];
        cell1.startLabelR.text = [cellArray objectForKey:@"From"];
        cell1.endLabelR.text = [cellArray objectForKey:@"To"];
        cell1.dateLabelR.text = [cellArray objectForKey:@"goDate"];
        cell1.distanceLabelR.text = [cellArray objectForKey:@"distance"];
        cell1.timeLabelR.text = [NSString stringWithFormat:@"%@:%@ น.",[cellArray objectForKey:@"goH"],[cellArray objectForKey:@"goM"]];
        
        cell1.seatLabelL.hidden = YES;
        cell1.seatLabelR.hidden = YES;
        cell1.seatLabelR.text = [NSString stringWithFormat:@"%@ ที่นั่ง",[cellArray objectForKey:@"now_seat"]];
        
        cell1.reviewCount.text = [NSString stringWithFormat:@"(%@ รีวิว)",[[[cellArray objectForKey:@"rate"]objectAtIndex:0] objectForKey:@"total_review"]];
        
        int star = [[[[cellArray objectForKey:@"rate"] objectAtIndex:0] objectForKey:@"rate"] intValue];
        
        UIImage *starON = [UIImage imageNamed:@"cell_star"];
        UIImage *starOFF = [UIImage imageNamed:@"cell_star_off"];
        cell1.star1.image = starOFF;
        cell1.star2.image = starOFF;
        cell1.star3.image = starOFF;
        cell1.star4.image = starOFF;
        cell1.star5.image = starOFF;
        
        switch (star) {
                case 0:
                break;
                
                case 1:
                cell1.star1.image = starON;
                break;
                
                case 2:
                cell1.star1.image = starON;
                cell1.star2.image = starON;
                break;
                
                case 3:
                cell1.star1.image = starON;
                cell1.star2.image = starON;
                cell1.star3.image = starON;
                break;
                
                case 4:
                cell1.star1.image = starON;
                cell1.star2.image = starON;
                cell1.star3.image = starON;
                cell1.star4.image = starON;
                break;
                
                case 5:
                cell1.star1.image = starON;
                cell1.star2.image = starON;
                cell1.star3.image = starON;
                cell1.star4.image = starON;
                cell1.star5.image = starON;
                break;
                
            default:
                cell1.star1.image = starON;
                cell1.star2.image = nil;
                cell1.star3.image = starON;
                cell1.star4.image = nil;
                cell1.star5.image = starON;
                break;
        }
        cell = cell1;
    }

    if (indexPath.row == 1) { //No

        [self setAllowCircleImage:cell2.noPic1 withIcon:cell2.noIcon1 allowStatus:YES];
        [self setAllowCircleImage:cell2.noPic2 withIcon:cell2.noIcon2 allowStatus:YES];
        [self setAllowCircleImage:cell2.noPic3 withIcon:cell2.noIcon3 allowStatus:YES];
        [self setAllowCircleImage:cell2.noPic4 withIcon:cell2.noIcon4 allowStatus:YES];
        
        cell2.noLabel1.text = @"สูบบุหรี่ได้";
        cell2.noLabel2.text = @"สัตว์เลี้ยง";
        cell2.noLabel3.text = @"อาหาร";
        cell2.noLabel4.text = @"เปิดเพลง";
        
        NSArray *array = [cellArray objectForKey:@"option"];
        if ([array containsObject: @"smoking"])
        {
            [self setAllowCircleImage:cell2.noPic1 withIcon:cell2.noIcon1 allowStatus:NO];
            cell2.noLabel1.text = @"ห้ามสูบบุหรี่";
        }
        
        if ([array containsObject: @"pet"])
        {
            [self setAllowCircleImage:cell2.noPic2 withIcon:cell2.noIcon2 allowStatus:NO];
            cell2.noLabel2.text = @"ห้ามสัตว์เลี้ยง";
        }
        
        if ([array containsObject: @"food"])
        {
            [self setAllowCircleImage:cell2.noPic3 withIcon:cell2.noIcon3 allowStatus:NO];
            cell2.noLabel3.text = @"ห้ามทานอาหาร";
        }
        
        if ([array containsObject: @"music"])
        {
            [self setAllowCircleImage:cell2.noPic4 withIcon:cell2.noIcon4 allowStatus:NO];
            cell2.noLabel4.text = @"ไม่เปิดเพลง";
        }
        
        NSString *bagSize = [cellArray objectForKey:@"luggage"];
        cell2.noLabel5.text = [NSString stringWithFormat:@"กระเป๋าขนาด\n%@",bagSize];
        [self setAllowCircleImage:cell2.noPic5 withIcon:cell2.noIcon5 allowStatus:YES];
        /*
        if([bagSize isEqualToString:@"เล็ก"])
        {
        }
        else if([bagSize isEqualToString:@"กลาง"])
        {
        }
        else if([bagSize isEqualToString:@"ใหญ่"])
        {
        }
        */
        cell = cell2;
    }
    
    if (indexPath.row == 2) {//DETAIL
        
        NSString *routeDetail = [cellArray objectForKey:@"remark"];
        if ([routeDetail isEqualToString:@""])
        {
            cell3.detailLabel.text = @"-";
        }
        else{
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithData:[routeDetail dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
            [cell3.detailLabel setText:[attrText string]];
        }
        
        //WAYPOINT
        NSArray *waypointArray = [cellArray objectForKey:@"way_point"];
        NSString *waypoint = @"";
        if ([[waypointArray objectAtIndex:0] isEqualToString:@""]) {
            cell3.pickLabel.text = @"-";
        }
        else{
            for(int i = 0; i < [waypointArray count]; i++)
            {
                NSArray *subStrings = [[waypointArray objectAtIndex:i] componentsSeparatedByString:@","];
                NSString *firstString = [subStrings objectAtIndex:0];
                if (![firstString isEqualToString:@""]) {
                    waypoint = [NSString stringWithFormat:@"%@%d) %@\n",waypoint,i+1,firstString];
                }
            }
            cell3.pickLabel.text = waypoint;
        }
        
        //MAP
        NSString* strUrl = [NSString stringWithFormat:@"%@viewMap?oid=%@&type=offer",HOST_DOMAIN,offerID];
        NSURL *url = [NSURL URLWithString:strUrl];
        cell3.mapWeb.delegate = self;
        cell3.mapWeb.scrollView.bounces = NO;
        NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:url];
        [cell3.mapWeb loadRequest:requestURL];
        
        //POST DATE
        cell3.extimeLabel.text = [NSString stringWithFormat:@"   โพสต์เมื่อ %@   \n   การเจาะจงเวลาเดินทาง ± %@ (นาที)   \n",[cellArray objectForKey:@"cdate"],[cellArray objectForKey:@"exTime"]];
        cell3.extimeLabel.layer.cornerRadius = 15;
        cell3.extimeLabel.layer.masksToBounds = YES;
        cell3.extimeLabel.layer.borderWidth = 3.0f;
        cell3.extimeLabel.layer.borderColor = cell3.extimeLabel.backgroundColor.CGColor;
        cell = cell3;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setCircleBtn:(UIButton *)button circleImageName:(NSString *)imgName circleColor:(UIColor *)circleColor withIcon:(UIImageView *)icon iconImageName:(NSString *)iconName
{
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button sd_setImageWithURL:[NSURL URLWithString:imgName] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    button.layer.cornerRadius = (self.view.frame.size.width*0.125)/2;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 3.0f;
    button.layer.borderColor = circleColor.CGColor;
    
    icon.image = [UIImage imageNamed:iconName];
    icon.layer.cornerRadius = icon.frame.size.width/2;
    icon.layer.masksToBounds = YES;
    icon.backgroundColor = circleColor;
}

- (void)setAllowCircleImage:(UIImageView *)img withIcon:(UIImageView *)icon allowStatus:(BOOL )allow
{
    UIColor *circleColor;
    UIImage *iconImage;
    
    if (allow == YES) {
        circleColor = sharedManager.mainThemeColor;
        iconImage = [UIImage imageNamed:@"icon_yes"];
    }
    else{
        circleColor = sharedManager.cancelThemeColor;
        iconImage = [UIImage imageNamed:@"icon_no"];
    }
    
    [img setContentMode:UIViewContentModeScaleAspectFit];
    img.layer.cornerRadius = (myTable.frame.size.width*0.1)/2; //img.frame.size.width/2;
    img.layer.masksToBounds = YES;
    img.layer.borderWidth = 2.0f;
    img.layer.borderColor = circleColor.CGColor;
    
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    icon.image = iconImage;
    icon.layer.cornerRadius = icon.frame.size.width/2;
    icon.layer.masksToBounds = YES;
    icon.backgroundColor = circleColor;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //NSLog(@"Did start loading: %@", [[request URL] absoluteString]);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //self.view.alpha = 1.f;
    CGPoint bottomOffset = CGPointMake(0, webView.scrollView.contentSize.height/2 - webView.scrollView.bounds.size.height/2);
    [webView.scrollView setContentOffset:bottomOffset animated:YES];
    
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"!DidFailLoadWithError: %@", [error description]);
    //self.view.alpha = 1.f;
}

- (IBAction)profileClick:(id)sender {
    if(owner == YES)
    {
        Profile *pf = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        [self.navigationController pushViewController:pf animated:YES];
    }
    else{
        DriverProfile *drp = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverProfile"];
        drp.userType = @"driver";
        drp.driverID = [[listJSON objectAtIndex:0] objectForKey:@"user"];
        [self.navigationController pushViewController:drp animated:YES];
    }
}

- (IBAction)messageClick:(id)sender {
    Web *web = [self.storyboard instantiateViewControllerWithIdentifier:@"Web"];
    web.webTitle = @"กล่องข้อความ";
    web.urlString = [NSString stringWithFormat:@"%@ChatWV/message?userFrom=%@&userTo=%@",HOST_DOMAIN_INDEX,sharedManager.memberID,[[listJSON objectAtIndex:0] objectForKey:@"user"]];
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)callClick:(id)sender {
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",[[listJSON objectAtIndex:0] objectForKey:@"mobile"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}

- (IBAction)actionClick:(id)sender {
    if (owner == YES) {
        NSLog(@"แก้ดิ");
        
        NSDictionary *cellArray = [listJSON objectAtIndex:0];
        
        EditTrip *ofe = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTrip"];
        ofe.offerID = offerID;
        ofe.goDate = [cellArray objectForKey:@"goDate"];
        ofe.goH = [cellArray objectForKey:@"goH"];
        ofe.goM = [cellArray objectForKey:@"goM"];
        ofe.price = [cellArray objectForKey:@"price"];
        ofe.seats = [cellArray objectForKey:@"now_seat"];
        ofe.remark = [cellArray objectForKey:@"remark"];
        [self.navigationController pushViewController:ofe animated:YES];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Booking"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString* url = [NSString stringWithFormat:@"%@bookingSeat",HOST_DOMAIN];
        NSDictionary *parameters = @{@"oid":offerID,
                                     @"user":sharedManager.memberID
                                     };
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"detailJSON %@",responseObject);
             
             [SVProgressHUD showSuccessWithStatus:[[[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"status"] objectAtIndex:1]];
             
             [actionBtn setTitle:@"จองที่นั่งแล้ว" forState:UIControlStateNormal];
             [actionBtn setBackgroundColor:[UIColor grayColor]];
             actionBtn.enabled = NO;
             
             sharedManager.reloadOffer = YES;
         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error %@",error);
             [SVProgressHUD dismiss];
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                 
                 [self loadList];
             }];
             [alertController addAction:ok];
             
             [self presentViewController:alertController animated:YES completion:nil];
             
         }];
    }
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

- (UILabel *)shorttext:(UILabel *)originalLabel
{
    if (originalLabel.text) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:originalLabel.text];
        [text addAttribute:NSKernAttributeName value:[NSNumber numberWithDouble:-0.5] range:NSMakeRange(0, text.length)];
        [originalLabel setAttributedText:text];
    }
    return originalLabel;
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

