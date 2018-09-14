//
//  RequestDetail.h
//  Pamba
//
//  Created by Firststep Consulting on 7/11/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface RequestDetail : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
    Singleton *sharedManager;
    NSMutableArray *listJSON;
    BOOL owner;
}

@property (nonatomic) NSString *requestID;

@property(weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *headerLBtn;

@property (retain, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@end

