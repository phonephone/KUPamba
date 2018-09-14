//
//  RightMenu.m
//  Samplink
//
//  Created by Firststep Consulting on 6/13/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "RightMenu.h"
#import "MenuCell.h"
#import "Profile.h"
#import "ProfileOffer.h"
#import "ChatList.h"
#import "UIImageView+WebCache.h"

@interface RightMenu ()
{
    
}
@end

@implementation RightMenu

@synthesize bgView,myTable;

- (void)viewWillLayoutSubviews
{
    [myTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    sharedManager.mainRoot = (MFSideMenuContainerViewController *)self.parentViewController;
    homePage = [sharedManager.mainRoot.childViewControllers objectAtIndex:1];
    
    NSLog(@"Right %@",[sharedManager.mainRoot.childViewControllers objectAtIndex:1]);
    
    bgView.backgroundColor = sharedManager.mainThemeColor;
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    [self loadProfile];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)loadProfile
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@viewProfile",HOST_DOMAIN];
    NSDictionary *parameters = @{@"uid":sharedManager.memberID,
                                 @"me":@"1",
                                 @"token":sharedManager.memberToken
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"profileJSON %@",responseObject);
         sharedManager.profileJSON = [[[responseObject objectForKey:@"data"] objectAtIndex:0] mutableCopy];
         
         [self setAlert];
         
         [myTable reloadData];
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

- (void)setAlert
{
    if (sharedManager.homeExisted == YES) {
        
        if ([[sharedManager.profileJSON objectForKey:@"notification_All"] intValue] == 0) {
            homePage.rightAlert.hidden = YES;
        }
        else{
            homePage.rightAlert.hidden = NO;
        }
        
        alertOffer = [[sharedManager.profileJSON objectForKey:@"notification_offer"] intValue];
        alertReserve = [[sharedManager.profileJSON objectForKey:@"notification_reserv"] intValue];
        alertChat = [[sharedManager.profileJSON objectForKey:@"notification_chat"] intValue];
        
        [myTable reloadData];
        
        //[UIApplication sharedApplication].applicationIconBadgeNumber = [[sharedManager.profileJSON objectForKey:@"notification_All"] intValue]; //อย่าลืมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมม
    }
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section== 1) return YES;
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            if (section == 1) {//Offer & Reserve
                return 2+1;
            }
        }
        return 1; // only top row showing
    }
    // Return the number of rows in other section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    int factor = 13;
    if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
    {
        if (!indexPath.row)//Main
        {
            rowHeight = (self.view.frame.size.height/factor);
        }
        else//Sub
        {
            rowHeight = (self.view.frame.size.height/(factor+1));
        }
    }
    else//Can't Expand
    {
        rowHeight = (self.view.frame.size.height/factor);
    }
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.menuAlert.hidden = YES;
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
    {
        if (indexPath.section == 1) {
            
            cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:206.0/255 blue:206.0/255 alpha:1];
            if (indexPath.row == 0) {
                cell.menuLabel.text = @"ข้อมูลการเดินทาง";
                bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
                [cell setSelectedBackgroundView:bgColorView];
                
                if (alertOffer+alertReserve > 0) { cell.menuAlert.hidden = NO; }
                else{ cell.menuAlert.hidden = YES; }
            }
            else if (indexPath.row == 1) {
                cell.menuLabel.text = @"     การเสนอที่นั่งของคุณ";
                
                if (alertOffer > 0) { cell.menuAlert.hidden = NO; }
                else{ cell.menuAlert.hidden = YES; }
            }
            else if (indexPath.row == 2) {
                cell.menuLabel.text = @"     การขอร่วมทางของคุณ";
                
                if (alertReserve > 0) { cell.menuAlert.hidden = NO; }
                else{ cell.menuAlert.hidden = YES; }
            }
        }
        
        cell.menuArrow.hidden = NO;
        
        if (!indexPath.row)//Main
        {
            if ([expandedSections containsIndex:indexPath.section])//Now Expanded
            {
                cell.menuArrow.transform = CGAffineTransformIdentity;
            }
            else//Not Expanded
            {
                //float degrees = 180; //the value in degrees
                //cell.menuArrow.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
            }
        }
        else//Sub
        {
            cell.menuArrow.hidden = YES;
        }
    }
    else//Can't Expand
    {
        if (indexPath.section == 0) {
            cell.menuLabel.text = @"บัญชีผู้ใช้";
        }
        
        else if (indexPath.section == 2) {
            cell.menuLabel.text = @"กล่องข้อความ";
            
            if (alertChat > 0) { cell.menuAlert.hidden = NO; }
            else{ cell.menuAlert.hidden = YES; }
        }
        else if (indexPath.section == 3) {
            cell.menuLabel.text = @"สร้าง QR PromptPay เพื่อรับชำระเงิน";
        }
        else if (indexPath.section == 4) {
            cell.menuLabel.text = @"ออกจากระบบ";
        }
        cell.menuArrow.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)//Main Menu Click
        {
            // only first row toggles exapand/collapse
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
                MenuCell *cell = [myTable cellForRowAtIndexPath:indexPath];
                cell.menuArrow.transform = CGAffineTransformIdentity;
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
                
                float degrees = 90; //the value in degrees
                MenuCell *cell = [myTable cellForRowAtIndexPath:indexPath];
                cell.menuArrow.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
            }
            
            //Table row management
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
               [myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:section]-1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        else//Sub Menu Click
        {
            if (indexPath.section == 1) {
                
                if (indexPath.row == 1) {//การเสนอที่นั่งของคุณ
                    ProfileOffer *pfo = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileOffer"];
                    pfo.mode = @"Offer";
                    [self.navigationController pushViewController:pfo animated:YES];
                }
                else if (indexPath.row == 2) {//การสำรองที่นั่งของคุณ
                    ProfileOffer *pfo = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileOffer"];
                    pfo.mode = @"Reserve";
                    [self.navigationController pushViewController:pfo animated:YES];
                }
            }
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
        }
    }
    
    else // can't collapse
    {
        if (indexPath.section == 0) {//Profile
            Profile *pf = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile"];
            [self.navigationController pushViewController:pf animated:YES];
        }
        
        else if (indexPath.section == 2) {//กล่องข้อความ
            ChatList *cl = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatList"];
            [self.navigationController pushViewController:cl animated:YES];
        }
        else if (indexPath.section == 3) {//QR
            
        }
        else if (indexPath.section == 4) {//ออกจากระบบ
            
            [self clearToken];
            
            sharedManager.homeExisted = NO;
            sharedManager.loginStatus = NO;
            sharedManager.memberID = @"";
            sharedManager.memberToken = @"";
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setBool:sharedManager.loginStatus forKey:@"loginStatus"];
            [ud setObject:sharedManager.memberID forKey:@"memberID"];
            [ud synchronize];
            
            NSMutableArray *newStack = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            [newStack removeLastObject];
            //[newStack removeLastObject];//อย่าลืมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมม
            [self.navigationController setViewControllers:newStack animated:YES];
        }
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
    }
}

- (void)clearToken
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@logout",HOST_DOMAIN];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"logoutJSON %@",responseObject);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
     }];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
