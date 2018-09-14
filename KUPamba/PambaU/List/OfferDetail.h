//
//  OfferDetail.h
//  Pamba
//
//  Created by Firststep Consulting on 7/9/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface OfferDetail : UIViewController <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

{
    Singleton *sharedManager;
    NSMutableArray *listJSON;
    BOOL owner;
}

@property (nonatomic) NSString *offerID;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (retain, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
