//
//  SearchResult.h
//  PambaU
//
//  Created by Firststep Consulting on 21/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>

@interface SearchResult : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>

{
    Singleton *sharedManager;
    float previousScrollViewYOffset;
    float startScrollViewYOffset;
    
    UIRefreshControl *refreshController;
    CLLocationManager * locationManager;
}
@property (nonatomic) NSMutableArray *listJSON;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *mycollectionView;

@end
