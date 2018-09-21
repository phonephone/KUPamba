//
//  PromptPay.h
//  PambaU
//
//  Created by Firststep Consulting on 21/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "Home.h"
#import "RightMenu.h"

@interface PromptPay : UIViewController <UITextFieldDelegate>
{
    Singleton *sharedManager;
    
    Home *homePage;
}

@property (weak, nonatomic) IBOutlet UILabel *promptPayTitle;
@property (weak, nonatomic) IBOutlet UITextField *promptPayField;
@property (weak, nonatomic) IBOutlet UIButton *promptPayBtn;

@end
