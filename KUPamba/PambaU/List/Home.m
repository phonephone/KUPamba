//
//  Home.m
//  Samplink
//
//  Created by Firststep Consulting on 1/26/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "Home.h"
#import "RightMenu.h"
#import "OfferList.h"
#import "RequestList.h"

@interface Home () <CarbonTabSwipeNavigationDelegate> {
    NSArray *listCat;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}

@end

@implementation Home

@synthesize showQR,headerView,headerTitle,headerLBtn,headerRBtn,rightAlert,toolBar,targetView;

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedManager = [Singleton sharedManager];
    
    sharedManager.homeExisted = YES;
    rightAlert.hidden = YES;
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    
    headerTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    headerTitle.text = sharedManager.appName;
    [headerLBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [headerRBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];

    listCat = @[
                   //[UIImage imageNamed:@"search"],
                   @"เสนอที่นั่ง",
                   @"มองหาเพื่อนร่วมทาง",
                   ];
    
    carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc] initWithItems:listCat toolBar:toolBar delegate:self];
    
    [carbonTabSwipeNavigation insertIntoRootViewController:self andTargetView:self.targetView];
    
    [self style];
    
    //RightMenu *rm = (RightMenu*)[sharedManager.mainRoot.childViewControllers objectAtIndex:0];
    //[rm loadProfile];
}

- (void)viewDidAppear:(BOOL)animated {
    if (showQR) {
        showQR = NO;
        
        CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
        popup.presentingController = self;
        popup.backgroundViewAlpha = 0.7;
        popup.backgroundViewColor = [UIColor blackColor];
        popup.dismissableByTouchingBackground = YES;
        popup.destinationBounds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*0.9, [[UIScreen mainScreen] bounds].size.height*0.7);
        
        UIViewController *pp = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCode"];
        popup.presentedController = pp;
        
        [self presentViewController:pp animated:YES completion:nil];
    }
}

- (void)style {
    /*
    UIColor *color = [UIColor colorWithRed:243.0 / 255 green:75.0 / 255 blue:152.0 / 255 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    */
    
    //carbonTabSwipeNavigation.toolbar.backgroundColor = [UIColor redColor];
    carbonTabSwipeNavigation.toolbar.barTintColor = [UIColor whiteColor];
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setIndicatorColor:sharedManager.mainThemeColor];
    
    carbonTabSwipeNavigation.toolbarHeight = [NSLayoutConstraint constraintWithItem:toolBar
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:sharedManager.fontSize15*3];
    
    [self.view addConstraint:carbonTabSwipeNavigation.toolbarHeight];
    
    [carbonTabSwipeNavigation setTabExtraWidth:0];
    
    int width = [UIScreen mainScreen].bounds.size.width/2;
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:1];
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[UIColor colorWithRed:154.0/255 green:149.0/255 blue:152.0/255 alpha:1] font:[UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium]];
    [carbonTabSwipeNavigation setSelectedColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] font:[UIFont systemFontOfSize:sharedManager.fontSize15 weight:UIFontWeightMedium]];
    [carbonTabSwipeNavigation setCurrentTabIndex:0];
}

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    
    switch (index)
    {
            /*
             case 0:
             sharedManager.productList = @"Search";
             return [storyboard instantiateViewControllerWithIdentifier:@"Search"];
             */
            
        case 0:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"OfferList"];
        case 1:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"RequestList"];
            
        default:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"OfferList"];
    }

}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    //NSLog(@"Did move at index: %ld", (unsigned long)index);
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

- (IBAction)back:(id)sender
{
    NSMutableArray *newStack = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [newStack removeLastObject];
    [newStack removeLastObject];
    [self.navigationController setViewControllers:newStack animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showRightMenuPressed:(id)sender {
    self.menuContainerViewController.panMode = MFSideMenuPanModeCenterViewController | MFSideMenuPanModeSideMenu;
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
