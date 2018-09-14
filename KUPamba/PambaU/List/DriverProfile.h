//
//  DriverProfile.h
//  Pamba
//
//  Created by Firststep Consulting on 7/18/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface DriverProfile : UIViewController <UIScrollViewDelegate>
{
    Singleton *sharedManager;
    NSURLRequest *requestURL;
    long picNumber;
    UIImageView *pic1;
    UIImageView *pic2;
    UIImageView *pic3;
    UIImageView *pic4;
    BOOL scrollPic;
    NSMutableDictionary *driverJSON;
    NSDictionary *carArray;
}
@property (nonatomic) NSString *userType;
@property (nonatomic) NSString *driverID;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *myPage;


@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;

@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *universityName;
@property (weak, nonatomic) IBOutlet UILabel *offerCount;
@property (weak, nonatomic) IBOutlet UILabel *requestCount;

@property (weak, nonatomic) IBOutlet UILabel *carDetail;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chatBtnIcon;
@property (weak, nonatomic) IBOutlet UILabel *chatBtnLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIImageView *callBtnIcon;
@property (weak, nonatomic) IBOutlet UILabel *callBtnLabel;
@end
