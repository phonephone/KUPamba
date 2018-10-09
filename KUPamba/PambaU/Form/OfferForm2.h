//
//  OfferForm2.h
//  Pamba
//
//  Created by Firststep Consulting on 7/13/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface OfferForm2 : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIWebViewDelegate>
{
    Singleton *sharedManager;
    NSMutableArray *pickupArray;
    BOOL smoke;
    BOOL food;
    BOOL pet;
    BOOL music;
    NSString *smokeString;
    NSString *foodString;
    NSString *musicString;
    NSString *petString;
    
    NSDateFormatter *df;
    
    NSURLRequest *requestURL;
    
    BOOL webLoaded;
}
@property (nonatomic) NSString *fromID;
@property (nonatomic) NSString *fromName;
@property (nonatomic) NSString *toID;
@property (nonatomic) NSString *toName;
@property (nonatomic) NSString *distance;
@property (nonatomic) NSString *duration;
@property (nonatomic) NSString *goDate;
@property (nonatomic) NSString *goH;
@property (nonatomic) NSString *goM;
@property (nonatomic) NSString *exTime;
@property (nonatomic) NSString *seats;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *luggage;

@property (nonatomic) NSString *option;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *remark;
@property (nonatomic) NSString *waypoint;
@property (nonatomic) NSString *carType;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;
    
@property (retain, nonatomic) IBOutlet UITableView *myTable;
    
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *checkTitle;
@property (weak, nonatomic) IBOutlet UIButton *checkBox1;
@property (weak, nonatomic) IBOutlet UIButton *checkBox2;
@property (weak, nonatomic) IBOutlet UIButton *checkBox3;
@property (weak, nonatomic) IBOutlet UIButton *checkBox4;

@property (weak, nonatomic) IBOutlet UILabel *checkLabel1;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel2;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel3;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel4;

@property (weak, nonatomic) IBOutlet UILabel *remarkTitle;
@property (weak, nonatomic) IBOutlet UITextView *remarkText;

@property (weak, nonatomic) IBOutlet UILabel *pickTitle;

@property (weak, nonatomic) IBOutlet UIButton *waypointBtn;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end
