//
//  Search.m
//  Pamba
//
//  Created by Firststep Consulting on 7/18/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "Search.h"
#import "SearchResult.h"

@interface Search () <GMSAutocompleteViewControllerDelegate>

@end

@implementation Search
{
    GMSPlacesClient *_placesClient;
    GMSAutocompleteResultsViewController *_resultsViewController;
}

@synthesize headerView,headerTitle,headerLBtn,fromField,toField,targetBtn,swapBtn,nextBtn,dateLabel,dateField;

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
    
    //[fromField setAttributedText:[self shorttext:fromField.text withFont:nil]];
    //[toField setAttributedText:[self shorttext:toField.text withFont:nil]];
    
    [self addbottomBorder:fromField withColor:sharedManager.btnThemeColor];
    [self addbottomBorder:toField withColor:nil];
    [self addbottomBorder:dateField withColor:nil];
    
    [self clearValue];
}

-(void)clearValue
{
    fromField.text = @"";              fromID = @"";
    toField.text = @"";                toID = @"";
    
    goDate = @"";
    goDateEN = @"";
    
    //[dateLabel setAttributedText:[self shorttext:dateLabel.text withFont:nil]];
    //[timeLabel setAttributedText:[self shorttext:timeLabel.text withFont:nil]];
    
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
    
    dateField.inputView = dayPicker;
    [df setDateFormat:@"dd MMM yyyy"];
    dateField.text = [df stringFromDate:[NSDate date]];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    goDate = [df stringFromDate:[NSDate date]];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Start");
    
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
    NSLog(@"Change %@", textField.text);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"End");
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"กรอกรายละเอียดการเดินทาง"]) {
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
        textView.text = @"กรอกรายละเอียดการเดินทาง";
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

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Date
            [df setDateFormat:@"dd MMM yyyy"];
            dateField.text = [df stringFromDate:datePicker.date];
            
            [df setDateFormat:@"yyyy-MM-dd"];
            goDate = [df stringFromDate:datePicker.date];
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
        
    }
}

- (IBAction)searchClick:(id)sender
{
    if ([fromField.text isEqualToString:@""]||[toField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยังไม่ได้กำหนดจุดเริ่มต้นหรือปลายทาง" message:@"กรุณากำหนดจุดเริ่มต้นและปลายทางให้เรียบร้อย" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        [self loadWebView];
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
    NSLog(@"Did start loading: %@", [[request URL] absoluteString]);
    
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
    NSLog(@"Web Finish Load");
    //self.view.alpha = 1.f;
    if (webLoaded == YES)
    {
        [self finishSearch];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"!DidFailLoadWithError: %@", [error description]);
    //self.view.alpha = 1.f;
    [SVProgressHUD dismiss];
    
    [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
}

- (void)finishSearch
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@search",HOST_DOMAIN];
    NSDictionary *parameters = @{@"userEmail":sharedManager.memberID,
                                 @"dateSearch":goDateEN,
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Search %@",responseObject);
         
         searchJSON = [[responseObject objectForKey:@"data"] mutableCopy];
         if ([searchJSON count] == 0) {
             [self alertTitle:@"ไม่พบผลลัพธ์ที่ใก้ลเคียง" detail:@""];
         }
         else{
             SearchResult *scr = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResult"];
             scr.listJSON = [searchJSON mutableCopy];
             [self.navigationController pushViewController:scr animated:YES];
         }
         
         [SVProgressHUD dismiss];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
     }];
    webLoaded = NO;
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

@end
