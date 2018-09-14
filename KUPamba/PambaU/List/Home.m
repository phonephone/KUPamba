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

@synthesize headerView,headerTitle,headerLBtn,headerRBtn,rightAlert,toolBar,targetView;

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
     self.menuContainerViewController.panMode = YES;
    
    if (sharedManager.loginStatus) {
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedManager = [Singleton sharedManager];
    
    NSLog(@"Home %@",self.menuContainerViewController.childViewControllers);
    NSLog(@"Root %@",sharedManager.mainRoot);
    for (UIViewController *controller in self.navigationController.viewControllers) {
        NSLog(@"Back %@",controller);
        if ([controller isKindOfClass:[MFSideMenuContainerViewController class]]) {
        }
    }
    
    sharedManager.homeExisted = YES;
    rightAlert.hidden = YES;
    
    headerView.backgroundColor = sharedManager.mainThemeColor;
    //headerTitle.text = //NSLocalizedString(@"You like?", nil);
    //headerTitle.font = [UIFont fontWithName:sharedManager.fontMedium size:17];
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
                                                       constant:45];
    
    [self.view addConstraint:carbonTabSwipeNavigation.toolbarHeight];
    
    [carbonTabSwipeNavigation setTabExtraWidth:0];
    
    int width = [UIScreen mainScreen].bounds.size.width/2;
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:1];
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[UIColor colorWithRed:154.0/255 green:149.0/255 blue:152.0/255 alpha:1] font:[UIFont fontWithName:sharedManager.fontMedium size:15]];
    [carbonTabSwipeNavigation setSelectedColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1] font:[UIFont fontWithName:sharedManager.fontMedium size:15]];
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
    [newStack removeLastObject];//อย่าลืมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมมม
    [self.navigationController setViewControllers:newStack animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showRightMenuPressed:(id)sender {
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
