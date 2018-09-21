//
//  ReviewCell.h
//  PambaU
//
//  Created by Firststep Consulting on 21/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *reviewUserPic;
@property (weak, nonatomic) IBOutlet UILabel *reviewNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *reviewStar1;
@property (weak, nonatomic) IBOutlet UIButton *reviewStar2;
@property (weak, nonatomic) IBOutlet UIButton *reviewStar3;
@property (weak, nonatomic) IBOutlet UIButton *reviewStar4;
@property (weak, nonatomic) IBOutlet UIButton *reviewStar5;

@end
