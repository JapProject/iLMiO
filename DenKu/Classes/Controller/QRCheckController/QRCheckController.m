

#import "QRCheckController.h"
#import "ZXingObjC/ZXingObjC.h"
#import "CheckResultController.h"
#import "DataManager.h"
#import "HttpManager.h"
#import "BLRView.h"

@interface QRCheckController ()<ZXCaptureDelegate, CheckResultControllerDelegate>
@property (nonatomic, strong) ZXCapture *capture;
@property (weak, nonatomic) IBOutlet UIImageView *scanFrame;
@property (weak, nonatomic) IBOutlet UIButton *backHomeBtn;
@property (weak, nonatomic) IBOutlet UIView *capView;

@property (nonatomic, strong) CheckResultController *resultController;
@end

@implementation QRCheckController
- (IBAction)clickBackHomeBtn:(id)sender {
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    int index = [self.navigationController.viewControllers indexOfObject:self];
//    if (index == 0) {
//        self.tabBarController.tabBar.hidden = NO;
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.capView.bounds;
    self.capture.delegate = self;
    
    self.capture.scanRect = self.scanFrame.frame;
    
    [self.capView.layer insertSublayer:self.capture.layer atIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.capture stop];
    int index = [self.navigationController.viewControllers indexOfObject:self];
    if (index == 0) {
        self.tabBarController.tabBar.hidden = NO;
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.resultController = [[CheckResultController alloc] initWithNibName:@"CheckResultController" bundle:nil];
    self.resultController.delegate = self;
    self.resultController.view.center = self.view.center;
    self.resultController.bgVIew.targetFrame = self.resultController.view.frame;
    self.resultController.bgVIew.parent = self.capView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - CheckResultControllerDelegate
- (void)clickBackTopPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)willDisAppear
{
    ignor = NO;
    [self.resultController removeFromParentViewController];
}

#pragma mark - ZXCaptureDelegate Methods
static BOOL ignor;
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result || ignor) return;
    
    // We got a result. Display information about the result onscreen.
    if (result.text.length > 0) {
        NSDictionary *dic = [[HttpManager shareHttpManager] parserJSON:result.text];
        NSDictionary *qr = dic[@"qr"];
        if ([qr isKindOfClass:[NSDictionary class]]) {
            NSString *shopId = qr[@"Shop_id"];
            NSString *brandId = qr[@"Brand_id"];
            if (shopId.length >0 && brandId.length > 0) {
                ignor = YES;
                [[DataManager shareDataManager] QRcheck:shopId And:brandId Finished:^(BOOL resualt, int errCode, QRResualt *qrResualt){
                    ignor = NO;
                    if (resualt) {
                        if (qrResualt) {
                            ignor = YES;
                            self.resultController.resault = qrResualt;
                            [self.resultController.bgVIew blurWithColor:[BLRColorComponents darkEffect] updateInterval:.3];
                            [self.resultController.bgVIew showWithoutAnimate];
                            [self.view addSubview:self.resultController.view];
                            [self addChildViewController:self.resultController];
                        }
                    } else {
                        [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
                    }
                }];
                // Vibrate
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

            }
        }
    }
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
