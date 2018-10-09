//
//  EditTrip.m
//  Pamba
//
//  Created by Firststep Consulting on 21/7/18.
//  Copyright © 2018 TMA Digital. All rights reserved.
//

#import "EditTrip.h"

@interface EditTrip ()

@end

@implementation EditTrip
{
    NSArray *seatArray;
}

@synthesize headerView,headerTitle,headerLBtn,dateLabel,timeLabel,priceLabel,seatLabel,dateField,timeField,priceField,seatField,offerID,goDate,goH,goM,seats,price,remark,remarkTitle,remarkText,editBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    seatArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    
    sharedManager = [Singleton sharedManager];
    
    //[[UINavigationBar appearance] setBarTintColor:sharedManager.mainThemeColor];
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    editBtn.backgroundColor = sharedManager.btnThemeColor;
    editBtn.titleLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    
    dateLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    timeLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    priceLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    seatLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    dateField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    timeField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    priceField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    seatField.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    
    remarkTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    remarkText.font = [UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium];
    remarkText.delegate = self;
    
    [self addbottomBorder:dateField withColor:nil];
    [self addbottomBorder:timeField withColor:nil];
    [self addbottomBorder:priceField withColor:nil];
    [self addbottomBorder:seatField withColor:nil];
    
    [self clearValue];
}

-(void)clearValue
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:locale];
    
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
    
    seatPicker = [[UIPickerView alloc]init];
    seatPicker.delegate = self;
    seatPicker.dataSource = self;
    [seatPicker setShowsSelectionIndicator:YES];
    seatPicker.tag = 5;
    [seatPicker selectRow:2 inComponent:0 animated:YES];
    
    dateField.inputView = dayPicker;
    [df setDateFormat:@"dd MMM yyyy"];
    NSDate *editDate = [df dateFromString:goDate];
    dateField.text = [df stringFromDate:editDate];
    [dayPicker setDate:[df dateFromString:goDate]];
    
    timeField.inputView = timePicker;
    [df setDateFormat:@"HH : mm"];
    NSString *time = [NSString stringWithFormat:@"%@ : %@",goH,goM];
    timeField.text = time;
    [timePicker setDate:[df dateFromString:time]];
    
    seatField.inputView = seatPicker;
    
    //price = @"0";
    priceField.text = price;
    if ([priceField.text intValue] == 0) {
        priceField.text = @"ฟรี";
    }
    else{
        priceField.text = [NSString stringWithFormat:@"%d บาท",[price intValue]];
    }
    
    //seats = @"3";
    seatField.text = seats;
    for (int i=0; i<[seatArray count]; i++)
    {
        if ([seats intValue] == i+1) {
            [seatPicker selectRow:i inComponent:0 animated:YES];
        }
    }
    
    remarkText.text = remark;
    if ([remarkText.text isEqualToString:@""]) {
        remarkText.text = sharedManager.detailPlaceholder;
    }
    else
    {
        remarkText.textColor = [UIColor blackColor];
    }
    
    /*
    [df setDateFormat:@"yyyy-MM-dd"];
    goDate = [df stringFromDate:[NSDate date]];
     */
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
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
            
        case 5://Seat
            rowNum = [seatArray count];
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
            
        case 5://Seat
            rowTitle = [seatArray objectAtIndex:row];
            break;
            
        default:
            break;
    }
    
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
            
        case 5://Seat
            seatField.text = [seatArray objectAtIndex:row];
            seats = [seatArray objectAtIndex:row];
            break;
            
        default:
            break;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:sharedManager.detailPlaceholder]) {
        textView.text = @"";
        //textView.textColor = [UIColor blackColor]; //optional
    }
    textView.textColor = [UIColor blackColor];
    [textView becomeFirstResponder];
}

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
    }
    
    [textField.layer addSublayer:bottomBorder];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    //textField.font = [UIFont fontWithName:@"Kanit-Regular" size:sharedManager.fontSize+2];
    
    return textField;
}

- (IBAction)editClick:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการแก้ไขข้อมูลการเดินทาง" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self loadEdit];
    }];
    [alertController addAction:ok];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadEdit
{
    sharedManager.reloadOffer = YES;
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df2 setLocale:locale];
    [df2 setDateFormat:@"yyyy-MM-dd"];
    goDate = [df2 stringFromDate:dayPicker.date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:timePicker.date];
    goH = [NSString stringWithFormat:@"%ld",(long)[components hour]];
    goM = [NSString stringWithFormat:@"%ld",(long)[components minute]];
    
    if ([remarkText.text isEqualToString:sharedManager.detailPlaceholder]) {
        remark = @"";
    }
    else
    {
        remark = remarkText.text;
    }
    NSLog(@"%@\n%@\n%@:%@\n%@\n%@\n%@",offerID,goDate,goH,goM,seats,price,remark);
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@updateOffer",HOST_DOMAIN];
    NSDictionary *parameters = @{@"oid":offerID,
                                 @"goDate":goDate,
                                 @"goH":goH,
                                 @"goM":goM,
                                 @"seats":seats,
                                 @"price":price,
                                 @"remark":remark};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"listJSON %@",responseObject);
         //listJSON = [[responseObject objectForKey:@"data"] mutableCopy];
         [SVProgressHUD showSuccessWithStatus:@"การแก้ไขถูกบันทึกแล้ว"];
         [SVProgressHUD dismissWithDelay:3];
         
         [self.navigationController popViewControllerAnimated:YES];
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
