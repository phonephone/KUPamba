//
//  RequestForm.h
//  Pamba
//
//  Created by Firststep Consulting on 7/14/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>

@interface RequestForm : UIViewController <CLLocationManagerDelegate,UITextFieldDelegate,UITextViewDelegate,UIWebViewDelegate>

{
    Singleton *sharedManager;
    NSMutableArray *listJSON;
    CLLocationManager * locationManager;
    
    UIDatePicker *dayPicker;
    UIDatePicker *timePicker;
    NSDateFormatter *df;
    
    long nowEdit;
    
    NSString *fromID;
    NSString *toID;
    NSString *distance;
    NSString *duration;
    NSString *goDate;
    NSString *goDateEN;
    NSString *goH;
    NSString *goM;
    NSString *remark;
    
    NSLocale *localeTH;
    NSLocale *localeEN;
    
    NSURLRequest *requestURL;
    
    BOOL webLoaded;
}

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UITextField *fromField;
@property (weak, nonatomic) IBOutlet UITextField *toField;

@property (weak, nonatomic) IBOutlet UIButton *targetBtn;
@property (weak, nonatomic) IBOutlet UIButton *swapBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;

@property (weak, nonatomic) IBOutlet UILabel *remarkTitle;
@property (weak, nonatomic) IBOutlet UITextView *remarkText;
@end
