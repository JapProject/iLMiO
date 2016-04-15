

#import "LoginController.h"
#import "OCMaskedTextFieldView.h"
#import "AutoTimerButton.h"
#import "DataManager.h"
#import "NIDropDown.h"
#import "CDatePickerViewEx.h"

@interface LoginController ()<NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet OCMaskedTextFieldView *dateInput;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet AutoTimerButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *classifyBtn;
@property (weak, nonatomic) IBOutlet UIView *section2View;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;

@property (nonatomic, strong) NIDropDown *dropDown;
@property (nonatomic, strong) NSArray *addressList;

@end

#define ClassifyList    @[@"一戸建て", @"マンション", @"賃貸"]

@implementation LoginController
- (IBAction)changeBirthday:(UIDatePicker *)sender {
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
- (IBAction)clickBirthdayBtn:(id)sender {
    [self showDatePicker];
}
- (IBAction)clickWomanBtn:(id)sender {
    [self.womanBtn setSelected:YES];
    [self.manBtn setSelected:NO];
    [self.dropDown hideDropDown:self.classifyBtn];
}
- (IBAction)clickManBtn:(id)sender {
    [self.womanBtn setSelected:NO];
    [self.manBtn setSelected:YES];
    [self.dropDown hideDropDown:self.classifyBtn];
}
- (IBAction)clickClassifyBtn:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 100;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :ClassifyList :self.navigationController.view];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
    }
}
- (IBAction)clickAddressBtn:(id)sender {
    if(self.dropDown == nil) {
        CGFloat f = 140;
        self.dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.addressList :self.navigationController.view];
        self.dropDown.delegate = self;
    }
    else {
        [self.dropDown hideDropDown:sender];
    }
}
- (IBAction)clickLoginBtn:(AutoTimerButton *)sender {
    [self.dropDown hideDropDown:self.classifyBtn];
    NSString *dateString = [self.birthdayBtn titleForState:UIControlStateNormal];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [formatter dateFromString:dateString];
    if (date) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        long year = [dateComponent year];
        long month = [dateComponent month];
        long day = [dateComponent day];
        dateString = [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
    }
    NSString *sex = (self.manBtn.state == UIControlStateSelected ? @"1" : @"0");
    if (self.manBtn.state != UIControlStateSelected &&
        self.womanBtn.state != UIControlStateSelected) {
        sex = @"9";
    }
    NSString *address = [self.addressBtn titleForState:UIControlStateNormal];;
    sender.buttonState = Loading;
    [[DataManager shareDataManager] registerNew:dateString
                                            And:sex
                                            And:address
                                            And:[self.classifyBtn titleForState:UIControlStateNormal]
                                            And:@"0"
                                       Finished:\
    ^(BOOL resualt, int errorCode, NSString *msg){
        if (resualt) {
            if (errorCode == 0) {
                [self performSegueWithIdentifier:@"HomeModal" sender:nil];
            } else {
                [[iToast makeText:msg] show];
            }
        } else {
            [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
        }
        sender.buttonState = Normal;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.dateInput setMask:@"####-##-##" showMask:NO];
//    [[self.dateInput maskedTextField] setBorderStyle:UITextBorderStyleNone];
//    [[self.dateInput maskedTextField] setFont:[UIFont boldSystemFontOfSize:17]];
//    [[self.dateInput maskedTextField] setTextColor:[UIColor whiteColor]];
//    [[self.dateInput maskedTextField] setKeyboardAppearance:UIKeyboardAppearanceAlert];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    self.addressList = [NSArray arrayWithContentsOfFile:plistPath];
//    [self.classifyBtn setTitle:ClassifyList[0] forState:UIControlStateNormal];
//    [self.addressBtn setTitle:self.addressList[0] forState:UIControlStateNormal];
    
    self.datePicker.maximumDate = [NSDate date];
    self.datePicker.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970 - 20 * 365 * 24 * 60 * 60]];
//    long year = [dateComponent year];
//    long month = [dateComponent month];
//    long day = [dateComponent day];
//    [self.birthdayBtn setTitle:[NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
    if (self.dropDown && [touch view] != self.classifyBtn) {
        [self.dropDown hideDropDown:self.classifyBtn];
    }
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
    }completion:^(BOOL finished){
        self.maskView.hidden = YES;
        
    }];
}

#define BackImageTag        9999
static CGFloat offsetY;
- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.dropDown hideDropDown:self.classifyBtn];
    CGRect keyboardBoundsEnd;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBoundsEnd];
    
    if (CGRectGetMaxY(self.section2View.frame) > CGRectGetMinY(keyboardBoundsEnd) - 10) {
        offsetY = CGRectGetMinY(self.section2View.frame) - CGRectGetMinY(keyboardBoundsEnd) + 10 + CGRectGetHeight(self.section2View.frame);
        [self animationChangeFramWith:^{
            for (UIView *subview in self.view.subviews) {
                if (subview.tag != BackImageTag) {
                    subview.frame = NHRectSetY(subview.frame,
                                                     CGRectGetMinY(subview.frame) - offsetY);
                }
            }
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (offsetY != 0.0) {
        [self animationChangeFramWith:^{
            for (UIView *subview in self.view.subviews) {
                if (subview.tag != BackImageTag) {
                    subview.frame = NHRectSetY(subview.frame,
                                               CGRectGetMinY(subview.frame) + offsetY);
                }
            }
        }];
        offsetY = .0;
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

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    self.dropDown = nil;
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
