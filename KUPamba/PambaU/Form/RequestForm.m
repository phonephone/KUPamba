//
//  RequestForm.m
//  Pamba
//
//  Created by Firststep Consulting on 7/14/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "RequestForm.h"
#import <CCMPopup/CCMPopupSegue.h>
#import "ProfileOffer.h"


@interface RequestForm () <GMSAutocompleteViewControllerDelegate>

@end

@implementation RequestForm
{
    GMSPlacesClient *_placesClient;
    GMSAutocompleteResultsViewController *_resultsViewController;
}

@synthesize headerView,headerTitle,headerLBtn,fromField,toField,targetBtn,swapBtn,nextBtn,dateLabel,timeLabel,dateField,timeField,remarkTitle,remarkText;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    if (sharedManager.clearRequest == YES) {
        [self clearValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    //[[UINavigationBar appearance] setBarTintColor:sharedManager.mainThemeColor];
    
    _placesClient = [GMSPlacesClient sharedClient];
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [swapBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    swapBtn.imageView.image = [swapBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [swapBtn.imageView setTintColor:sharedManager.mainThemeColor];
    
    nextBtn.backgroundColor = sharedManager.btnThemeColor;
    nextBtn.titleLabel.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    
    [self addbottomBorder:fromField withColor:sharedManager.btnThemeColor];
    [self addbottomBorder:toField withColor:nil];
    [self addbottomBorder:dateField withColor:nil];
    [self addbottomBorder:timeField withColor:nil];
    
    [self clearValue];
}

-(void)clearValue
{
    fromField.text = @"";              fromID = @"";
    toField.text = @"";                toID = @"";
    
    distance = @"";
    duration = @"";
    goDate = @"";
    goDateEN = @"";
    goH = @"";
    goM = @"";
    remark = @"";
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    //[locationManager requestAlwaysAuthorization];
    
    localeTH = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:localeTH];
    
    dayPicker = [[UIDatePicker alloc]init];
    [dayPicker setDatePickerMode:UIDatePickerModeDate];
    [dayPicker setMinimumDate: [NSDate date]];
    [dayPicker setLocale:localeTH];
    dayPicker.calendar = [localeTH objectForKey:NSLocaleCalendar];
    dayPicker.tag = 1;
    [dayPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    timePicker = [[UIDatePicker alloc]init];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker setLocale:localeTH];
    timePicker.tag = 2;
    [timePicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    dateField.inputView = dayPicker;
    [df setDateFormat:@"dd MMM yyyy"];
    dateField.text = [df stringFromDate:[NSDate date]];
    
    timeField.inputView = timePicker;
    [df setDateFormat:@"HH : mm"];
    timeField.text = [df stringFromDate:[NSDate date]];
    
    remarkText.delegate = self;
    
    [df setDateFormat:@"yyyy-MM-dd"];
    goDate = [df stringFromDate:[NSDate date]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    goH = [NSString stringWithFormat:@"%ld",(long)[components hour]];
    goM = [NSString stringWithFormat:@"%ld",(long)[components minute]];
    
    sharedManager.clearRequest = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101||textField.tag == 102) {
        nowEdit = textField.tag;
        
        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.delegate = self;
        acController.tableCellBackgroundColor = [UIColor whiteColor];
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        //filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
        filter.country = @"TH";
        acController.autocompleteFilter = filter;
        [self presentViewController:acController animated:YES completion:nil];
    }
}

- (BOOL)textFieldDidChange:(UITextField *)textField
{
    //NSLog(@"Change %@", textField.text);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
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

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    
    NSLog(@"Place ID %@", place.placeID);
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    if (nowEdit == 101) {
        fromField.text = place.name;
        fromID = place.placeID;
    }
    if (nowEdit == 102) {
        toField.text = place.name;
        toID = place.placeID;
    }
    
    if (![toField.text isEqualToString:@""] && ![fromField.text isEqualToString:@""]) {
        [self getDistance];
    }
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

- (void)getDistance
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@RequestDirection",HOST_DOMAIN];
    NSDictionary *parameters = @{@"ori":fromID,
                                 @"des":toID
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"distance %@",responseObject);
         distance = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"allKm"];
         distance = [NSString stringWithFormat:@"%.1f กม.",[distance floatValue]];
         
         [SVProgressHUD dismiss];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
     }];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
            case 1://Date
            [df setDateFormat:@"dd MMM yyyy"];
            dateField.text = [df stringFromDate:datePicker.date];
            
            [df setDateFormat:@"yyyy-MM-dd"];
            goDate = [df stringFromDate:datePicker.date];
            break;
            
        case 2://Time
            [df setDateFormat:@"HH : mm"];
            timeField.text = [df stringFromDate:datePicker.date];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:datePicker.date];
            goH = [NSString stringWithFormat:@"%ld",(long)[components hour]];
            goM = [NSString stringWithFormat:@"%ld",(long)[components minute]];
            break;
    }
}

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height+1, textField.frame.size.width*1.1, 1.0f);
    
    if (color == nil) {
        bottomBorder.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    }
    else{
        bottomBorder.backgroundColor = color.CGColor;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, targetBtn.frame.size.width, 20)];
        textField.rightView = paddingView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [textField.layer addSublayer:bottomBorder];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    //textField.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize+2];
    
    return textField;
}

- (IBAction)locationClick:(id)sender
{
    //UIButton *button = (UIButton *)sender;
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ไม่สามารถใช้งานได้" message:@"เนื่องจากคุณไม่อนุญาติให้แอพ Pamba เข้าถึงตำแหน่งปัจจุบันของคุณ" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
            [SVProgressHUD dismiss];
            return;
        }
        fromField.text = @"ไม่พบชื่อสถานที่ปัจจุบัน";
        //toField.text = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                fromID = place.placeID;
                fromField.text = place.name;
                //toField.text = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
                [SVProgressHUD dismiss];
            }
        }
    }];
}

- (IBAction)swapClick:(id)sender
{
    //UIButton *button = (UIButton *)sender;
    NSString *fromText = fromField.text;
    NSString *toText = toField.text;
    NSString *beforeFromID = fromID;
    NSString *beforeToID = toID;
    
    fromField.text = toText;
    toField.text = fromText;
    fromID = beforeToID;
    toID = beforeFromID;
    if (![fromField.text isEqualToString:@""]||![toField.text isEqualToString:@""]) {
        [self getDistance];
    }
}

- (IBAction)createClick:(id)sender
{
    if ([fromField.text isEqualToString:@""]||[toField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยังไม่ได้กำหนดจุดเริ่มต้นหรือปลายทาง" message:@"กรุณากำหนดจุดเริ่มต้นและปลายทางให้เรียบร้อย" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        if ([remarkText.text isEqualToString:sharedManager.detailPlaceholder]) {
            remark = @"";
        }
        else
        {
            remark = remarkText.text;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการขอร่วมทาง" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self loadWebView];
        }];
        [alertController addAction:ok];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        }];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)loadWebView
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setLocale:localeTH];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *ceYear = [df1 dateFromString:goDate];
    
    localeEN = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:localeEN];
    [df2 setDateFormat:@"yyyy-MM-dd"];
    goDateEN = [df2 stringFromDate:ceYear];
    
    //NSLog(@"userID:%@\n From:%@\n To:%@\n distance:%@\n duration:%@\n origin:%@\n destination:%@\n goDate:%@\n goH:%@\n goM:%@\n remark:%@",sharedManager.memberID,fromField.text,toField.text,distance,duration,fromID,toID,goDateEN,goH,goM,remark);
    
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
        [self finishRequest];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"!DidFailLoadWithError: %@", [error description]);
    //self.view.alpha = 1.f;
    [SVProgressHUD dismiss];
    
    [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
}

- (void)finishRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@createRequest",HOST_DOMAIN];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID,
                                 @"From":fromField.text,
                                 @"To":toField.text,
                                 @"distance":distance,
                                 @"duration":duration,
                                 @"start_address":@"",
                                 @"end_address":@"",
                                 @"origin":fromID,
                                 @"destination":toID,
                                 @"goDate":goDateEN,
                                 @"goH":goH,
                                 @"goM":goM,
                                 @"remark":remark
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Request %@",responseObject);
         
         [SVProgressHUD showSuccessWithStatus:@"หาเพื่อนร่วมทางถูกบันทึกแล้ว"];
         [SVProgressHUD dismissWithDelay:3];
         
         sharedManager.reloadRequest = YES;
         sharedManager.clearRequest = YES;
         [self.navigationController popViewControllerAnimated:YES];
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
