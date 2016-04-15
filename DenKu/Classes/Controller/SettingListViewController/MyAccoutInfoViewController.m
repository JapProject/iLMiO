//
//  MyAccoutInfoViewController.m
//  ilmio
//
//  Created by niko on 15/8/10.
//  Copyright (c) 2015年 com.mitsui-designtec. All rights reserved.
//

#import "MyAccoutInfoViewController.h"
#import "DataManager.h"
#import "AutoTimerButton.h"

@interface MyAccoutInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *desgTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLimite;
@property (weak, nonatomic) IBOutlet UILabel *randnameLab;

@end

@implementation MyAccoutInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshData];
}

- (IBAction)save:(AutoTimerButton *)sender {
    if (self.desgTextField.text.length == 0) {
        [[iToast makeText:NSLocalizedString(@"RankIDIllegal", nil)] show];
        return;
    }
    sender.buttonState = Loading;
    NSString *birthday = [[NSUserDefaults standardUserDefaults] objectForKey:kUserBirthday];
    NSString *sex = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSex];
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAddress];
    NSString *classify = [[NSUserDefaults standardUserDefaults] objectForKey:kUserClassify];
    NSString *notify = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNotifyAllow];
    [[DataManager shareDataManager] updateUserINfo:birthday
                                               And:sex
                                               And:address
                                               And:classify
                                               And:notify
                                               And:self.desgTextField.text
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

- (void)refreshData {
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    self.randnameLab.text = rank.rankName;
    self.desgTextField.text = rank.rankID;
    self.dateLimite.text = [NSString stringWithFormat:@"%@~%@", rank.expiredDateFrom, rank.expiredDateTo];
}


@end
