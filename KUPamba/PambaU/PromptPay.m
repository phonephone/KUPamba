//
//  PromptPay.m
//  PambaU
//
//  Created by Firststep Consulting on 21/9/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "PromptPay.h"

@interface PromptPay ()

@end

@implementation PromptPay

@synthesize promptPayTitle,promptPayField,promptPayBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sharedManager = [Singleton sharedManager];
    
    promptPayField.delegate = self;
    
    promptPayTitle.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    promptPayField.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
    
    promptPayBtn.backgroundColor = sharedManager.btnThemeColor;
    promptPayBtn.titleLabel.font = [UIFont systemFontOfSize:sharedManager.fontSize17 weight:UIFontWeightMedium];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)promptPayClick:(id)sender
{
    if (promptPayField.text.length == 10||promptPayField.text.length == 13) {
        [self loadPromptPay];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ข้อมูลไม่ถูกต้อง" message:@"กรุณาใส่เบอร์โทรศัพท์มือถือ 10 หลัก\nหรือเลขบัตรประชาชน 13 หลัก" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)loadPromptPay
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@updatePromptPay",HOST_DOMAIN];
    NSDictionary *parameters = @{@"user_id":sharedManager.memberID,
                                 @"PromptPay_code":promptPayField.text
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"promptPayJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [self dismissViewControllerAnimated:YES completion:^{}];
             homePage = [sharedManager.mainRoot.childViewControllers objectAtIndex:1];
             homePage.showQR = YES;
             
             RightMenu *rm = (RightMenu*)[sharedManager.mainRoot.childViewControllers objectAtIndex:0];
             [rm loadProfile];
         }
         [SVProgressHUD dismiss];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD dismiss];
         
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"เกิดข้อผิดพลาด" message:@"กรุณาตรวจสอบ Internet ของท่านแล้วลองใหม่อีกครั้ง" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
         }];
         [alertController addAction:ok];
         [self presentViewController:alertController animated:YES completion:nil];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
