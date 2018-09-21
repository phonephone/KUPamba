//
//  ReviewCell.m
//  PambaU
//
//  Created by Firststep Consulting on 21/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "ReviewCell.h"

@implementation ReviewCell

@synthesize reviewUserPic,reviewNameLabel,reviewStar1,reviewStar2,reviewStar3,reviewStar4,reviewStar5;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
