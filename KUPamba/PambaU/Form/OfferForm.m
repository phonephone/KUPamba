//
//  OfferForm.m
//  Pamba
//
//  Created by Firststep Consulting on 7/12/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "OfferForm.h"
#import "OfferForm2.h"
#import "PriceInfo.h"

@interface OfferForm () <GMSAutocompleteViewControllerDelegate>

@end

@implementation OfferForm
{
    GMSPlacesClient *_placesClient;
    GMSAutocompleteResultsViewController *_resultsViewController;
    NSArray *typeArray;
    NSArray *extimeArray;
    NSArray *seatArray;
    NSArray *genderArray;
    NSArray *bagArray;
}

@synthesize carType,headerView,headerTitle,headerLBtn,fromLabel,toLabel,fromField,toField,targetBtn,swapBtn,infoBtn,nextBtn,typeLabel,dateLabel,timeLabel,priceLabel,extimeLabel,seatLabel,genderLabel,bagLabel,typeField,dateField,timeField,priceField,extimeField,seatField,genderField,bagField;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;

    if (sharedManager.clearOffer == YES) {
        [self clearValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    //[[UINavigationBar appearance] setBarTintColor:sharedManager.mainThemeColor];
    
    _placesClient = [GMSPlacesClient sharedClient];
    
    typeArray = @[@"รถยนต์",@"รถตู้",@"แท็กซี่",@"จักรยานยนต์"];
    
    extimeArray = @[@"ตรงเวลา",
                    @"± 15 นาที",@"± 30 นาที",@"± 45 นาที",@"เวลาใดก็ได้"];
    
    seatArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    
    genderArray = @[@"ไม่ระบุ",@"ชาย",@"หญิง"];
    
    bagArray = @[@"เล็ก",@"กลาง",@"ใหญ่"];
    
    //NSLog(@"What %@",[tab.childViewControllers objectAtIndex:0]);
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [swapBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    swapBtn.imageView.image = [swapBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [swapBtn.imageView setTintColor:sharedManager.mainThemeColor];
    
    nextBtn.backgroundColor = sharedManager.btnThemeColor;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    
    fromLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    toLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    fromField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    toField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    typeLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    dateLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    timeLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    priceLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    extimeLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    seatLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    genderLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    bagLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    typeField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    dateField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    timeField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    priceField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    extimeField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    seatField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    genderField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    bagField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    [self addbottomBorder:fromField withColor:sharedManager.btnThemeColor];
    [self addbottomBorder:toField withColor:nil];
    [self addbottomBorder:typeField withColor:nil];
    [self addbottomBorder:dateField withColor:nil];
    [self addbottomBorder:timeField withColor:nil];
    [self addbottomBorder:priceField withColor:nil];
    [self addbottomBorder:extimeField withColor:nil];
    [self addbottomBorder:seatField withColor:nil];
    [self addbottomBorder:genderField withColor:nil];
    [self addbottomBorder:bagField withColor:nil];
    
    [self clearValue];
}

-(void)clearValue
{
    waypointID = @"";
    distanceInfo = @"0";
    publicPrice = @"0";
    meterPrice = @"0";
    
    typeField.text = @"รถยนต์";          carType = @"1";
    fromField.text = @"";               fromID = @"";
    toField.text = @"";                 toID = @"";
    priceField.text = @"ฟรี";            price = @"0";
    extimeField.text = @"± 15 นาที";     exTime = @"15";
    seatField.text = @"3";              seats = @"3";
    genderField.text = @"ไม่ระบุ";        gender = @"";
    bagField.text = @"เล็ก";             luggage = @"small";
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    //[locationManager requestAlwaysAuthorization];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:locale];
    
    carPicker = [[UIPickerView alloc]init];
    carPicker.delegate = self;
    carPicker.dataSource = self;
    [carPicker setShowsSelectionIndicator:YES];
    carPicker.tag = 0;
    [carPicker selectRow:0 inComponent:0 animated:YES];
    
    dayPicker = [[UIDatePicker alloc]init];
    [dayPicker setDatePickerMode:UIDatePickerModeDate];
    [dayPicker setMinimumDate: [NSDate date]];
    [dayPicker setLocale:locale];
    dayPicker.calendar = [locale objectForKey:NSLocaleCalendar];
    dayPicker.tag = 1;
    [dayPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    timePicker = [[UIDatePicker alloc]init];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker setLocale:locale];
    timePicker.tag = 2;
    [timePicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    extimePicker = [[UIPickerView alloc]init];
    extimePicker.delegate = self;
    extimePicker.dataSource = self;
    [extimePicker setShowsSelectionIndicator:YES];
    extimePicker.tag = 3;
    [extimePicker selectRow:1 inComponent:0 animated:YES];
    
    seatPicker = [[UIPickerView alloc]init];
    seatPicker.delegate = self;
    seatPicker.dataSource = self;
    [seatPicker setShowsSelectionIndicator:YES];
    seatPicker.tag = 5;
    [seatPicker selectRow:2 inComponent:0 animated:YES];
    
    genderPicker = [[UIPickerView alloc]init];
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    [genderPicker setShowsSelectionIndicator:YES];
    genderPicker.tag = 6;
    [genderPicker selectRow:0 inComponent:0 animated:YES];
    
    bagPicker = [[UIPickerView alloc]init];
    bagPicker.delegate = self;
    bagPicker.dataSource = self;
    [bagPicker setShowsSelectionIndicator:YES];
    bagPicker.tag = 7;
    [bagPicker selectRow:0 inComponent:0 animated:YES];
    
    dateField.inputView = dayPicker;
    [df setDateFormat:@"dd MMM yyyy"];
    dateField.text = [df stringFromDate:[NSDate date]];
    
    timeField.inputView = timePicker;
    [df setDateFormat:@"HH : mm"];
    timeField.text = [df stringFromDate:[NSDate date]];
    
    typeField.inputView = carPicker;
    extimeField.inputView = extimePicker;
    seatField.inputView = seatPicker;
    genderField.inputView = genderPicker;
    bagField.inputView = bagPicker;
    
    [df setDateFormat:@"yyyy-MM-dd"];
    goDate = [df stringFromDate:[NSDate date]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    goH = [NSString stringWithFormat:@"%ld",(long)[components hour]];
    goM = [NSString stringWithFormat:@"%ld",(long)[components minute]];
    
    sharedManager.clearOffer = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewDidDisappear:(BOOL)animated
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
        filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
        filter.country = @"TH";
        acController.autocompleteFilter = filter;
        [self presentViewController:acController animated:YES completion:nil];
    }
    
    if (textField.tag == 99) {
        if ([textField.text isEqualToString:@"ฟรี"]) {
            priceField.text = @"0";
        }
        else{
            priceField.text = [textField.text stringByReplacingOccurrencesOfString:@" บาท" withString:@""];
        }
    }
}
    
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 99) {
        if ([textField.text intValue] == 0) {
            price = @"0";
            priceField.text = @"ฟรี";
        }
        else{
            price = textField.text;
            priceField.text = [NSString stringWithFormat:@"%d บาท",[textField.text intValue]];
        }
    }
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
        [self priceSuggest];
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

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    long rowNum = 0;
    
    switch (pickerView.tag) {
        
        case 0://Cartype
            rowNum = [typeArray count];
            break;
            
        case 3://Extime
            rowNum = [extimeArray count];
            break;
            
            
        case 5://Seat
            rowNum = [seatArray count];
            break;
            
        case 6://Gender
            rowNum = [genderArray count];
            break;
            
        case 7://Bag
            rowNum = [bagArray count];
            break;
        
        default:
        break;
    }
    
    return rowNum;
}
    
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle;
    
    switch (pickerView.tag) {
        
        case 0://Cartype
            rowTitle = [typeArray objectAtIndex:row];
            break;
            
        case 3://Extime
            rowTitle = [extimeArray objectAtIndex:row];
        break;
        
        case 5://Seat
            rowTitle = [seatArray objectAtIndex:row];
        break;
        
        case 6://Gender
            rowTitle = [genderArray objectAtIndex:row];
        break;
            
        case 7://Bag
            rowTitle = [bagArray objectAtIndex:row];
            break;
        
        default:
        break;
    }
    
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case 0://Cartype
            typeField.text = [typeArray objectAtIndex:row];
            carType = [NSString stringWithFormat:@"%ld",row+1];
            break;
            
        case 3://Extime
            extimeField.text = [extimeArray objectAtIndex:row];
            if (row == 1) {
                exTime = @"15";
            }
            else if (row == 2) {
                exTime = @"30";
            }
            else if (row == 3) {
                exTime = @"45";
            }
            else{
                exTime = [extimeArray objectAtIndex:row];
            }
            break;
            
        case 5://Seat
            seatField.text = [seatArray objectAtIndex:row];
            seats = [seatArray objectAtIndex:row];
            break;
            
        case 6://Gender
            genderField.text = [genderArray objectAtIndex:row];
            if (row == 0) {
                gender = @"";
            }
            else if (row == 1) {
                gender = @"male";
            }
            else if (row == 2) {
                gender = @"female";
            }
            break;
            
        case 7://Bag
            bagField.text = [bagArray objectAtIndex:row];
            if (row == 0) {
                luggage = @"small";
            }
            else if (row == 1) {
                luggage = @"medium";
            }
            else if (row == 2) {
                luggage = @"large";
            }
            break;
            
        default:
            break;
    }
}

- (void)priceSuggest
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@OfferDirection",HOST_DOMAIN];
    NSDictionary *parameters = @{@"ori":fromID,
                                 @"des":toID,
                                 @"way_point":@""
                                 //@"way_point":@"place_id:ChIJ4zOyQ7uc4jARiilqapBEimI|place_id:ChIJaWVzXFqb4jARri6ciDPQQHI",
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         distanceInfo = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"allKm"];
         publicPrice = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"minCost"];
         meterPrice = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"maxCost"];
         price = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"price"];
         priceField.text = [NSString stringWithFormat:@"%@ บาท",price];
         
         [SVProgressHUD dismiss];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         [self alertTitle:@"เกิดข้อผิดพลาด" detail:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง"];
     }];
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
                
                if (![toField.text isEqualToString:@""] && ![fromField.text isEqualToString:@""]) {
                    [self priceSuggest];
                }
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
       [self priceSuggest];
    }
}

- (IBAction)nextClick:(id)sender
{
    //NSLog(@"From %@ %@\nTo %@ %@\nDistance %@\nCartype %@\nDate %@\nTime %@:%@\nExtime %@\nSeats %@\nGender %@\nLuggage %@\nPrice %@",fromID,fromField.text,toID,toField.text,distanceInfo,carType,goDate,goH,goM,exTime,seats,gender,luggage,price);
    if ([fromField.text isEqualToString:@""]||[toField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยังไม่ได้กำหนดจุดเริ่มต้นหรือปลายทาง" message:@"กรุณากำหนดจุดเริ่มต้นและปลายทางให้เรียบร้อย" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        OfferForm2 *of2 = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferForm2"];
        of2.fromID = fromID;
        of2.fromName = fromField.text;
        of2.toID = toID;
        of2.toName = toField.text;
        
        of2.distance = [NSString stringWithFormat:@"%.1f กม.",[distanceInfo floatValue]];
        of2.duration = @"";
        of2.goDate = goDate;
        of2.goH = goH;
        of2.goM = goM;
        of2.exTime = exTime;
        of2.seats = seats;
        of2.luggage = luggage;
        of2.gender = gender;
        of2.price = price;

        of2.carType = carType;
        [self.navigationController pushViewController:of2 animated:YES];
    }
}
    
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue isKindOfClass:[CCMPopupSegue class]]){
        CCMPopupSegue *popupSegue = (CCMPopupSegue *)segue;
        
        if([segue.identifier isEqualToString:@"priceInfo"])
        {
            popupSegue.destinationBounds = CGRectMake(0, 0, self.view.frame.size.width*0.9, self.view.frame.size.width*0.5);
            
            popupSegue.backgroundViewAlpha = 0.7;
            popupSegue.backgroundViewColor = [UIColor blackColor];
            popupSegue.dismissableByTouchingBackground = YES;
            
            PriceInfo *pi = (PriceInfo*)segue.destinationViewController;
            pi.distanceInfo = distanceInfo;
            pi.publicPrice = publicPrice;
            pi.meterPrice = meterPrice;
        }
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
