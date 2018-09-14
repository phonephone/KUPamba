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

@interface Search : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,CLLocationManagerDelegate,UIWebViewDelegate>
{
    Singleton *sharedManager;
    float previousScrollViewYOffset;
    float startScrollViewYOffset;
    NSMutableArray *searchJSON;
    
    CLLocationManager * locationManager;
    
    UIDatePicker *dayPicker;
    UIDatePicker *timePicker;
    NSDateFormatter *df;
    
    long nowEdit;
    
    BOOL notFound;
    
    NSString *fromID;
    NSString *toID;
    NSString *goDate;
    NSString *goDateEN;
    
    NSLocale *localeTH;
    NSLocale *localeEN;
    
    NSURLRequest *requestURL;
    
    BOOL webLoaded;
}

@property(weak, nonatomic) IBOutlet UIView *bgView;
@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

@property (weak, nonatomic) IBOutlet UICollectionView *mycollectionView;

@end
