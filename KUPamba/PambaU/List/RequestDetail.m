//
//  RequestDetail.m
//  Pamba
//
//  Created by Firststep Consulting on 7/11/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "RequestDetail.h"
#import "MainCell.h"
#import "DetailCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "Profile.h"
#import "DriverProfile.h"
#import "Web.h"

@interface RequestDetail ()

@end

@implementation RequestDetail

@synthesize requestID,headerView,headerTitle,headerLBtn,myTable,actionBtn;

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
    
    owner = NO;
    
    [self loadList];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@viewRequest",HOST_DOMAIN];
    NSDictionary *parameters = @{@"oid":requestID,};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         listJSON = [[responseObject objectForKey:@"data"] mutableCopy];
         
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
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //float rowHeight = myTable.frame.size.height/5;
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    MainCell *cell1 = (MainCell *)[tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    DetailCell *cell2 = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:0];
    
    cell1.messageBtn.hidden = YES;
    cell1.callBtn.hidden = YES;
    
    if ([[cellArray objectForKey:@"user"] isEqualToString:sharedManager.memberID]) {
        owner = YES;
        [actionBtn setTitle:@"แก้ไขการหาเพื่อนร่วมทาง" forState:UIControlStateNormal];
        [actionBtn setBackgroundColor:sharedManager.btnThemeColor];
        actionBtn.enabled = YES;
        
        cell1.messageBtn.hidden = YES;
        cell1.callBtn.hidden = YES;
        
        [actionBtn.heightAnchor constraintEqualToConstant:0].active = YES;
        
        NSLog(@"เจ้าของทริป");
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
        
        /*
        [cell1.contactBtn addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
        cell1.contactBtn.tag = indexPath.row;
        
        [cell1.detailBtn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
        cell1.detailBtn.tag = indexPath.row;
        */
        cell1.nameLabel.text = [cellArray objectForKey:@"name"];
        cell1.startLabelR.text = [cellArray objectForKey:@"From"];
        cell1.endLabelR.text = [cellArray objectForKey:@"To"];
        cell1.dateLabelR.text = [cellArray objectForKey:@"goDate"];
        cell1.distanceLabelR.text = [cellArray objectForKey:@"distance"];
        cell1.timeLabelR.text = [NSString stringWithFormat:@"%@:%@ น.",[cellArray objectForKey:@"goH"],[cellArray objectForKey:@"goM"]];
        
        cell1.seatLabelL.hidden = YES;
        cell1.seatLabelR.hidden = YES;
        //cell1.seatLabelR.text = [NSString stringWithFormat:@"%@ ที่นั่ง",[cellArray objectForKey:@"now_seat"]];
        
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
        
        /*
        cell1.nameLabel.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize+4];
        [self shorttext:cell1.nameLabel];
        cell1.reviewCount.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize+1];
        [self shorttext:cell1.reviewCount];
        cell1.startLabel.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize+1];
        [self shorttext:cell1.startLabel];
        cell1.endLabel.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize+1];
        [self shorttext:cell1.endLabel];
        
        cell1.dateLabel.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize-2];
        [self shorttext:cell1.dateLabel];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentCenter;
        paragraph.lineSpacing = 1.0f;
        paragraph.lineHeightMultiple = 0.7;     // Reduce this value !!!
        NSMutableAttributedString* attrText = [[NSMutableAttributedString alloc] initWithString:cell1.dateLabel.text];
        [attrText addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, cell1.dateLabel.text.length)];
        [cell1.dateLabel setAttributedText:attrText];
        cell1.timeLabel.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize-2];
        [self shorttext:cell1.timeLabel];
        cell1.distanceLabel.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize-2];
        [self shorttext:cell1.distanceLabel];
        */
        //cell1.seatPic.image = nil;
        //cell1.seatLabel.text = @"";
    
        cell = cell1;
    }
    
    if (indexPath.row == 1) {
        //DETAIL
        NSString *routeDetail = [cellArray objectForKey:@"remark"];
        if ([routeDetail isEqualToString:@""])
        {
            cell2.detailLabel.text = @"-";
        }
        else{
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithData:[routeDetail dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
            [cell2.detailLabel setText:[attrText string]];
            //[self shorttext:cell2.detailLabel];
        }
        
        //POST DATE
        cell2.extimeLabel.text = [NSString stringWithFormat:@"   โพสต์เมื่อ %@   ",[cellArray objectForKey:@"cdate"]];
        cell2.extimeLabel.layer.cornerRadius = 15;
        cell2.extimeLabel.layer.masksToBounds = YES;
        cell2.extimeLabel.layer.borderWidth = 3.0f;
        cell2.extimeLabel.layer.borderColor = cell2.extimeLabel.backgroundColor.CGColor;
        
        cell = cell2;
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

- (IBAction)profileClick:(id)sender {
    if(owner == YES)
    {
        Profile *pf = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        [self.navigationController pushViewController:pf animated:YES];
    }
    else{
        DriverProfile *drp = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverProfile"];
        drp.userType = @"passenger";
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
        [self alertTitle:@"Coming soon" detail:@"ขออภัยในความไม่สะดวก"];
    }
    else
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"โทรศัพท์" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self performSelector:@selector(callClick:) withObject:nil afterDelay:0];
            
            // Call button tappped.
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"ส่งข้อความ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self performSelector:@selector(messageClick:) withObject:nil afterDelay:0];
            
            // Chat button tappped.
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            // Cancel button tappped.
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
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
