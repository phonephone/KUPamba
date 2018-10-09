//
//  RequestList.h
//  Pamba
//
//  Created by Firststep Consulting on 7/8/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>

@interface RequestList : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>

{
    Singleton *sharedManager;
    float previousScrollViewYOffset;
    float startScrollViewYOffset;
    NSMutableArray *listJSON;
    UIRefreshControl *refreshController;
    CLLocationManager * locationManager;
    BOOL showFilter;
}

@property (weak, nonatomic) IBOutlet UICollectionView *mycollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

- (void)loadList;
@end
