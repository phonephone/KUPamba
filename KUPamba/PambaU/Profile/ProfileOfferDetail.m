//
//  ProfileOfferDetail.m
//  Pamba
//
//  Created by Firststep Consulting on 7/30/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "ProfileOfferDetail.h"
#import "ProfileOffer.h"
#import "ListCell.h"
#import "UIImageView+WebCache.h"
#import "Web.h"

@interface ProfileOfferDetail ()

@end

@implementation ProfileOfferDetail

@synthesize offerID,headerView,headerTitle,headerLBtn,mycollectionView,noresultLabel;

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [mycollectionView.collectionViewLayout collectionViewContentSize];
    mycollectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    [mycollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    sharedManager.reloadOffer = YES;
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    noresultLabel.hidden = YES;
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [mycollectionView addSubview:refreshController];
    
    [self loadList];
}

-(void)handleRefresh : (id)sender
{
    //NSLog (@"Pull To Refresh Method Called");
    [self loadList];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    NSString* url = [NSString stringWithFormat:@"%@manageOffer",HOST_DOMAIN];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID,
                                 @"oid":offerID};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         
         listJSON = [[[responseObject objectForKey:@"data"] objectAtIndex:0] mutableCopy];
         [mycollectionView reloadData];
         
         [refreshController endRefreshing];
         [SVProgressHUD dismiss];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [refreshController endRefreshing];
         [SVProgressHUD dismiss];
         
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             
             [self loadList];
         }];
         [alertController addAction:ok];
         
         [self presentViewController:alertController animated:YES completion:nil];
         
     }];
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    long rowNo;
    if ([[listJSON allKeys] containsObject:@"Error"]||[[[[[listJSON objectForKey:@"JoinUser"] objectAtIndex:0] objectAtIndex:0] allKeys] containsObject:@"Error"]) {
        //ไม่มีรายการ
        rowNo = 0;
    }
    else{
        rowNo = [[[listJSON objectForKey:@"JoinUser"] objectAtIndex:0] count]+1;
    }
    
    if (rowNo == 0) { noresultLabel.hidden = NO; }
    else{ noresultLabel.hidden = YES; }
    
    return rowNo;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (mycollectionView.frame.size.width)*0.936;
    float height = width*0.357;
    CGSize itemSize = CGSizeMake(width,height);
    return itemSize;//mycollectionView.collectionViewLayout.collectionViewContentSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 0, 15, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 15.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *myCell;
    
    if (indexPath.row == 0) {
        NSDictionary *cellArray = listJSON;
        ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
        
        cell.startLabel.text = [cellArray objectForKey:@"From"];
        cell.endLabel.text = [cellArray objectForKey:@"To"];
        
        cell.priceLabel.textColor = sharedManager.mainThemeColor;
        cell.priceLabel.text = [cellArray objectForKey:@"price"];
        cell.bahtLabel.textColor = sharedManager.mainThemeColor;
        cell.bahtLabel.text = @"บาท/คน";
        
        int carType = [[cellArray objectForKey:@"type"] intValue];
        
        switch (carType) {
            case 1:
                cell.carTypeLabel.text = @"รถยนต์";
                break;
            case 2:
                cell.carTypeLabel.text = @"รถตู้";
                break;
            case 3:
                cell.carTypeLabel.text = @"แท็กซี่";
                break;
            case 4:
                cell.carTypeLabel.text = @"จักรยานยนต์";
                break;
            default:
                break;
        }
        
        ////Car Type
        UIColor *leftColor = [UIColor colorWithRed:72.0/255 green:72.0/255 blue:72.0/255 alpha:1.0];
        UIColor *rightColor = [UIColor blackColor];
        
        UIFont *detailFontL = [UIFont fontWithName:cell.carTypeLabel.font.fontName size:13];
        NSDictionary *detailDictL = [NSDictionary dictionaryWithObject: detailFontL forKey:NSFontAttributeName];
        
        UIFont *detailFontR = [UIFont fontWithName:cell.carTypeLabel.font.fontName size:15];
        NSDictionary *detailDictR = [NSDictionary dictionaryWithObject:detailFontR forKey:NSFontAttributeName];
        
        NSMutableAttributedString *attrStringL = [[NSMutableAttributedString alloc] initWithString:@"ประเภท " attributes: detailDictL];
        [attrStringL addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, attrStringL.length))];
        
        NSMutableAttributedString *attrStringR = [[NSMutableAttributedString alloc] initWithString:cell.carTypeLabel.text attributes: detailDictR];
        [attrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, attrStringR.length))];
        
        [attrStringL appendAttributedString:attrStringR];
        cell.carTypeLabel.attributedText = attrStringL;
        
        
        cell.dateLabel.text = [NSString stringWithFormat:@"%@ เวลา %@:%@ น.",[cellArray objectForKey:@"goDate"],[cellArray objectForKey:@"goH"],[cellArray objectForKey:@"goM"]];
        cell.seatLabel.text = [NSString stringWithFormat:@"เหลือ %@ ที่นั่ง",[cellArray objectForKey:@"now_seat"]];
        
        myCell = cell;
    }
    
    else{
        NSDictionary *cellArray = [[[listJSON objectForKey:@"JoinUser"] objectAtIndex:0] objectAtIndex:indexPath.row-1];
        ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ManageCell" forIndexPath:indexPath];
        
        [cell.userPic sd_setImageWithURL:[NSURL URLWithString:[cellArray objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
        
        cell.userPic.layer.cornerRadius = ((mycollectionView.frame.size.width-25)*0.15)/2;
        cell.userPic.layer.masksToBounds = YES;
        
        cell.nameLabel.text = [cellArray objectForKey:@"name"];
        
        cell.reviewCount.text = [NSString stringWithFormat:@"(%@ รีวิว)",[cellArray objectForKey:@"total_review"]];
        
        int star = [[cellArray objectForKey:@"rate"] intValue];
        
        UIImage *starON = [UIImage imageNamed:@"cell_star"];
        UIImage *starOFF = [UIImage imageNamed:@"cell_star_off"];
        cell.star1.image = starOFF;
        cell.star2.image = starOFF;
        cell.star3.image = starOFF;
        cell.star4.image = starOFF;
        cell.star5.image = starOFF;
        
        switch (star) {
            case 0:
                break;
                
            case 1:
                cell.star1.image = starON;
                break;
                
            case 2:
                cell.star1.image = starON;
                cell.star2.image = starON;
                break;
                
            case 3:
                cell.star1.image = starON;
                cell.star2.image = starON;
                cell.star3.image = starON;
                break;
                
            case 4:
                cell.star1.image = starON;
                cell.star2.image = starON;
                cell.star3.image = starON;
                cell.star4.image = starON;
                break;
                
            case 5:
                cell.star1.image = starON;
                cell.star2.image = starON;
                cell.star3.image = starON;
                cell.star4.image = starON;
                cell.star5.image = starON;
                break;
                
            default:
                cell.star1.image = starON;
                cell.star2.image = nil;
                cell.star3.image = starON;
                cell.star4.image = nil;
                cell.star5.image = starON;
                break;
        }
        cell.chatBtn.layer.cornerRadius = 2;
        cell.chatBtn.layer.masksToBounds = YES;
        cell.chatBtn.backgroundColor = sharedManager.btnThemeColor;
        [cell.chatBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.chatBtn addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.chatBtn.tag = indexPath.row;
        
        [cell.acceptBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.acceptBtn addTarget:self action:@selector(acceptClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.acceptBtn.tag = indexPath.row;
        
        
        [cell.rejectBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.rejectBtn addTarget:self action:@selector(rejectClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.rejectBtn.tag = indexPath.row;
        
        if ([[cellArray objectForKey:@"status"] isEqualToString:@"1"]) {//รอ
            cell.acceptBtn.enabled = YES;
            cell.rejectBtn.enabled = YES;
            cell.acceptBtn.backgroundColor = sharedManager.mainThemeColor;
            cell.rejectBtn.backgroundColor = sharedManager.cancelThemeColor;
        }
        else if ([[cellArray objectForKey:@"status"] isEqualToString:@"2"]) {//ยอมรับ
            cell.acceptBtn.enabled = NO;
            cell.rejectBtn.enabled = NO;
            cell.acceptBtn.backgroundColor = sharedManager.mainThemeColor;
            cell.rejectBtn.backgroundColor = [UIColor colorWithRed:172.0/255 green:172.0/255 blue:172.0/255 alpha:1.0];
        }
        else if ([[cellArray objectForKey:@"status"] isEqualToString:@"3"]) {//ปฏิเสธ
            cell.acceptBtn.enabled = NO;
            cell.rejectBtn.enabled = NO;
            cell.acceptBtn.backgroundColor = [UIColor colorWithRed:172.0/255 green:172.0/255 blue:172.0/255 alpha:1.0];
            cell.rejectBtn.backgroundColor = sharedManager.cancelThemeColor;
        }
        
        myCell = cell;
    }
    
    return myCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    OfferDetail *ofd = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferDetail"];
    ofd.offerID = [[listJSON objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:ofd animated:YES];
    */
}

- (void)chatClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Chat %ld",(long)button.tag);
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"ส่งข้อความ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        Web *web = [self.storyboard instantiateViewControllerWithIdentifier:@"Web"];
        web.webTitle = @"กล่องข้อความ";
        web.urlString = [NSString stringWithFormat:@"%@ChatWV/message?userFrom=%@&userTo=%@",HOST_DOMAIN_INDEX,sharedManager.memberID,[[[[listJSON objectForKey:@"JoinUser"] objectAtIndex:0] objectAtIndex:button.tag-1] objectForKey:@"user_id"]];
        
        [self.navigationController pushViewController:web animated:YES];
        //[web setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        //[self presentViewController:web animated:YES completion:nil];
        
        // Chat button tappped.
    }]];
    
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",[[[[listJSON objectForKey:@"JoinUser"] objectAtIndex:0] objectAtIndex:button.tag-1] objectForKey:@"mobile"]];
    if ([telNumber isEqualToString:@"tel:"]) {
    }
    else{
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"โทรศัพท์" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
            // Call button tappped.
        }]];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)setAcceptOrRejectAtIndex:(NSInteger)indexRow status:(NSString *)status
{
    ListCell *cell = (ListCell*)[mycollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexRow inSection:0]];
    if ([status isEqualToString:@"1"]) {//รอ
        cell.acceptBtn.enabled = YES;
        cell.rejectBtn.enabled = YES;
        cell.acceptBtn.backgroundColor = sharedManager.mainThemeColor;
        cell.rejectBtn.backgroundColor = sharedManager.cancelThemeColor;
    }
    else if ([status isEqualToString:@"2"]) {//ยอมรับ
        cell.acceptBtn.enabled = NO;
        cell.rejectBtn.enabled = NO;
        cell.acceptBtn.backgroundColor = sharedManager.mainThemeColor;
        cell.rejectBtn.backgroundColor = [UIColor colorWithRed:172.0/255 green:172.0/255 blue:172.0/255 alpha:1.0];
    }
    else if ([status isEqualToString:@"3"]) {//ปฏิเสธ
        cell.acceptBtn.enabled = NO;
        cell.rejectBtn.enabled = NO;
        cell.acceptBtn.backgroundColor = [UIColor colorWithRed:172.0/255 green:172.0/255 blue:172.0/255 alpha:1.0];
        cell.rejectBtn.backgroundColor = sharedManager.cancelThemeColor;
    }
}

- (void)acceptClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Accept %ld",(long)button.tag);
    
    [self setAcceptOrRejectAtIndex:button.tag status:@"2"];
    
    [self manageOffer:[[[[listJSON objectForKey:@"JoinUser"] objectAtIndex:0] objectAtIndex:button.tag-1] objectForKey:@"accept_bt"]];
}

- (void)rejectClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Reject %ld",(long)button.tag);
    
    [self setAcceptOrRejectAtIndex:button.tag status:@"3"];
    
    [self manageOffer:[[[[listJSON objectForKey:@"JoinUser"] objectAtIndex:0] objectAtIndex:button.tag-1] objectForKey:@"refuse_bt"]];
}

- (void)manageOffer:(NSString *)url
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"Response %@",responseObject);
         
         [self loadList];
         [refreshController endRefreshing];
         [SVProgressHUD dismiss];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [refreshController endRefreshing];
         [SVProgressHUD dismiss];
         
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please check your internet connection and try again" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
             
         }];
         [alertController addAction:ok];
         
         [self presentViewController:alertController animated:YES completion:nil];
         
     }];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
