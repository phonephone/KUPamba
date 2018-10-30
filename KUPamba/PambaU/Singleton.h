//
//  Singleton.h
//  Pamba
//
//  Created by Firststep Consulting on 9/7/18.
//  Copyright © 2018 TMA Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MFSideMenu/MFSideMenu.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ISMessages/ISMessages.h>
#import <CCMPopup/CCMPopupSegue.h>
#import <CCMPopup/CCMPopupTransitioning.h>

@import GooglePlaces;
@import SCBPay;

#define HOST_DOMAIN @"https://pambashare.com/kuV1/index.php/webApi_new/"
#define HOST_DOMAIN_INDEX @"https://pambashare.com/kuV1/index.php/"
#define HOST_DOMAIN_HOME @"https://pambashare.com/kuV1/"
/*
#define HOST_DOMAIN @"https://pambashare.com/v2/index.php/webApi_new/"
#define HOST_DOMAIN_INDEX @"https://pambashare.com/v2/index.php/"
#define HOST_DOMAIN_HOME @"https://pambashare.com/v2/"
*/
#define SCB_APP_URL @"scbeasy://scan/camera"
#define SCB_STORE_URL @"https://itunes.apple.com/th/app/scb-easy/id568388474"

@interface Singleton : NSObject

@property (nonatomic) float fontSize17;
@property (nonatomic) float fontSize15;
@property (nonatomic) float fontSize13;
@property (nonatomic) float fontSize11;

@property (strong, nonatomic) NSString *GoogleAPIKey;

@property (nonatomic) BOOL homeExisted;

@property (nonatomic) NSString *filterMode;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;

@property (nonatomic) BOOL reloadOffer;
@property (nonatomic) BOOL reloadRequest;

@property (nonatomic) BOOL clearOffer;
@property (nonatomic) BOOL clearRequest;

@property (nonatomic) BOOL showQR;

@property (nonatomic) BOOL loginStatus;
@property (strong, nonatomic) NSString *memberID;
@property (strong, nonatomic) NSString *memberToken;

@property (strong, nonatomic) UIColor *mainThemeColor;
@property (strong, nonatomic) UIColor *btnThemeColor;
@property (strong, nonatomic) UIColor *cancelThemeColor;

@property (nonatomic) NSString *fontNameRegular;
@property (nonatomic) NSString *fontNameMedium;

@property (nonatomic) NSString *appName;

@property (nonatomic) NSString *detailPlaceholder;

@property (strong, nonatomic) NSMutableDictionary *profileJSON;

@property (strong, nonatomic) MFSideMenuContainerViewController *mainRoot;

+ (id)sharedManager;

@end
