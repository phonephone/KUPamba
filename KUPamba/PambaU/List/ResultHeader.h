//
//  ResultHeader.h
//  PambaU
//
//  Created by Firststep Consulting on 9/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *resultTitle;
@property (weak, nonatomic) IBOutlet UILabel *resultSort;
@property (weak, nonatomic) IBOutlet UIButton *fiterBtn;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@end
