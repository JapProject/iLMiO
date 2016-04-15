

#import "DesignationController.h"
#import "AutoTimerButton.h"

#import <MessageUI/MessageUI.h>
#import "HomeController.h"

@interface DesignationController ()< MFMailComposeViewControllerDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *iconLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *designationTextField;
@property (weak, nonatomic) IBOutlet AutoTimerButton *loginBtn;


@end

@implementation DesignationController
- (IBAction)tapAdminMailGesture:(id)sender {
    if (![MFMailComposeViewController canSendMail]) {
        [[iToast makeText:NSLocalizedString(@"MailSeverFail", nil)] show];
        return;
    }
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:NSLocalizedString(@"AdminMailSubject", nil)];
    NSArray *toRecipients = [NSArray arrayWithObject:@"ilmio@mitsui-designtec.co.jp"];
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:NSLocalizedString(@"AdminMailBody", nil) isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

//暂不登录
- (IBAction)NotLoginGesture:(id)sender {
    NSLog(@"暂不登录");
    if (self.detail.brandName) {
        [self performSegueWithIdentifier:@"GoAppHome" sender:self.detail];
    }

}
- (IBAction)clickLoginBtn:(AutoTimerButton *)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    sender.buttonState = Loading;
    [[DataManager shareDataManager] designation:self.designationTextField.text
                                       Finished:\
    ^(BOOL resualt, int errorCode, NSString *msg){
        if (resualt) {
            if (errorCode == 0) {
                [self performSegueWithIdentifier:@"LoginPush" sender:nil];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickLoginBtn:self.loginBtn];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
}

static CGFloat offsetY;
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBoundsEnd;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBoundsEnd];
    
    if (CGRectGetMaxY(self.loginBtn.frame) > CGRectGetMinY(keyboardBoundsEnd) - 10) {
        offsetY = CGRectGetMinY(self.loginBtn.frame) - CGRectGetMinY(keyboardBoundsEnd) + 10 + CGRectGetHeight(self.loginBtn.frame);
        [self animationChangeFramWith:^{
            self.loginBtn.frame = NHRectSetY(self.loginBtn.frame,
                                                CGRectGetMinY(self.loginBtn.frame) - offsetY);
            self.inputView.frame = NHRectSetY(self.inputView.frame,
                                             CGRectGetMinY(self.inputView.frame) - offsetY);
//            self.iconImg.frame = NHRectSetY(self.iconImg.frame,
//                                              CGRectGetMinY(self.iconImg.frame) - offsetY);
//            self.iconLab.frame = NHRectSetY(self.iconLab.frame,
//                                              CGRectGetMinY(self.iconLab.frame) - offsetY);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (offsetY != 0.0) {
        [self animationChangeFramWith:^{
            self.loginBtn.frame = NHRectSetY(self.loginBtn.frame,
                                             CGRectGetMinY(self.loginBtn.frame) + offsetY);
            self.inputView.frame = NHRectSetY(self.inputView.frame,
                                              CGRectGetMinY(self.inputView.frame) + offsetY);
//            self.iconImg.frame = NHRectSetY(self.iconImg.frame,
//                                            CGRectGetMinY(self.iconImg.frame) + offsetY);
//            self.iconLab.frame = NHRectSetY(self.iconLab.frame,
//                                            CGRectGetMinY(self.iconLab.frame) + offsetY);
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

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            [[iToast makeText:NSLocalizedString(@"MailSendSuc", nil)] show];
            break;
        case MFMailComposeResultSaved:
            [[iToast makeText:NSLocalizedString(@"MailSaveSuc", nil)] show];
            break;
        case MFMailComposeResultFailed:
            [[iToast makeText:NSLocalizedString(@"MailOperateFail", nil)] show];
            break;

        default:
            break;
    }
     [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NHTabBarController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[NHTabBarController class]]) {
        NHNavigationController * homeNav = dest.viewControllers[0];
        HomeController * homeVC = (HomeController*)homeNav.topViewController;
        homeVC.loginDetail = (BrandDetail *)sender;
        
        
    }
}


@end
