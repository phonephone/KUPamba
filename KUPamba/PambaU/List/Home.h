//
//  Home.h
//  Samplink
//
//  Created by Firststep Consulting on 1/26/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <CarbonKit/CarbonKit.h>

@interface Home : UIViewController

{
    Singleton *sharedManager;
    CarbonTabSwipeNavigation *carbon;
}
@property (nonatomic) BOOL showQR;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;
@property (weak, nonatomic) IBOutlet UIButton *headerRBtn;

@property(weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property(weak, nonatomic) IBOutlet UIView *targetView;

@property (weak, nonatomic) IBOutlet UIImageView *rightAlert;

- (IBAction)showRightMenuPressed:(id)sender;
@end
