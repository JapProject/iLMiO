//
//  DateRegistController.m
//  ilmio
//
//  Created by shavin on 16/1/13.
//  Copyright © 2016年 com.mitsui-designtec. All rights reserved.
//

#import "DateRegistController.h"
#import "DataManager.h"

@interface DateRegistController ()

@end

@implementation DateRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registButton.layer.cornerRadius = 7.0;
    self.registButton.layer.borderWidth = 1.0;
    self.registButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.registButton.layer.shadowColor = [[UIColor colorWithWhite:0.6 alpha:0.6] CGColor];
    self.registButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.registButton.layer.shadowOpacity = 1;
    // Do any additional setup after loading the view.
}

- (IBAction)regist:(id)sender {
    self.indicator.alpha = 1;
    self.registButton.enabled = NO;
    [self.indicator startAnimating];
    [[DataManager shareDataManager] refreshUserInfoFinished:\
     ^(BOOL resualt, int errorCode, NSString *msg){
         self.registButton.enabled = YES;
         [self stopAnimation];
         if (resualt) {
             if (errorCode == 0) {
                 
             } else {
                 [[iToast makeText:msg] show];
             }
         } else {
             [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
         }
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
}

- (void)stopAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.indicator.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.indicator stopAnimating];
    }];
}

@end
