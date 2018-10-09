//
//  Web.m
//  Pamba
//
//  Created by Firststep Consulting on 7/29/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "Web.h"
#import "RightMenu.h"

@interface Web ()

@end

@implementation Web

@synthesize webTitle,urlString,headerView,headerTitle,headerLBtn,myWebview;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    headerTitle.text = webTitle;
    
    NSURL *url = [NSURL URLWithString:urlString];
    myWebview.delegate = self;
    myWebview.scrollView.bounces = NO;
    requestURL = [[NSURLRequest alloc] initWithURL:url];
    //[self.webView setAllowsInlineMediaPlayback:YES];
    //self.webView.mediaPlaybackRequiresUserAction = NO;
    [myWebview loadRequest:requestURL];
    
    [SVProgressHUD showWithStatus:@"Loading"];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
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

- (IBAction)back:(id)sender
{
    //RightMenu *rm = (RightMenu*)[sharedManager.mainRoot.childViewControllers objectAtIndex:0];
    //[rm loadProfile];
    
    [self.navigationController popViewControllerAnimated:YES];
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
