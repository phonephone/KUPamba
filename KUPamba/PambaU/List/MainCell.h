//
//  MainCell.h
//  Pamba
//
//  Created by Firststep Consulting on 7/9/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topCell;
@property (weak, nonatomic) IBOutlet UIView *midCell;
@property (weak, nonatomic) IBOutlet UIView *bottomCell;

//TOP
@property (weak, nonatomic) IBOutlet UIButton *userPicBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userPicIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIImageView *carType;

//MID
@property (weak, nonatomic) IBOutlet UILabel *startLabelL;
@property (weak, nonatomic) IBOutlet UILabel *startLabelR;
@property (weak, nonatomic) IBOutlet UILabel *endLabelL;
@property (weak, nonatomic) IBOutlet UILabel *endLabelR;
@property (weak, nonatomic) IBOutlet UILabel *dateLabelL;
@property (weak, nonatomic) IBOutlet UILabel *dateLabelR;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabelL;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabelR;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelL;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelR;
@property (weak, nonatomic) IBOutlet UILabel *seatLabelL;
@property (weak, nonatomic) IBOutlet UILabel *seatLabelR;

//OTHER
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@end
