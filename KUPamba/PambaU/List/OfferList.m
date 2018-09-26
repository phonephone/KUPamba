//
//  OfferList.m
//  Pamba
//
//  Created by Firststep Consulting on 7/7/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "OfferList.h"
#import "OfferDetail.h"
#import "OfferForm.h"
#import "Search.h"
#import "ListCell.h"
#import "ResultHeader.h"
#import "UIImageView+WebCache.h"
#import "FTPopOverMenu.h"

@interface OfferList ()

@end

@implementation OfferList

@synthesize mycollectionView,addBtn;

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [mycollectionView.collectionViewLayout collectionViewContentSize];
    [mycollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (sharedManager.reloadOffer == YES) {
        [self loadList];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [mycollectionView addSubview:refreshController];
    
    [addBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    addBtn.backgroundColor = sharedManager.btnThemeColor;
    addBtn.layer.cornerRadius = addBtn.frame.size.width/2;
    //addBtn.layer.masksToBounds = YES;
    addBtn.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    addBtn.layer.shadowRadius = 3;
    addBtn.layer.shadowOpacity = 0.8;
    addBtn.layer.shadowOffset = CGSizeMake(2,2);
    //addBtn.layer.borderWidth = 3.0f;
    //addBtn.layer.borderColor = sharedManager.mainThemeColor.CGColor;
    
    showFilter = YES;
    
    [self loadList];
}

- (void)handleRefresh : (id)sender
{
    //NSLog (@"Pull To Refresh Method Called");
    [self loadList];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* url;
    NSDictionary *parameters;
    if ([sharedManager.filterMode isEqualToString:@"nearby"]) {
        NSLog(@"AAAA %@ %@",sharedManager.latitude,sharedManager.longitude);
        url = [NSString stringWithFormat:@"%@searchNearMe",HOST_DOMAIN];
        parameters = @{@"lat":sharedManager.latitude,
                       @"lng":sharedManager.longitude
                       };
    }
    else{
        url = [NSString stringWithFormat:@"%@offerList",HOST_DOMAIN];
        parameters = @{};
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         
         listJSON = [[responseObject objectForKey:@"data"] mutableCopy];
         
         [mycollectionView reloadData];
         
         [refreshController endRefreshing];
         [SVProgressHUD dismiss];
         
         sharedManager.reloadOffer = NO;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    ResultHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                UICollectionElementKindSectionHeader withReuseIdentifier:@"ResultHeader" forIndexPath:indexPath];
    //headerView.resultTitle.text = @"Popular Tracks";
    [headerView.fiterBtn addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
    headerView.fiterBtn.tag = indexPath.row;
    [headerView.arrowBtn addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
    headerView.arrowBtn.tag = indexPath.row;
    
    if ([sharedManager.filterMode isEqualToString:@"nearby"]) {
        [headerView.fiterBtn setTitle:@"  ระยะทาง" forState:UIControlStateNormal];
    }
    else {
        [headerView.fiterBtn setTitle:@"  วันเดินทาง" forState:UIControlStateNormal];
    }
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (showFilter) {
        return CGSizeMake(collectionView.frame.size.width,25);
    }else {
        return CGSizeZero;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [listJSON count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (mycollectionView.frame.size.width)*0.936;
    float height = width*0.542;
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
    ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    [cell.userPic sd_setImageWithURL:[NSURL URLWithString:[cellArray objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    
    cell.userPic.layer.cornerRadius = cell.userPic.frame.size.width/2;
    cell.userPic.layer.masksToBounds = YES;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@\n%@",[cellArray objectForKey:@"forename"],[cellArray objectForKey:@"surname"]];
    
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
    
    cell.startLabel.text = [cellArray objectForKey:@"From"];
    cell.endLabel.text = [cellArray objectForKey:@"To"];
    cell.priceLabel.text = [cellArray objectForKey:@"price"];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ เวลา %@:%@ น.",[cellArray objectForKey:@"goDate"],[cellArray objectForKey:@"goH"],[cellArray objectForKey:@"goM"]];
    cell.seatLabel.text = [NSString stringWithFormat:@"เหลือ %@ ที่นั่ง",[cellArray objectForKey:@"now_seat"]];
    
    cell.reviewCount.text = [NSString stringWithFormat:@"(%@ รีวิว)",[[[cellArray objectForKey:@"rate"]objectAtIndex:0] objectForKey:@"total_review"]];
    
    int star = [[[[cellArray objectForKey:@"rate"] objectAtIndex:0] objectForKey:@"rate"] intValue];
    
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
    
    /*
    cell.nameLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:15];
    [self shorttext:cell.nameLabel];
    cell.reviewCount.font = [UIFont fontWithName:sharedManager.fontRegular size:11];
    [self shorttext:cell.reviewCount];
    
    cell.carTypeLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:25];
    [self shorttext:cell.carTypeLabel];
    cell.startLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:15];
    [self shorttext:cell.startLabel];
    cell.endLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:15];
    [self shorttext:cell.endLabel];
    
    
    cell.priceLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:35];
    [self shorttext:cell.priceLabel];
    cell.bahtLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:15];
    [self shorttext:cell.bahtLabel];
    cell.dateLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:13];
    [self shorttext:cell.dateLabel];
    //cell.nearLabel.font = [UIFont fontWithName:@"Kanit-Light" size:sharedManager.fontSize-3];
    //[self shorttext:cell.nearLabel];
    //cell.percentLabel.font = [UIFont fontWithName:@"Kanit-SemiBold" size:sharedManager.fontSize-2];
    //[self shorttext:cell.percentLabel];
    cell.seatLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:13];
    [self shorttext:cell.seatLabel];
     */
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OfferDetail *ofd = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferDetail"];
    ofd.offerID = [[listJSON objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:ofd animated:YES];
    //[self.menuContainerViewController.centerViewController pushViewController:ofd animated:YES];
    //NSLog(@"Click %d",indexPath.row);
}

- (void)moreClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self collectionView:mycollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:1]];
}

- (IBAction)searchClick:(id)sender
{
    Search *sch = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    [self.navigationController pushViewController:sch animated:YES];
}

- (IBAction)filterClick:(id)sender
{
    /*
     if(searchResult == YES)
     {
     searchResult = NO;
     }
     else
     {
     searchResult = YES;
     }
     [mycollectionView reloadData];
     */
    
    //UIButton *button = (UIButton *)sender;
    //NSLog(@"Action %ld",button.tag);
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight = self.view.frame.size.width*0.1;
    configuration.menuWidth = self.view.frame.size.width*0.25;
    configuration.textColor = [UIColor darkGrayColor];
    configuration.textFont = [UIFont fontWithName:sharedManager.fontRegular size:13];
    configuration.tintColor = [UIColor whiteColor];
    configuration.borderColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
    /*
     configuration.borderWidth = 1;
     configuration.shadowOffsetX = 2;
     configuration.shadowOpacity = 2;
     configuration.shadowColor = [UIColor darkGrayColor];
     configuration.shadowRadius = 2;
     configuration.shadowOpacity = 0.6;
     */
    //configuration.textAlignment = ...
    //configuration.ignoreImageOriginalColor = ...;// set 'ignoreImageOriginalColor' to YES, images color will be same as textColor
    ///configuration.allowRoundedArrow = ...;// Default is 'NO', if sets to 'YES', the arrow will be drawn with round corner.
    [FTPopOverMenu showForSender:sender withMenuArray:@[@"  ระยะทาง",@"  วันเดินทาง"]  doneBlock:^(NSInteger selectedIndex) {
        if (selectedIndex == 0) {
            sharedManager.filterMode = @"nearby";
            [self checkLocationPermission];
        }
        else if (selectedIndex == 1) {
            sharedManager.filterMode = @"date";
            [self loadList];
        }
    } dismissBlock:^{
        NSLog(@"Close");
    }];
}

- (void)checkLocationPermission
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Services ไม่ได้รับอนุญาต" message:@"คุณสามารถอนุญาติให้ Pamba Shareways เข้าถึง Location ของคุณได้ด้วยการปรับค่าที่ Settings > Privacy > Location Services" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                    }];
    [alertController addAction:settingAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    if(![CLLocationManager locationServicesEnabled]){
        //ปิด Location Service
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        //ปิด Location Service เฉพาะแอพ
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        //เปิด Location Service
        
        CLLocationCoordinate2D coordinate = [self getLocation];
        sharedManager.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        sharedManager.longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        //sharedManager.latitude = @"13.8699978";
        //sharedManager.longitude = @"100.4672951";
        
        //NSLog(@"X = %@\nY = %@",sharedManager.latitude,sharedManager.longitude);
        
        [self loadList];
    }
}

- (CLLocationCoordinate2D) getLocation{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    [locationManager stopUpdatingLocation];
    return coordinate;
}

- (IBAction)addOffer:(id)sender
{
    //OfferForm *of = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferForm"];
    //[self.navigationController pushViewController:of animated:YES];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue isKindOfClass:[CCMPopupSegue class]]){
        CCMPopupSegue *popupSegue = (CCMPopupSegue *)segue;
        
        if([segue.identifier isEqualToString:@"createPopUp"])
        {
            popupSegue.destinationBounds = CGRectMake(0, 0, self.view.frame.size.width*0.8, self.view.frame.size.width*0.45);
            
            popupSegue.backgroundViewAlpha = 0.7;
            popupSegue.backgroundViewColor = [UIColor blackColor];
            popupSegue.dismissableByTouchingBackground = YES;
        }
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
