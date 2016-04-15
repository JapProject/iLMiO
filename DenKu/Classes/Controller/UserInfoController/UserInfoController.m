

#import "UserInfoController.h"
#import "AutoTimerButton.h"
#import "DataManager.h"
#import "OCMaskedTextFieldView.h"
#import "NIDropDown.h"
#import "DataManager.h"
#import "WebViewController.h"
#import "CDatePickerViewEx.h"

@interface UserInfoController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchNotify;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrol;
@property (weak, nonatomic) IBOutlet UIView *section3View;
@property (weak, nonatomic) IBOutlet UIView *section2View;
@property (weak, nonatomic) IBOutlet AutoTimerButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;
@property (weak, nonatomic) IBOutlet OCMaskedTextFieldView *birthTextField;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *classifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *desgTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLimite;
@property (weak, nonatomic) IBOutlet UILabel *randnameLab;

@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, assign) UITextField *responderField;
@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) NSArray *addressList;

@end
#define ClassifyList    @[@"一戸建て", @"マンション", @"賃貸"]

@implementation UserInfoController
- (IBAction)clickAgreement1:(id)sender {
    [self performSegueWithIdentifier:@"PushWeb" sender:@"agreement1"];
}
- (IBAction)clickAgreement2:(id)sender {
    [self performSegueWithIdentifier:@"PushWeb" sender:@"agreement2"];
}
- (IBAction)changeNotifySwich:(UISwitch *)sender {
    if (sender.isOn) {
        sender.on = [[DataManager shareDataManager] getAPNSOpen];
        if (!sender.isOn) {
            [[iToast makeText:NSLocalizedString(@"NotifyAbnormal", nil)] show];
        }
    }
}
- (IBAction)clickClassifyBtn:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 120;
        self.maskView.hidden = NO;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :ClassifyList :self.tabBarController.view];
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
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:sender.date];
//    long year = [dateComponent year];
//    long month = [dateComponent month];
//    long day = [dateComponent day];
//    [self.birthdayBtn setTitle:[NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day] forState:UIControlStateNormal];
}
- (IBAction)clickAddressBtn:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 160;
        self.maskView.hidden = NO;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.addressList :self.tabBarController.view];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
    }
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
- (IBAction)clickSaveBtn:(AutoTimerButton *)sender {
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
    NSString *notify = (self.switchNotify.isOn ? @"0" : @"1");
    if (self.desgTextField.text.length == 0) {
        [[iToast makeText:NSLocalizedString(@"RankIDIllegal", nil)] show];
        return;
    }
    sender.buttonState = Loading;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.birthTextField setMask:@"####-##-##" showMask:NO];
//    [[self.birthTextField maskedTextField] setBorderStyle:UITextBorderStyleNone];
//    [[self.birthTextField maskedTextField] setFont:[UIFont boldSystemFontOfSize:14]];
//    [[self.birthTextField maskedTextField] setTextColor:[UIColor blackColor]];
//    [[self.birthTextField maskedTextField] setKeyboardAppearance:UIKeyboardAppearanceAlert];
//    self.birthTextField.delegate = self;
    
    self.contentScrol.contentSize = \
    CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.section3View.frame));
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.datePicker.maximumDate = [NSDate date];
    self.datePicker.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    self.addressList = [NSArray arrayWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        self.datePicker.frame = NHRectSetY(self.datePicker.frame, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.datePicker.frame));
    }completion:^(BOOL finished){
        self.maskView.hidden = NO;
    }];
}

- (IBAction)hideDatePicker:(id)sender
{
    [UIView animateWithDuration:.3 animations:^{
        self.datePicker.frame = NHRectSetY(self.datePicker.frame, CGRectGetHeight(self.view.frame));
        [self.dropDown hideDropDown];
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }completion:^(BOOL finished){
        self.maskView.hidden = YES;
        
    }];
}

- (void)refreshData
{
    NSString *notify = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNotifyAllow];
    self.switchNotify.on = (!notify || [notify isEqualToString:@"0"]);
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
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    self.randnameLab.text = rank.rankName;
    self.desgTextField.text = rank.rankID;
    self.dateLimite.text = [NSString stringWithFormat:@"%@~%@", rank.expiredDateFrom, rank.expiredDateTo];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    self.responderField = textField;
//    [self adjustScrolOffset];
//    return YES;
//}
//
//- (BOOL)ocMaskedTextFieldShouldBeginEditing:(UITextField *)textField
//{
//    self.responderField = textField;
//    [self adjustScrolOffset];
//    return YES;
//}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBoundsEnd;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBoundsEnd];
    self.keyboardFrame = keyboardBoundsEnd;
    self.responderField = self.desgTextField;
    self.maskView.hidden = NO;
    [self adjustScrolOffset];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (offsetY != 0.0) {
        [self animationChangeFramWith:^{
            [self.contentScrol setContentOffset:CGPointMake(0, self.contentScrol.contentOffset.y - offsetY)];
        }];
    }
    offsetY = .0;
    self.contentScrol.bounces = YES;
    self.maskView.hidden = YES;
    self.keyboardFrame = CGRectZero;
}
static CGFloat offsetY;
- (void)adjustScrolOffset
{
    if (self.responderField && !CGRectEqualToRect(self.keyboardFrame, CGRectZero)) {
        CGRect frame = [self.responderField.superview convertRect:self.responderField.frame toView:nil];
        offsetY = CGRectGetMaxY(frame) - \
        (CGRectGetHeight(self.view.window.frame) - CGRectGetHeight(self.keyboardFrame) - 30);
        if (offsetY > 0) {
            self.contentScrol.bounces = NO;
            CGFloat tmpY = self.contentScrol.contentOffset.y + offsetY;
            [UIView animateWithDuration:.25 animations:^{
                [self.contentScrol setContentOffset:CGPointMake(0, tmpY)];
            }completion:^(BOOL finished){
                [self.contentScrol setContentOffset:CGPointMake(0, tmpY)];
            }];

        }
    }
}

#define kAnimationDuration 0.25f
#define kAnimationCurve 7
- (void)animationChangeFramWith:(void (^)())block
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:kAnimationCurve];
    block();
    [UIView commitAnimations];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UIScrollViewDelegate
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.addressTextfield becomeFirstResponder];
    } else if (textField == self.addressTextfield) {
        [self.birthTextField becomeFirstResponder];
    }
    return YES;
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    self.maskView.hidden = YES;
    self.dropDown = nil;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WebViewController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[WebViewController class]]) {
        dest.urlStrng = sender;
    }
}


@end
