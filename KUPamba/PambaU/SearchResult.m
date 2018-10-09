//
//  SearchResult.m
//  PambaU
//
//  Created by Firststep Consulting on 21/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "SearchResult.h"
#import "OfferDetail.h"
#import "ListCell.h"
#import "ResultHeader.h"
#import "UIImageView+WebCache.h"

@interface SearchResult ()

@end

@implementation SearchResult

@synthesize listJSON,headerView,headerTitle,headerLBtn,mycollectionView;

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [mycollectionView.collectionViewLayout collectionViewContentSize];
    [mycollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [mycollectionView addSubview:refreshController];
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
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width,30);
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
     cell.reviewCount.font = [UIFont fontWithName:sharedManager.fontRegular size:11];
     cell.carTypeLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:25];
     cell.startLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:15];
     cell.endLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:15];
     
     cell.priceLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:35];
     cell.bahtLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:15];
     cell.dateLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:13];
     //cell.nearLabel.font = [UIFont fontWithName:@"Kanit-Light" size:sharedManager.fontSize-3];
     //cell.percentLabel.font = [UIFont fontWithName:@"Kanit-SemiBold" size:sharedManager.fontSize-2];
     cell.seatLabel.font = [UIFont fontWithName:sharedManager.fontRegular size:13];
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
