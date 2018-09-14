//
//  RightMenu.h
//  Samplink
//
//  Created by Firststep Consulting on 6/13/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "Home.h"

@interface RightMenu : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
    Singleton *sharedManager;
    NSMutableIndexSet *expandedSections;
    
    int alertOffer;
    int alertReserve;
    int alertChat;
    
    Home *homePage;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UITableView *myTable;

- (void)loadProfile;

@end
