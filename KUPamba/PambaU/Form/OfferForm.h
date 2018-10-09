//
//  OfferForm.h
//  Pamba
//
//  Created by Firststep Consulting on 7/12/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>

@interface OfferForm : UIViewController <CLLocationManagerDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    Singleton *sharedManager;
    NSMutableArray *listJSON;
    CLLocationManager * locationManager;
    
    UIPickerView *carPicker;
    UIDatePicker *dayPicker;
    UIDatePicker *timePicker;
    UIPickerView *extimePicker;
    UIPickerView *seatPicker;
    UIPickerView *genderPicker;
    UIPickerView *bagPicker;
    NSDateFormatter *df;
    
    long nowEdit;
    NSString *fromID;
    NSString *toID;
    NSString *waypointID;
    NSString *distanceInfo;
    NSString *publicPrice;
    NSString *meterPrice;
    
    NSString *goDate;
    NSString *goH;
    NSString *goM;
    NSString *exTime;
    NSString *seats;
    NSString *luggage;
    NSString *gender;
    NSString *price;
}
@property (nonatomic) NSString *carType;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UITextField *fromField;
@property (weak, nonatomic) IBOutlet UITextField *toField;

@property (weak, nonatomic) IBOutlet UIButton *targetBtn;
@property (weak, nonatomic) IBOutlet UIButton *swapBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *extimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bagLabel;

@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextField *extimeField;
@property (weak, nonatomic) IBOutlet UITextField *seatField;
@property (weak, nonatomic) IBOutlet UITextField *genderField;
@property (weak, nonatomic) IBOutlet UITextField *bagField;

@end
