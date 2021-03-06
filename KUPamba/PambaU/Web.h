//
//  Web.h
//  Pamba
//
//  Created by Firststep Consulting on 7/29/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface Web : UIViewController <UIWebViewDelegate>
{
    Singleton *sharedManager;
    NSURLRequest *requestURL;
}
@property (nonatomic) NSString *webTitle;
@property (nonatomic) NSString *urlString;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (weak, nonatomic) IBOutlet UIWebView *myWebview;
@end
