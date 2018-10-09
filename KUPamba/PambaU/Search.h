//
//  Search.h
//  Pamba
//
//  Created by Firststep Consulting on 7/18/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>

@interface Search : UIViewController <CLLocationManagerDelegate,UITextFieldDelegate,UITextViewDelegate,UIWebViewDelegate>

{
    Singleton *sharedManager;
    NSMutableArray *searchJSON;
    CLLocationManager * locationManager;
    
    UIDatePicker *dayPicker;
    NSDateFormatter *df;
    
    long nowEdit;
    
    NSString *fromID;
    NSString *toID;
    NSString *goDate;
    NSString *goDateEN;
    
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

@property (weak, nonatomic) IBOutlet UITextField *dateField;

@end
