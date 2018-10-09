//
//  ChatList.m
//  Pamba
//
//  Created by Firststep Consulting on 8/25/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "ChatList.h"
#import "ChatCell.h"
#import "UIImageView+WebCache.h"
#import "Web.h"
#import "RightMenu.h"

@interface ChatList ()

@end

@implementation ChatList

@synthesize headerView,headerTitle,headerLBtn,myTable,noresultLabel;

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
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    noresultLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    noresultLabel.hidden = YES;
}

- (void)loadList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@get_message_all",HOST_DOMAIN];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID};
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
    int rowNo;
    
    if (listJSON.count == 0) {
        noresultLabel.hidden = NO;
        rowNo = 0;
    }
    else{
        noresultLabel.hidden = YES;
        rowNo = [listJSON count];
    }
    return rowNo;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = myTable.frame.size.height/7;
    
    return rowHeight;//UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = (ChatCell *)[tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    NSDictionary *cellArray = [listJSON objectAtIndex:indexPath.row];
    
    cell.chatAlert.hidden = YES;
    
    [cell.chatUserPic sd_setImageWithURL:[NSURL URLWithString:[cellArray objectForKey:@"userPic"]] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    cell.chatUserPic.layer.cornerRadius = (myTable.frame.size.width*0.16)/2;
    cell.chatUserPic.layer.masksToBounds = YES;
    
    cell.chatUserName.text = [cellArray objectForKey:@"name"];
    cell.chatUserName.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    
    cell.chatLastMessage.attributedText = [[NSAttributedString alloc] initWithData:[[cellArray objectForKey:@"checkLastMessage"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    cell.chatLastMessage.textColor = [UIColor colorWithRed:154.0/255 green:149.0/255 blue:152.0/255 alpha:1];
    cell.chatLastMessage.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    int chatAlert = [[cellArray objectForKey:@"notification_chat"] intValue];
    if (chatAlert > 0)
    {
        cell.chatAlert.hidden = NO;
    }
    else{
        cell.chatAlert.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Web *web = [self.storyboard instantiateViewControllerWithIdentifier:@"Web"];
    web.webTitle = @"กล่องข้อความ";
    web.urlString = [NSString stringWithFormat:@"%@ChatWV/message?userFrom=%@&userTo=%@",HOST_DOMAIN_INDEX,sharedManager.memberID,[[listJSON objectAtIndex:indexPath.row] objectForKey:@"user"]];
    [web setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)back:(id)sender
{
    RightMenu *rm = (RightMenu*)[sharedManager.mainRoot.childViewControllers objectAtIndex:0];
    [rm loadProfile];
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
