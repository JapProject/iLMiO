

#import "ShopDetailController.h"
#import "DataManager.h"
#import "AutoDownLoadImageView.h"
#import "BrandDetailController.h"
#import "QRCheckController.h"
#import "MapShopListController.h"

@interface ShopDetailController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (weak, nonatomic) IBOutlet AutoDownLoadImageView *brandLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeTipLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *addressTipLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *telTipLab;
@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@property (weak, nonatomic) IBOutlet UIButton *QRCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *holidayTipLab;
@property (weak, nonatomic) IBOutlet UILabel *holidayLab;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;

@property (nonatomic, strong) ShopDetail *detail;

@end

@implementation ShopDetailController
- (IBAction)clickMapBtn:(id)sender {
    if (self.detail) {
        [self performSegueWithIdentifier:@"GoMap" sender:@[self.detail]];
    }
}
- (IBAction)clickPhoneBtn:(id)sender {
    if (![[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.detail.tel]]]) {
        [[iToast makeText:NSLocalizedString(@"CallPhoneError", nil)] show];
    }
}
- (IBAction)clickBrandBtn:(id)sender {
    [self performSegueWithIdentifier:@"GoBrandDetail" sender:self.detail];
}
- (IBAction)clickQRCkeckBtn:(id)sender {
    [self performSegueWithIdentifier:@"QRCheckGo" sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.shopID) {
        [[DataManager shareDataManager] shopDetail:self.shopID Finiehed:^(BOOL result, int errCode, ShopDetail *detail){
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            }
            self.detail = detail;
            [self reloadContentView];
        }];
    }
    
    self.brandLogo.finishedBlock = ^(UIImage *image) {
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        if (image.size.width / image.size.height >
            CGRectGetWidth(self.contentScroll.frame) / CGRectGetHeight(self.contentScroll.frame)) {
            if (width > CGRectGetWidth(self.contentScroll.frame) - 40) {
                height = (CGRectGetWidth(self.contentScroll.frame) - 40) / width * height;
                width = CGRectGetWidth(self.contentScroll.frame) - 40;
            }
        } else {
            if (height > CGRectGetHeight(self.contentScroll.frame) / 2.5) {
                width = (CGRectGetHeight(self.contentScroll.frame) / 2.5) / height * width;
                height = CGRectGetHeight(self.contentScroll.frame) / 2.5;
            }
        }
        
        self.brandLogo.frame = CGRectMake((CGRectGetWidth(self.contentScroll.frame) - width) / 2,
                                          CGRectGetMinY(self.brandLogo.frame),
                                          width, height);
        [self adjustContentViewFrame];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadContentView
{
    [self.brandLogo setImageWith:[NSURL URLWithString:[Common imageURLRevise:self.detail.brandLogo]]
                            Json:nil
                           Force:NO
                        SavePath:[NSString stringWithFormat:@"%@%@%@_logo",
                                  [Common tempSavePath],
                                  NSStringFromClass([self class]),
                                  self.detail.brandId]
                         Default:nil];
    self.shopNameLab.text = self.detail.shopName;
    self.timeLab.text = (self.detail.openTime.length > 0 ?
                         self.detail.openTime : [NSString stringWithFormat:@"%@-%@", self.detail.openTimeFrom, self.detail.openTimeTo]);
    self.holidayLab.text = self.detail.restDay;
    self.addressLab.text = self.detail.address;
    [self.phoneBtn setTitle:self.detail.tel forState:UIControlStateNormal];
    [self adjustContentViewFrame];
}

- (void)adjustContentViewFrame
{
    self.shopNameLab.frame = NHRectSetY(self.shopNameLab.frame, CGRectGetMaxY(self.brandLogo.frame));
    [self.shopNameLab sizeToFit];
    if (CGRectGetWidth(self.shopNameLab.frame) < CGRectGetWidth(self.contentScroll.frame) - 30) {
        self.shopNameLab.frame = NHRectSetWidth(self.shopNameLab.frame, CGRectGetWidth(self.contentScroll.frame) - 30);
    }
    self.timeTipLab.frame = NHRectSetY(self.timeTipLab.frame,
                                    CGRectGetMaxY(self.shopNameLab.frame) + 25);
    self.timeLab.frame = NHRectSetY(self.timeLab.frame,
                                       CGRectGetMaxY(self.timeTipLab.frame) + 10);
    [self.timeLab sizeToFit];
    if (CGRectGetWidth(self.timeLab.frame) <
        CGRectGetWidth(self.contentScroll.frame) - CGRectGetMinX(self.timeLab.frame) * 2) {
        self.timeLab.frame = \
        NHRectSetWidth(self.timeLab.frame, CGRectGetWidth(self.contentScroll.frame) - CGRectGetMinX(self.timeLab.frame) * 2);
    }
    self.holidayTipLab.frame = NHRectSetY(self.holidayTipLab.frame,
                                          CGRectGetMaxY(self.timeLab.frame) + 10);
    self.holidayLab.frame = NHRectSetY(self.holidayLab.frame,
                                       CGRectGetMaxY(self.holidayTipLab.frame) + 10);
    [self.holidayLab sizeToFit];
    if (CGRectGetWidth(self.holidayLab.frame) <
        CGRectGetWidth(self.contentScroll.frame) - CGRectGetMinX(self.holidayLab.frame) * 2) {
        self.holidayLab.frame = \
        NHRectSetWidth(self.holidayLab.frame, CGRectGetWidth(self.contentScroll.frame) - CGRectGetMinX(self.holidayLab.frame) * 2);
    }
    self.addressTipLab.frame = NHRectSetY(self.addressTipLab.frame,
                                       CGRectGetMaxY(self.holidayLab.frame) + 10);
    if (self.detail.latitude && self.detail.longitude && ![self.detail.address hasPrefix:@"http://"]) {
        self.mapBtn.hidden = NO;
        self.mapBtn.frame = NHRectSetY(self.mapBtn.frame,
                                       CGRectGetMaxY(self.holidayLab.frame) + 10);
    } else {
        self.mapBtn.hidden = YES;
    }

    self.addressLab.frame = NHRectSetY(self.addressLab.frame,
                                          CGRectGetMaxY(self.addressTipLab.frame) + 10);
    [self.addressLab sizeToFit];
    if (CGRectGetWidth(self.addressLab.frame) <
        CGRectGetWidth(self.contentScroll.frame) - CGRectGetMinX(self.addressLab.frame) * 2) {
        self.addressLab.frame = \
        NHRectSetWidth(self.addressLab.frame, CGRectGetWidth(self.contentScroll.frame) - CGRectGetMinX(self.addressLab.frame) * 2);
    }
    self.telTipLab.frame = NHRectSetY(self.telTipLab.frame,
                                       CGRectGetMaxY(self.addressLab.frame) + 10);
    self.phoneBtn.frame = NHRectSetY(self.phoneBtn.frame,
                                      CGRectGetMaxY(self.telTipLab.frame) + 10);
    
    self.QRCheckBtn.frame = NHRectSetY(self.QRCheckBtn.frame,
                                       CGRectGetMaxY(self.phoneBtn.frame) + 15);
    self.brandBtn.frame = NHRectSetY(self.brandBtn.frame,
                                     CGRectGetMaxY(self.phoneBtn.frame) + 15);
    self.contentScroll.contentSize = CGSizeMake(self.contentScroll.contentSize.width,
                                                CGRectGetMaxY(self.brandBtn.frame) + 20);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BrandDetailController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[BrandDetailController class]]) {
        dest.brandID = ((ShopDetail *)sender).brandId;
    } else if ([dest isKindOfClass:[MapShopListController class]]) {
        ((MapShopListController *)dest).tactic = MapInViewOfLast;
        ((MapShopListController *)dest).shopList = sender;
    }
}


@end
