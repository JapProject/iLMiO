//
//  NotifySettingViewController.m
//  ilmio
//
//  Created by niko on 15/8/10.
//  Copyright (c) 2015年 com.mitsui-designtec. All rights reserved.
//

#import "NotifySettingViewController.h"
#import "DataManager.h"
#import "AutoTimerButton.h"

@interface NotifySettingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchNotify;

@end

@implementation NotifySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (IBAction)changeNotifySwich:(UISwitch *)sender {
   
}

- (void)refreshData
{
    NSString *notify = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNotifyAllow];
    self.switchNotify.on = (!notify || [notify isEqualToString:@"0"]);
}


- (IBAction)save:(AutoTimerButton *)sender {
    
    sender.buttonState = Loading;
    NSString *birthday = [[NSUserDefaults standardUserDefaults] objectForKey:kUserBirthday];
    NSString *sex = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSex];
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAddress];
    NSString *classify = [[NSUserDefaults standardUserDefaults] objectForKey:kUserClassify];
    NSString *notify = self.switchNotify.isOn ? @"0" : @"1";
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    NSString *rankid = rank.rankID;
    [[DataManager shareDataManager] updateUserINfo:birthday
                                               And:sex
                                               And:address
                                               And:classify
                                               And:notify
                                               And:rankid
                                          Finished:\
     ^(BOOL resualt, int errorCode, NSString *msg){
         if (resualt) {
             if (errorCode == 0) {
                 [self refreshData];
                 [[iToast makeText:NSLocalizedString(@"UpdateUserInfoSuc", nil)] show];
             } else {
                 [[iToast makeText:msg] show];
             }
         } else {
             [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
         }
         sender.buttonState = Normal;
     }];
}

- (void )save{
    
    
}

@end
