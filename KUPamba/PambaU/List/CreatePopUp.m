//
//  CreatePopUp.m
//  PambaU
//
//  Created by Firststep Consulting on 13/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "CreatePopUp.h"
#import "OfferForm.h"
#import "RequestForm.h"

@interface CreatePopUp ()

@end

@implementation CreatePopUp

@synthesize offerBtn,offerIcon,offerLabel,requestBtn,requestIcon,requestLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [Singleton sharedManager];
    
    offerLabel.textColor = sharedManager.mainThemeColor;
    requestLabel.textColor = sharedManager.mainThemeColor;
    
    offerIcon.image = [offerIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [offerIcon setTintColor:sharedManager.mainThemeColor];
    requestIcon.image = [requestIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [requestIcon setTintColor:sharedManager.mainThemeColor];
}

- (IBAction)addOffer:(id)sender
{
    OfferForm *of = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferForm"];
    UINavigationController *navi = (UINavigationController *)self.presentingViewController;
    [navi pushViewController:of animated:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)addRequest:(id)sender
{
    RequestForm *rf = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestForm"];
    UINavigationController *navi = (UINavigationController *)self.presentingViewController;
    [navi pushViewController:rf animated:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
