//
//  MyInfoViewController.m
//  ilmio
//
//  Created by niko on 15/8/10.
//  Copyright (c) 2015年 com.mitsui-designtec. All rights reserved.
//

#import "MyInfoViewController.h"
#import "DataManager.h"
#import "AutoTimerButton.h"
#import "NIDropDown.h"

@interface MyInfoViewController () <NIDropDownDelegate>

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *classifyBtn;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) NSArray *addressList;

@end

#define ClassifyList    @[@"一戸建て", @"マンション", @"賃貸"]

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    self.addressList = [NSArray arrayWithContentsOfFile:plistPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshData];
}

- (IBAction)clickClassifyBtn:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 120;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :ClassifyList :self.tabBarController.view];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
    }
}

- (IBAction)clickAddressBtn:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 160;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.addressList :self.tabBarController.view];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
    }
}

- (IBAction)changeDate:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    [self.birthdayBtn setTitle:[formatter stringFromDate:sender.date] forState:UIControlStateNormal];
    
}

- (IBAction)clickBirthdayBtn:(id)sender {
    [self showDatePicker];
}
- (IBAction)clickManBtn:(id)sender {
    self.manBtn.selected = YES;
    self.womanBtn.selected = NO;
}
- (IBAction)clickWomanBtn:(id)sender {
    self.manBtn.selected = NO;
    self.womanBtn.selected = YES;
}

- (void)showDatePicker
{
    NSString *dateString = [self.birthdayBtn titleForState:UIControlStateNormal];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:dateString];
    
    if (!date) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970 - 20 * 365 * 24 * 60 * 60]];
        long year = [dateComponent year];
        long month = [dateComponent month];
        long day = [dateComponent day];
        [dateComponents setYear:year];
        [dateComponents setMonth:month];
        [dateComponents setDay:day];
        NSCalendar *currentCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.datePicker.date = [currentCalender dateFromComponents:dateComponents];
    } else {
        self.datePicker.date = date;
    }
    
    [self.dropDown hideDropDown:self.classifyBtn];
    [UIView animateWithDuration:.3 animations:^{
        self.datePicker.frame = NHRectSetY(self.datePicker.frame, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.datePicker.frame) - 50.0);
    }completion:^(BOOL finished){
//        self.maskView.hidden = NO;
    }];
}

- (IBAction)hideDatePicker:(id)sender
{
    [UIView animateWithDuration:.3 animations:^{
        self.datePicker.frame = NHRectSetY(self.datePicker.frame, CGRectGetHeight(self.view.frame));
        [self.dropDown hideDropDown];
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }completion:^(BOOL finished){
//        self.maskView.hidden = YES;
        
    }];
}

- (IBAction)save:(AutoTimerButton *)sender {
    
    sender.buttonState = Loading;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSString *birthday = [self.birthdayBtn titleForState:UIControlStateNormal];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:birthday];
    if (date) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        long year = [dateComponent year];
        long month = [dateComponent month];
        long day = [dateComponent day];
        birthday = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
    }
    
    NSString *sex = (self.manBtn.state == UIControlStateSelected ? @"1" : @"0");
    if (self.manBtn.state != UIControlStateSelected &&
        self.womanBtn.state != UIControlStateSelected) {
        sex = @"9";
    }
    NSString *address = [self.addressBtn titleForState:UIControlStateNormal];
    NSString *classify = [self.classifyBtn titleForState:UIControlStateNormal];
    NSString *notify = [[NSUserDefaults standardUserDefaults] objectForKey: kUserNotifyAllow];
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

- (void)refreshData {
    self.manBtn.selected = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserSex] isEqualToString:@"1"];
    self.womanBtn.selected = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserSex] isEqualToString:@"0"];
    NSString *birthday = [[NSUserDefaults standardUserDefaults] objectForKey:kUserBirthday];
    if (birthday.length == 0) {
        birthday = @"-    -    -";
    } else {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:birthday];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        long year = [dateComponent year];
        long month = [dateComponent month];
        long day = [dateComponent day];
        birthday = [NSString stringWithFormat:@"%ld年%ld月%ld日", year, month, day];
        
    }
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAddress];
    NSString *classify = [[NSUserDefaults standardUserDefaults] objectForKey:kUserClassify];
    [self.birthdayBtn setTitle:birthday
                      forState:UIControlStateNormal];
    [self.addressBtn setTitle:(address.length == 0 ? @"未指定" : address)
                     forState:UIControlStateNormal];
    [self.classifyBtn setTitle:(classify.length == 0 ? @"未指定" : classify)
                      forState:UIControlStateNormal];
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    self.dropDown = nil;
}


@end
