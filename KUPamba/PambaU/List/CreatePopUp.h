//
//  CreatePopUp.h
//  PambaU
//
//  Created by Firststep Consulting on 13/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface CreatePopUp : UIViewController
{
    Singleton *sharedManager;
}
@property (weak, nonatomic) IBOutlet UIButton *offerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *offerIcon;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;

@property (weak, nonatomic) IBOutlet UIButton *requestBtn;
@property (weak, nonatomic) IBOutlet UIImageView *requestIcon;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;

@end
