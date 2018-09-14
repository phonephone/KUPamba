//
//  Profile.h
//  Pamba
//
//  Created by Firststep Consulting on 7/14/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface Profile : UIViewController <UIScrollViewDelegate>
{
    Singleton *sharedManager;
    NSURLRequest *requestURL;
    long picNumber;
    UIImageView *pic1;
    UIImageView *pic2;
    UIImageView *pic3;
    UIImageView *pic4;
    BOOL scrollPic;
}

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;
@property (weak, nonatomic) IBOutlet UIButton *headerRBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *myPage;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;

@property (weak, nonatomic) IBOutlet UILabel *profileL1;
@property (weak, nonatomic) IBOutlet UILabel *profileL2;
@property (weak, nonatomic) IBOutlet UILabel *profileL3;
@property (weak, nonatomic) IBOutlet UILabel *profileL4;
@property (weak, nonatomic) IBOutlet UILabel *profileR1;
@property (weak, nonatomic) IBOutlet UILabel *profileR2;
@property (weak, nonatomic) IBOutlet UILabel *profileR3;
@property (weak, nonatomic) IBOutlet UILabel *profileR4;

@property (weak, nonatomic) IBOutlet UILabel *carTitle;
@property (weak, nonatomic) IBOutlet UILabel *carL1;
@property (weak, nonatomic) IBOutlet UILabel *carL2;
@property (weak, nonatomic) IBOutlet UILabel *carL3;
@property (weak, nonatomic) IBOutlet UILabel *carL4;
@property (weak, nonatomic) IBOutlet UILabel *carR1;
@property (weak, nonatomic) IBOutlet UILabel *carR2;
@property (weak, nonatomic) IBOutlet UILabel *carR3;
@property (weak, nonatomic) IBOutlet UILabel *carR4;

@end
