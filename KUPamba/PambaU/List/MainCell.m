//
//  MainCell.m
//  Pamba
//
//  Created by Firststep Consulting on 7/9/17.
//  Copyright © 2017 TMA Digital. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell
@synthesize topCell,midCell,bottomCell,userPicBtn,userPicIcon,nameLabel,star1,star2,star3,star4,star5,reviewCount,messageBtn,callBtn,carType;

@synthesize startLabelL,startLabelR,endLabelL,endLabelR,dateLabelL,dateLabelR,distanceLabelL,distanceLabelR,timeLabelL,timeLabelR,seatLabelL,seatLabelR;

@synthesize detailBtn;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    
    if (editing) {
        
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage imageNamed: @"form_reorder"];
                        ((UIImageView *)subview).contentMode = UIViewContentModeScaleAspectFit;
                    }
                }
            }
        }
    }   
}

@end
