//
//  QRCode.m
//  PambaU
//
//  Created by Firststep Consulting on 21/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "QRCode.h"

@interface QRCode ()

@end

@implementation QRCode

@synthesize nameLabel,myWebview;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    int promptpayType = [[sharedManager.profileJSON objectForKey:@"promtpayType"] intValue];
    NSString *promptpayStr;
    switch (promptpayType) {
        case 0:
            promptpayStr = @"";
            break;
        case 1://Mobile
            promptpayStr = [sharedManager.profileJSON objectForKey:@"promtpayMobileNumber"];
            break;
        case 2://ID Card
            promptpayStr = [sharedManager.profileJSON objectForKey:@"citizenID"];
            break;
            
        default:
            break;
    }
    nameLabel.text = [NSString stringWithFormat:@"ชื่อ %@\nหมายเลขพร้อมเพย์ %@",[sharedManager.profileJSON objectForKey:@"name"],promptpayStr];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@myQrPayment?user_id=%@",HOST_DOMAIN,sharedManager.memberID]];
    myWebview.delegate = self;
    myWebview.scrollView.bounces = NO;
    myWebview.scrollView.scrollEnabled = NO;
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:url];
    //[self.webView setAllowsInlineMediaPlayback:YES];
    //self.webView.mediaPlaybackRequiresUserAction = NO;
    [myWebview loadRequest:requestURL];
    
    [SVProgressHUD showWithStatus:@"Loading"];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"Did start loading: %@", [[request URL] absoluteString]);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //self.view.alpha = 1.f;
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"!DidFailLoadWithError: %@", [error description]);
    //self.view.alpha = 1.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
