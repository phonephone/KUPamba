//
//  ProfileOfferDetail.h
//  Pamba
//
//  Created by Firststep Consulting on 7/30/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface ProfileOfferDetail : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    Singleton *sharedManager;
    float previousScrollViewYOffset;
    float startScrollViewYOffset;
    NSMutableDictionary *listJSON;
    UIRefreshControl *refreshController;
}
@property (nonatomic) NSString *offerID;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *mycollectionView;
@property (weak, nonatomic) IBOutlet UILabel *noresultLabel;

@end
