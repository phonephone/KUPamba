//
//  ProfileOffer.m
//  Pamba
//
//  Created by Firststep Consulting on 7/30/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "ProfileOffer.h"
#import "ProfileOfferDetail.h"
#import "ListCell.h"
#import "ReserveCell.h"
#import "OfferDetail.h"
#import "RequestDetail.h"
#import "Review.h"
#import "UIImageView+WebCache.h"
#import <CCMPopup/CCMPopupSegue.h>
#import "RightMenu.h"

@interface ProfileOffer ()

@end

@implementation ProfileOffer

@synthesize mode,headerView,headerTitle,headerLBtn,mycollectionView,noresultLabel;

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [mycollectionView.collectionViewLayout collectionViewContentSize];
    mycollectionView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    [mycollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    
    [self loadList];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    if ([mode isEqualToString:@"Offer"]) {
        headerTitle.text = @"การเสนอที่นั่งของคุณ";
    }
    
    if ([mode isEqualToString:@"Reserve"]) {
        headerTitle.text = @"การขอร่วมทางของคุณ";
    }
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [mycollectionView addSubview:refreshController];
    
    
    localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:localeTH];
    
    dayPicker = [[UIDatePicker alloc]init];
    [dayPicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [dayPicker setMinimumDate: [NSDate date]];
    [dayPicker setLocale:localeTH];
    dayPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
    dayPicker.tag = 1;
    [dayPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    dateField = [[UITextField alloc] init];
    dateField.inputView = dayPicker;
    dateField.delegate = self;
    [self.view addSubview:dateField];
}

-(void)handleRefresh : (id)sender
{
    //NSLog (@"Pull To Refresh Method Called");
    [self loadList];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    NSString* url;
    if ([mode isEqualToString:@"Offer"]) {
        url = [NSString stringWithFormat:@"%@ActiveOffer",HOST_DOMAIN];
    }
    
    if ([mode isEqualToString:@"Reserve"]) {
        url = [NSString stringWithFormat:@"%@ActiveReserve",HOST_DOMAIN];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         
         listJSON = [[responseObject objectForKey:@"data"] mutableCopy];
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
    if ([[[listJSON objectAtIndex:0] allKeys] containsObject:@"Error"]) {
        //ไม่มีรายการ
        rowNo = 0;
    }
    else{
        [mycollectionView reloadData];
        rowNo = [listJSON count];
    }
    
    if (rowNo == 0) {
        noresultLabel.hidden = NO;
        if ([mode isEqualToString:@"Offer"]) {
            noresultLabel.text = @"คุณยังไม่เคยมีประวัติการเสนอที่นั่ง";
        }
        
        if ([mode isEqualToString:@"Reserve"]) {
            noresultLabel.text = @"คุณยังไม่เคยมีประวัติการขอร่วมทาง";
        }
    }
    else{ noresultLabel.hidden = YES; }
    
    return rowNo;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (mycollectionView.frame.size.width)*0.936;
    float height = width*0.485;
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
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    if ([mode isEqualToString:@"Offer"]) {//การเสนอที่นั่งของคุณ
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
        
        [cell.trashBtn removeTarget:nil
                             action:NULL
                   forControlEvents:UIControlEventAllEvents];
        NSString *statusText;
        int statusID = [[[cellArray objectForKey:@"offer_status"] objectForKey:@"status_id"] intValue];
        statusText = [[cellArray objectForKey:@"offer_status"] objectForKey:@"status_text"];
        switch (statusID) {
            case 1://แจ้งเตือน
                [cell.trashBtn setTitle:@"" forState:UIControlStateNormal];
                [cell.trashBtn setImage:[UIImage imageNamed:@"icon_bin"] forState:UIControlStateNormal];
                [cell.trashBtn addTarget:self action:@selector(trashClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2://จบการเดินทาง
                [cell.trashBtn setTitle:@"ให้คะแนน" forState:UIControlStateNormal];
                [cell.trashBtn setImage:nil forState:UIControlStateNormal];
                [cell.trashBtn addTarget:self action:@selector(reviewClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        
        detailFontL = [UIFont fontWithName:cell.statusLabel.font.fontName size:15];
        detailDictL = [NSDictionary dictionaryWithObject: detailFontL forKey:NSFontAttributeName];
        
        detailFontR = [UIFont fontWithName:cell.statusLabel.font.fontName size:15];
        detailDictR = [NSDictionary dictionaryWithObject:detailFontR forKey:NSFontAttributeName];
        
        attrStringL = [[NSMutableAttributedString alloc] initWithString:@"สถานะ : " attributes: detailDictL];
        [attrStringL addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, attrStringL.length))];
        
        attrStringR = [[NSMutableAttributedString alloc] initWithString:statusText attributes: detailDictR];
        [attrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, attrStringR.length))];
        
        [attrStringL appendAttributedString:attrStringR];
        cell.statusLabel.attributedText = attrStringL;
        
        if ([[cellArray objectForKey:@"notification"] isEqualToString:@"0"])
        {
            cell.statusAlert.hidden = YES;
        }
        else
        {
            cell.statusAlert.hidden = NO;
        }
        
        [cell.duplicateBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.duplicateBtn addTarget:self action:@selector(copyClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.duplicateBtn.tag = indexPath.row;
        
        [cell.trashBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        cell.trashBtn.tag = indexPath.row;
        
        cell.moreBtn.backgroundColor = sharedManager.btnThemeColor;
        [cell.moreBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.moreBtn.tag = indexPath.row;
        
        myCell = cell;
    }
    
    if ([mode isEqualToString:@"Reserve"]) {//การสำรองที่นั่งของคุณ
        ReserveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReserveCell" forIndexPath:indexPath];
        
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
        
        
        [cell.trashBtn setTitle:@"" forState:UIControlStateNormal];
        [cell.trashBtn setImage:[UIImage imageNamed:@"icon_bin"] forState:UIControlStateNormal];
        [cell.trashBtn removeTarget:nil
                           action:NULL
                 forControlEvents:UIControlEventAllEvents];
        
        NSString *statusText;
        int statusID = [[[cellArray objectForKey:@"request_status"] objectForKey:@"status_id"] intValue];
        statusText = [[cellArray objectForKey:@"request_status"] objectForKey:@"status_text"];
        switch (statusID) {
            case 1://รอ
                rightColor = [UIColor blackColor];
                [cell.trashBtn addTarget:self action:@selector(trashClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2://ยอมรับ
                rightColor = sharedManager.mainThemeColor;
                [cell.trashBtn addTarget:self action:@selector(trashClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3://ปฏิเสธ
                rightColor = sharedManager.cancelThemeColor;
                [cell.trashBtn addTarget:self action:@selector(trashClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 4://จบการเดินทาง
                rightColor = [UIColor grayColor];
                [cell.trashBtn setTitle:@"ให้คะแนน" forState:UIControlStateNormal];
                [cell.trashBtn setImage:nil forState:UIControlStateNormal];
                [cell.trashBtn addTarget:self action:@selector(reviewClick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
        
        detailFontL = [UIFont fontWithName:cell.statusLabel.font.fontName size:15];
        detailDictL = [NSDictionary dictionaryWithObject: detailFontL forKey:NSFontAttributeName];
        
        detailFontR = [UIFont fontWithName:cell.statusLabel.font.fontName size:18];
        detailDictR = [NSDictionary dictionaryWithObject:detailFontR forKey:NSFontAttributeName];
        
        attrStringL = [[NSMutableAttributedString alloc] initWithString:@"สถานะ : " attributes: detailDictL];
        [attrStringL addAttribute:NSForegroundColorAttributeName value:leftColor range:(NSMakeRange(0, attrStringL.length))];
        
        attrStringR = [[NSMutableAttributedString alloc] initWithString:statusText attributes: detailDictR];
        [attrStringR addAttribute:NSForegroundColorAttributeName value:rightColor range:(NSMakeRange(0, attrStringR.length))];
        
        [attrStringL appendAttributedString:attrStringR];
        cell.statusLabel.attributedText = attrStringL;
        
        [cell.trashBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        cell.trashBtn.tag = indexPath.row;
        
        cell.moreBtn.backgroundColor = sharedManager.btnThemeColor;
        [cell.moreBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.moreBtn.tag = indexPath.row;
        
        myCell = cell;
    }
    
    return myCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([mode isEqualToString:@"Offer"]) {
        ProfileOfferDetail *pofd = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileOfferDetail"];
        pofd.offerID = [[listJSON objectAtIndex:indexPath.row] objectForKey:@"id"];
        [self.navigationController pushViewController:pofd animated:YES];
        
    }
    if ([mode isEqualToString:@"Reserve"]) {

    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setLocale:localeTH];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    goDate = [df1 stringFromDate:dayPicker.date];
    NSDate *ceYear = [df1 dateFromString:goDate];
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:localeEN];
    [df2 setDateFormat:@"yyyy-MM-dd"];
    goDateEN = [df2 stringFromDate:ceYear];
    
    [df setDateFormat:@"HH : mm"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:dayPicker.date];
    goH = [NSString stringWithFormat:@"%ld",(long)[components hour]];
    goM = [NSString stringWithFormat:@"%ld",(long)[components minute]];
    
    [self duplicate];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSLog(@"Date %@",datePicker.date);
}

- (void)moreClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //[self collectionView:mycollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:1]];
    
    OfferDetail *ofd = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferDetail"];
    ofd.offerID = [[listJSON objectAtIndex:button.tag] objectForKey:@"id"];
    [self.navigationController pushViewController:ofd animated:YES];
}

- (void)alertClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Alert %ld",(long)button.tag);
    selectID = [[listJSON objectAtIndex:button.tag] objectForKey:@"id"];
    [self performSegueWithIdentifier:@"manageOffer" sender:nil];
}

- (void)copyClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Copy %ld",(long)button.tag);
    selectID = [[listJSON objectAtIndex:button.tag] objectForKey:@"id"];
    [dateField becomeFirstResponder];
}

- (void)duplicate
{
    [SVProgressHUD showWithStatus:@"Duplicating"];
    
    NSString* url = [NSString stringWithFormat:@"%@Duplicate",HOST_DOMAIN];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"oid":selectID,
                                 @"goDate":goDateEN,
                                 @"goH":goH,
                                 @"goM":goM};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"copyJSON %@",responseObject);
         [SVProgressHUD showSuccessWithStatus:@"การเสนอที่นั่งถูกบันทึกแล้ว"];
         
         [self loadList];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
     }];
}

- (void)trashClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Trash %ld",(long)button.tag);
    selectID = [[listJSON objectAtIndex:button.tag] objectForKey:@"id"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการลบข้อมูล" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self loadDelete];
    }];
    [alertController addAction:ok];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)reviewClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Review %ld",(long)button.tag);
    
    Review *rev = [self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
    rev.mode = mode;
    rev.reViewID = [[listJSON objectAtIndex:button.tag] objectForKey:@"id"];
    [self.navigationController pushViewController:rev animated:YES];
}

- (void)loadDelete
{
    [SVProgressHUD showWithStatus:@"Deleting"];
    
    NSString* url;
    
    if ([mode isEqualToString:@"Offer"]) {
        url = [NSString stringWithFormat:@"%@cancelOffer",HOST_DOMAIN];
    }
    
    if ([mode isEqualToString:@"Reserve"]) {
        url = [NSString stringWithFormat:@"%@cancelBooking",HOST_DOMAIN];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID,
                                 @"oid":selectID};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"deleteJSON %@",responseObject);
         
         [SVProgressHUD showSuccessWithStatus:@"ยกเลิกเรียบร้อย"];
         
         [self loadList];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
     }];
}

- (IBAction)back:(id)sender
{
    RightMenu *rm = (RightMenu*)[sharedManager.mainRoot.childViewControllers objectAtIndex:0];
    [rm loadProfile];
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

