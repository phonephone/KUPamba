//
//  OfferForm2.m
//  Pamba
//
//  Created by Firststep Consulting on 7/13/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "OfferForm2.h"
#import "MainCell.h"
#import "ProfileOffer.h"

@interface OfferForm2 () <GMSAutocompleteViewControllerDelegate>

@end

@implementation OfferForm2
{
    GMSAutocompleteResultsViewController *_resultsViewController;
}

@synthesize fromID,fromName,toID,toName,distance,duration,goDate,goH,goM,exTime,seats,gender,luggage,option,price,remark,waypoint,carType;

@synthesize headerView,headerTitle,headerLBtn,myTable,tableViewHeight,checkTitle,checkBox1,checkBox2,checkBox3,checkBox4,checkLabel1,checkLabel2,checkLabel3,checkLabel4,remarkTitle,remarkText,pickTitle,waypointBtn,createBtn,infoLabel;

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
    
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    [df setLocale:locale];
    NSDate *ceYear = [df dateFromString:goDate];
    
    locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:locale];
    goDate = [df stringFromDate:ceYear];
    
    //NSLog(@"userID:%@\n From:%@\n FromID:%@\n To:%@\n ToID:%@\n distance:%@\n duration:%@\n goDate:%@\n goH:%@\n goM:%@\n exTime:%@\n seats:%@\n gender:%@\n luggage:%@\n price:%@",sharedManager.memberID,fromName,fromID,toName,toID,distance,duration,goDate,goH,goM,exTime,seats,gender,luggage,price);
    
    smoke = YES;
    food = YES;
    pet = YES;
    music = NO;
    
    [checkBox1.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [checkBox2.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [checkBox3.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [checkBox4.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    checkTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    checkLabel1.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    checkLabel2.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    checkLabel3.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    checkLabel4.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    remarkTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    remarkText.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    remarkText.delegate = self;
    //remarkText.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize+2];
    //remarkText.layer.borderWidth = 1.0f;
    //remarkText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //remarkText.textContainer.maximumNumberOfLines = 5;
    //remarkText.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    pickTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    waypointBtn.backgroundColor = sharedManager.mainThemeColor;
    [waypointBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    waypointBtn.titleLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize13 weight:UIFontWeightMedium];
    
    createBtn.backgroundColor = sharedManager.btnThemeColor;
    createBtn.titleLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    
    infoLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize13 weight:UIFontWeightMedium];
    
    pickupArray = [[NSMutableArray alloc] init];
    myTable.editing = YES;
    
    option = @"smoking-food--pet";
    smokeString = @"smoking";
    foodString = @"food";
    musicString = @"";
    petString = @"pet";
    remark = @"";
    waypoint = @"";
}

- (IBAction)checkClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 101) {//Smoke
        if (smoke == YES) {
            smoke = NO;
            smokeString = @"";
            [button setImage:[UIImage imageNamed:@"form_check_off"] forState:UIControlStateNormal];
        }
        else
        {
            smoke = YES;
            smokeString = @"smoking";
            [button setImage:[UIImage imageNamed:@"form_check_on"] forState:UIControlStateNormal];
        }
    }
    if (button.tag == 102) {//Food
        if (food == YES) {
            food = NO;
            foodString = @"";
            [button setImage:[UIImage imageNamed:@"form_check_off"] forState:UIControlStateNormal];
        }
        else
        {
            food = YES;
            foodString = @"food";
            [button setImage:[UIImage imageNamed:@"form_check_on"] forState:UIControlStateNormal];
        }
    }
    if (button.tag == 103) {//Pet
        if (pet == YES) {
            pet = NO;
            petString = @"";
            [button setImage:[UIImage imageNamed:@"form_check_off"] forState:UIControlStateNormal];
        }
        else
        {
            pet = YES;
            petString = @"pet";
            [button setImage:[UIImage imageNamed:@"form_check_on"] forState:UIControlStateNormal];
        }
    }
    if (button.tag == 104) {//Music
        if (music == YES) {
            music = NO;
            musicString = @"";
            [button setImage:[UIImage imageNamed:@"form_check_off"] forState:UIControlStateNormal];
        }
        else
        {
            music = YES;
            musicString =@"music";
            [button setImage:[UIImage imageNamed:@"form_check_on"] forState:UIControlStateNormal];
        }
    }
    option = [NSString stringWithFormat:@"%@-%@-%@-%@",smokeString,foodString,musicString,petString];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:sharedManager.detailPlaceholder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}
/*
- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger maxNumberOfLines = 5;
    NSUInteger numLines = textView.contentSize.height/textView.font.lineHeight;
    if (numLines > maxNumberOfLines)
    {
        textView.text = [textView.text substringToIndex:textView.text.length - 1];
    }
}
*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger maxNumberOfLines = 5;
    NSUInteger numLines = textView.contentSize.height/textView.font.lineHeight;
    if (numLines >= maxNumberOfLines)
    {
        if([text isEqualToString:@"\n"]) {
            //[textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = sharedManager.detailPlaceholder;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pickupArray count];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width*0.08;//UITableViewAutomaticDimension;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    MainCell *cell = (MainCell *)[tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    cell.nameLabel.text = [[pickupArray objectAtIndex:indexPath.row] objectForKey:@"placeName"];
    cell.nameLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    [cell.detailBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.detailBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.detailBtn.tag = indexPath.row;
    
    return cell;
}
    
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(UIView* view in cell.subviews)
    {
        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"])
        {
            // Creates a new subview the size of the entire cell
            UIView *movedReorderControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
            // Adds the reorder control view to our new subview
            [movedReorderControl addSubview:view];
            // Adds our new subview to the cell
            [cell addSubview:movedReorderControl];
            // CGStuff to move it to the left
            CGSize moveLeft = CGSizeMake(movedReorderControl.frame.size.width - view.frame.size.width, movedReorderControl.frame.size.height - view.frame.size.height);
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, -moveLeft.width, -moveLeft.height);
            // Performs the transform
            [movedReorderControl setTransform:transform];
        }
    }
}
    
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [pickupArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //tableViewHeight.constant = myTable.contentSize.height;
            //[self.view updateConstraints];
        });
        NSLog(@"Delete %@",pickupArray);
    }
}
    
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id objectToMove = [pickupArray objectAtIndex:fromIndexPath.row];
    [pickupArray removeObjectAtIndex:fromIndexPath.row];
    [pickupArray insertObject:objectToMove atIndex:toIndexPath.row];
    [tableView reloadData];
    NSLog(@"Reorder %@",pickupArray);
}

- (void)deleteClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [pickupArray removeObjectAtIndex:button.tag];
    [myTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [myTable reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        //tableViewHeight.constant = myTable.contentSize.height;
        //[self.view updateConstraints];
    });
    NSLog(@"Delete %@",pickupArray);
}

- (IBAction)waypointClick:(id)sender
{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    acController.tableCellBackgroundColor = [UIColor whiteColor];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    //filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    filter.country = @"TH";
    acController.autocompleteFilter = filter;
    [self presentViewController:acController animated:YES completion:nil];
    
    /*
    NSString *test = [NSString stringWithFormat:@"test %lu",(unsigned long)[pickupArray count]];
    [pickupArray addObject:test];
    [myTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[pickupArray count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [myTable reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        //tableViewHeight.constant = myTable.contentSize.height;
        //[self.view updateConstraints];
    });
    
    NSLog(@"Add %@",pickupArray);
    */
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place ID %@", place.placeID);
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json"];
    NSDictionary *parameters = @{@"placeid":place.placeID,
                                 @"key":sharedManager.GoogleAPIKey
                                 };
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"latlongJSON %@",responseObject);
         
         NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
         [mutableDict setObject:place.placeID forKey:@"placeID"];
         [mutableDict setObject:place.name forKey:@"placeName"];
         [mutableDict setObject:place.formattedAddress forKey:@"placeAddress"];
         if (place.attributions.string) {
             [mutableDict setObject:place.attributions.string forKey:@"placeAttribution"];
         }
         NSDictionary *latlongDict = [[[responseObject objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"];
         [mutableDict setObject:[latlongDict objectForKey:@"lat"] forKey:@"placeLat"];
         [mutableDict setObject:[latlongDict objectForKey:@"lng"] forKey:@"placeLng"];
         
         [pickupArray addObject:mutableDict];
         [myTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[pickupArray count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
         [myTable reloadData];
         dispatch_async(dispatch_get_main_queue(), ^{
             //tableViewHeight.constant = myTable.contentSize.height;
             //[self.view updateConstraints];
         });
         
         NSLog(@"Add %@",pickupArray);
         
         [SVProgressHUD dismiss];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
     }];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)createClick:(id)sender
{
    if ([remarkText.text isEqualToString:sharedManager.detailPlaceholder]) {
        remark = @"";
    }
    else
    {
        remark = remarkText.text;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการเสนอที่นั่ง" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self loadWebView];
    }];
    [alertController addAction:ok];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadWebView
{
    waypoint = @"";
    NSString *seperator;
    for (int i=0; i < [pickupArray count]; i++) {
        NSMutableDictionary *waypointDict = [pickupArray objectAtIndex:i];
        
        if ([pickupArray count]-1 == i) {
            seperator = @"";
        }
        else{
            seperator = @"|";
        }
        
        waypoint = [NSString stringWithFormat:@"%@%@,%@,%@%@",waypoint,[waypointDict objectForKey:@"placeName"],[waypointDict objectForKey:@"placeLat"],[waypointDict objectForKey:@"placeLng"],seperator];
    }
    
    NSLog(@"option:%@\n price:%@\n remark:%@\n way_point:%@",option,price,remark,waypoint);
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    UIWebView *myWebview = [[UIWebView alloc]init];
    NSString* strUrl = [NSString stringWithFormat:@"%@webApi/findLatLng?user=%@&ori=%@&des=%@",HOST_DOMAIN_INDEX,sharedManager.memberID,fromID,toID];
    NSURL *url = [NSURL URLWithString:strUrl];
    myWebview.delegate = self;
    requestURL = [[NSURLRequest alloc] initWithURL:url];
    [myWebview loadRequest:requestURL];
    [self.view addSubview:myWebview];
    myWebview.hidden = YES;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //NSLog(@"Did start loading: %@", [[request URL] absoluteString]);
    
    NSString *chkStr = [NSString stringWithFormat:@"%@ajax/echo_java.php",HOST_DOMAIN_HOME];
    
    if ([[[request URL] absoluteString] isEqualToString:chkStr]) {
        webLoaded = YES;
    }
    else{
        webLoaded = NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSLog(@"Web Finish Load");
    //self.view.alpha = 1.f;
    if (webLoaded == YES)
    {
        [self finishOffer];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"!DidFailLoadWithError: %@", [error description]);
    //self.view.alpha = 1.f;
    [SVProgressHUD dismiss];
    [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
}

- (void)finishOffer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@createOffer",HOST_DOMAIN];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID,
                                 @"From":fromName,
                                 @"To":toName,
                                 @"distance":distance,
                                 @"duration":duration,
                                 @"start_address":@"",
                                 @"end_address":@"",
                                 @"origin":fromID,
                                 @"destination":toID,
                                 @"goDate":goDate,
                                 @"goH":goH,
                                 @"goM":goM,
                                 @"exTime":exTime,
                                 @"seats":seats,
                                 @"gender":gender,
                                 @"luggage":luggage,
                                 @"option":option,
                                 @"price":price,
                                 @"remark":remark,
                                 @"way_point":waypoint,
                                 @"type":carType,
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"Offer %@",responseObject);
         
         [SVProgressHUD showSuccessWithStatus:@"การเสนอที่นั่งถูกบันทึกแล้ว"];
         [SVProgressHUD dismissWithDelay:3];
         
         sharedManager.reloadOffer = YES;
         sharedManager.clearOffer = YES;
         
         [self backToHome];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
     }];
    webLoaded = NO;
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToHome
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        //NSLog(@"Back %@",controller);
        if ([controller isKindOfClass:[MFSideMenuContainerViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
        }
    }
}
    
    /*Update Table View Hieght
     dispatch_async(dispatch_get_main_queue(), ^{
     //This code will run in the main thread:
     CGRect frame = myTable.frame;
     frame.size.height = myTable.contentSize.height;
     myTable.frame = frame;
     });
     */

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
