//
//  Review.m
//  PambaU
//
//  Created by Firststep Consulting on 21/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Review.h"
#import "ReviewCell.h"
#import "UIImageView+WebCache.h"

@interface Review ()

@end

@implementation Review

@synthesize mode,reViewID,headerView,headerTitle,headerLBtn,myTable;

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [myTable reloadData];
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
    if ([mode isEqualToString:@"Offer"]) {
        headerTitle.text = @"ให้คะแนนผู้โดยสาร";
    }
    
    if ([mode isEqualToString:@"Reserve"]) {
        headerTitle.text = @"ให้คะแนนผู้ขับ";
    }
    headerTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    NSString* url;
    if ([mode isEqualToString:@"Offer"]) {
        url = [NSString stringWithFormat:@"%@OfferReview",HOST_DOMAIN];
    }
    
    if ([mode isEqualToString:@"Reserve"]) {
        url = [NSString stringWithFormat:@"%@RequestReview",HOST_DOMAIN];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"oid":reViewID,
                                 @"user_id":sharedManager.memberID};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"reviewJSON %@",responseObject);
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
    return [listJSON count];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewCell *cell = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    [cell.reviewUserPic sd_setImageWithURL:[NSURL URLWithString:[cellArray objectForKey:@"userPic"]] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    cell.reviewUserPic.layer.cornerRadius = (myTable.frame.size.width*0.16)/2;
    cell.reviewUserPic.layer.masksToBounds = YES;
    
    cell.reviewNameLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    cell.reviewNameLabel.text = [NSString stringWithFormat:@"%@ %@",[cellArray objectForKey:@"forename"],[cellArray objectForKey:@"surname"]];
    
    
    int star = [[cellArray objectForKey:@"rate"] intValue];
    //[self setStarAtIndexRow:indexPath.row score:star];
    
    if ([[cellArray objectForKey:@"status"]isEqualToString:@"0"]) {
        UIImage *starON = [UIImage imageNamed:@"cell_star"];
        UIImage *starOFF = [UIImage imageNamed:@"cell_star_off"];
        
        [cell.reviewStar1 setImage:starOFF forState:UIControlStateNormal];
        [cell.reviewStar2 setImage:starOFF forState:UIControlStateNormal];
        [cell.reviewStar3 setImage:starOFF forState:UIControlStateNormal];
        [cell.reviewStar4 setImage:starOFF forState:UIControlStateNormal];
        [cell.reviewStar5 setImage:starOFF forState:UIControlStateNormal];
        
        switch (star) {
            case 1:
                [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
                break;
            case 2:
                [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar2 setImage:starON forState:UIControlStateNormal];
                break;
            case 3:
                [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar2 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar3 setImage:starON forState:UIControlStateNormal];
                break;
            case 4:
                [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar2 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar3 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar4 setImage:starON forState:UIControlStateNormal];
                break;
            case 5:
                [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar2 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar3 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar4 setImage:starON forState:UIControlStateNormal];
                [cell.reviewStar5 setImage:starON forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }

    cell.reviewStar1.tag = indexPath.row;
    cell.reviewStar2.tag = indexPath.row;
    cell.reviewStar3.tag = indexPath.row;
    cell.reviewStar4.tag = indexPath.row;
    cell.reviewStar5.tag = indexPath.row;
    
    [cell.reviewStar1 addTarget:self action:@selector(star1Click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reviewStar2 addTarget:self action:@selector(star2Click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reviewStar3 addTarget:self action:@selector(star3Click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reviewStar4 addTarget:self action:@selector(star4Click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reviewStar5 addTarget:self action:@selector(star5Click:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)star1Click:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Star %ld",(long)button.tag);
    [self setStarAtIndexRow:button.tag score:1];
    [self submitReviewIndexRow:button.tag score:1];
}

- (void)star2Click:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Star %ld",(long)button.tag);
    [self setStarAtIndexRow:button.tag score:2];
    [self submitReviewIndexRow:button.tag score:2];
}

- (void)star3Click:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Star %ld",(long)button.tag);
    [self setStarAtIndexRow:button.tag score:3];
    [self submitReviewIndexRow:button.tag score:3];
}

- (void)star4Click:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Star %ld",(long)button.tag);
    [self setStarAtIndexRow:button.tag score:4];
    [self submitReviewIndexRow:button.tag score:4];
}

- (void)star5Click:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Star %ld",(long)button.tag);
    [self setStarAtIndexRow:button.tag score:5];
    [self submitReviewIndexRow:button.tag score:5];
}

- (void)setStarAtIndexRow:(long)row score:(int)star
{
    //NSLog(@"index %ld score %d",row,star);
    
    UIImage *starON = [UIImage imageNamed:@"cell_star"];
    UIImage *starOFF = [UIImage imageNamed:@"cell_star_off"];
    
    ReviewCell *cell = (ReviewCell *)[myTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell.reviewStar1 setImage:starOFF forState:UIControlStateNormal];
    [cell.reviewStar2 setImage:starOFF forState:UIControlStateNormal];
    [cell.reviewStar3 setImage:starOFF forState:UIControlStateNormal];
    [cell.reviewStar4 setImage:starOFF forState:UIControlStateNormal];
    [cell.reviewStar5 setImage:starOFF forState:UIControlStateNormal];
    
    switch (star) {
        case 1:
            [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
            break;
        case 2:
            [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar2 setImage:starON forState:UIControlStateNormal];
            break;
        case 3:
            [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar2 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar3 setImage:starON forState:UIControlStateNormal];
            break;
        case 4:
            [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar2 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar3 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar4 setImage:starON forState:UIControlStateNormal];
            break;
        case 5:
            [cell.reviewStar1 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar2 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar3 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar4 setImage:starON forState:UIControlStateNormal];
            [cell.reviewStar5 setImage:starON forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)submitReviewIndexRow:(long)row score:(int)star
{
    NSDictionary *cellArray = [listJSON objectAtIndex:row];
    
    NSString* url = [NSString stringWithFormat:@"%@updateReview",HOST_DOMAIN];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"oid":reViewID,
                                 @"user_id":sharedManager.memberID,
                                 @"user_id_review":[cellArray objectForKey:@"user_id_review"],
                                 @"rate":[NSString stringWithFormat:@"%d",star]
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"Response %@",responseObject);
         [SVProgressHUD dismiss];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
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
