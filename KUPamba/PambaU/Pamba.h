//
//  Pamba.h
//  PambaU
//
//  Created by Firststep Consulting on 9/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
@interface Pamba : UIViewController
{
    Singleton *sharedManager;
    BOOL termChecked;
}
@property (strong, nonatomic) NSString *userID;

@property (strong, nonatomic) NSString *rqDTTM;
@property (strong, nonatomic) NSString *deviceID;
@property (strong, nonatomic) NSString *appID;
@property (strong, nonatomic) NSString *funcCode;
@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *xAuthorization;

@property (strong, nonatomic) NSString *inquiryUserProfile;
@property (strong, nonatomic) NSString *firstNameTh;
@property (strong, nonatomic) NSString *firstNameEn;
@property (strong, nonatomic) NSString *lastNameTh;
@property (strong, nonatomic) NSString *lastNameEn;
@property (strong, nonatomic) NSString *facultyNameTh;
@property (strong, nonatomic) NSString *facultyNameEn;
@property (strong, nonatomic) NSString *profileImageUrl;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *studentCode;
@property (strong, nonatomic) NSString *isSharewayAccepted;
@property (strong, nonatomic) NSString *language;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (weak, nonatomic) IBOutlet UILabel *termLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@end
