//
//  Singleton.m
//  Pamba
//
//  Created by Firststep Consulting on 9/7/18.
//  Copyright © 2018 TMA Digital. All rights reserved.
//

#import "Singleton.h"
#import <CoreText/CoreText.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation Singleton

@synthesize homeExisted,reloadOffer,reloadRequest,clearOffer,clearRequest,loginStatus;

@synthesize fontSize,GoogleAPIKey,memberID,memberToken,filterMode,latitude,longitude,mainThemeColor,btnThemeColor,cancelThemeColor,fontRegular,fontMedium,profileJSON,mainRoot;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static Singleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        GoogleAPIKey = @"AIzaSyBszQzhwq0TuUmWZVZ1bWf_AGhwExtUbqo";
        [GMSPlacesClient provideAPIKey:GoogleAPIKey];
        //[GMSServices provideAPIKey:@"YOUR_API_KEY"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"th", nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        mainThemeColor = [UIColor colorWithRed:0.0/255 green:102.0/255 blue:100.0/255 alpha:1];
        btnThemeColor = [UIColor colorWithRed:178.0/255 green:187.0/255 blue:30.0/255 alpha:1];
        cancelThemeColor = [UIColor colorWithRed:208.0/255 green:0.0/255 blue:0.0/255 alpha:1];
        
        [SVProgressHUD setBorderColor:[UIColor lightGrayColor]];
        [SVProgressHUD setBorderWidth:1.0];
        
        /*
        for (NSString* family in [UIFont familyNames])
        {
            NSLog(@"%@", family);
            
            for (NSString* name in [UIFont fontNamesForFamilyName: family])
            {
                NSLog(@"  %@", name);
            }
        }
        */
        //HelveticaNeue
        //HelveticaNeue-Medium
        
        //Thonburi
        //Thonburi-Bold
        
        fontRegular = @"Thonburi";
        fontMedium = @"Thonburi-Bold";
        //[self loadFontWithName:fontRegular];
        //[self loadFontWithName:fontMedium];
        
        memberID = @"";
        memberToken = @"";
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        loginStatus = [ud boolForKey:@"loginStatus"];
        
        if (loginStatus == YES) {
            memberID = [ud stringForKey:@"memberID"];
            NSLog(@"LOG IN %@",memberID);
        }
        else{
            NSLog(@"LOG OUT");
        }
        
        //loginStatus = NO;
        //loginStatus = YES;
        
        filterMode = @"";
        latitude = @"";
        longitude = @"";
        
        if (IS_IPHONE) {
            float factor = [UIScreen mainScreen].bounds.size.width/320;
            fontSize = 13*factor;
        }
        if (IS_IPAD) {
            float factor = [UIScreen mainScreen].bounds.size.width/768;
            fontSize = 25*factor;
        }
    }
    return self;
}

- (void)loadFontWithName:(NSString *)fontName
{
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:@"ttf"];
    NSData *fontData = [NSData dataWithContentsOfFile:fontPath];
    
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)fontData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}

@end
