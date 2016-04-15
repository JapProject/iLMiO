

#import "CheckResultController.h"
#import "AutoDownLoadImageView.h"
#import "DataManager.h"
#import "AMBlurView.h"
#import "BLRView.h"
#import "ZXingObjC/ZXingObjC.h"

@interface CheckResultController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrol;
@property (weak, nonatomic) IBOutlet AutoDownLoadImageView *brandImage;
@property (weak, nonatomic) IBOutlet UILabel *QRResultLab;
@property (weak, nonatomic) IBOutlet AutoDownLoadImageView *brandLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopLab;
@property (weak, nonatomic) IBOutlet UIImageView *barCode;
@property (weak, nonatomic) IBOutlet UILabel *onSaleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *desiLab;

@end

@implementation CheckResultController
- (IBAction)clickBackBtn:(id)sender {
    [self.bgVIew hiddenWithoutAnimate];
    [self.view removeFromSuperview];
    
}
- (IBAction)clickBackPageBtn:(id)sender {
    [self.bgVIew hiddenWithoutAnimate];
    [self.view removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBackTopPage)]) {
        [self.delegate clickBackTopPage];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(willDisAppear)]) {
        [self.delegate willDisAppear];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.bgVIew.targetFrame = self.view.frame;

    self.brandLogo.finishedBlock = ^(UIImage *image) {
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        if (image.size.width / image.size.height >
            CGRectGetWidth(self.contentScrol.frame) / CGRectGetHeight(self.contentScrol.frame)) {
            if (width > CGRectGetWidth(self.contentScrol.frame) - 40) {
                height = (CGRectGetWidth(self.contentScrol.frame) - 40) / width * height;
                width = CGRectGetWidth(self.contentScrol.frame) - 40;
            }
        } else {
            if (height > CGRectGetHeight(self.contentScrol.frame) / 2.5) {
                width = (CGRectGetHeight(self.contentScrol.frame) / 2.5) / height * width;
                height = CGRectGetHeight(self.contentScrol.frame) / 2.5;
            }
        }
        
        self.brandLogo.frame = CGRectMake((CGRectGetWidth(self.contentScrol.frame) - width) / 2,
                                          CGRectGetMinY(self.brandLogo.frame),
                                          width, height);
        [self adjustContentViewFrame];
    };
    
//    self.brandImage.finishedBlock = ^(UIImage *image) {
//        CGFloat width = image.size.width;
//        CGFloat height = image.size.height;
//        if (image.size.width / image.size.height >
//            CGRectGetWidth(self.contentScrol.frame) / CGRectGetHeight(self.contentScrol.frame)) {
//            if (width > CGRectGetWidth(self.contentScrol.frame) - 40) {
//                height = (CGRectGetWidth(self.contentScrol.frame) - 40) / width * height;
//                width = CGRectGetWidth(self.contentScrol.frame) - 40;
//            }
//        } else {
//            if (height > CGRectGetHeight(self.contentScrol.frame) / 2.5) {
//                width = (CGRectGetHeight(self.contentScrol.frame) / 2.5) / height * width;
//                height = CGRectGetHeight(self.contentScrol.frame) / 2.5;
//            }
//        }
//        
//        self.brandImage.frame = CGRectMake((CGRectGetWidth(self.contentScrol.frame) - width) / 2,
//                                           CGRectGetMinY(self.brandImage.frame),
//                                          width, height);
//        [self adjustContentViewFrame];
//    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)encodingBarCodeImage
{
    @try {
        NSError *error = nil;
        CGFloat width = (CGRectGetWidth(self.view.frame) - 40);
        CGFloat height = (CGRectGetWidth(self.view.frame) - 40) / 4;
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:self.resault.barCode
                                      format:kBarcodeFormatITF
                                       width:width
                                      height:height
                                       error:&error];
        if (result) {
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            self.barCode.image = [UIImage imageWithCGImage:image];
            self.barCode.frame = NHRectSetWidth(self.barCode.frame, width);
            self.barCode.frame = NHRectSetHeight(self.barCode.frame, height);
        } else {
            NSString *errorMessage = [error localizedDescription];
            [[iToast makeText:errorMessage] show];
        }

    }
    @catch (NSException *exception) {
        [[iToast makeText:NSLocalizedString(@"EncodeBarCodeExpception", nil)] show];
    }
    @finally {
    }
}

- (void)reloadContentView
{
    [self.brandImage setImageWith:[NSURL URLWithString:[Common imageURLRevise:self.resault.brandImage]]
                             Json:nil
                            Force:NO
                         SavePath:[NSString stringWithFormat:@"%@%@%@_QR",
                                   [Common tempSavePath],NSStringFromClass([self class]),self.resault.shopID]
                          Default:nil
                     isClipCircle:YES];
    [self.brandLogo setImageWith:[NSURL URLWithString:[Common imageURLRevise:self.resault.brandLogo]]
                             Json:nil
                            Force:NO
                         SavePath:[NSString stringWithFormat:@"%@%@%@_QRBand",
                                   [Common tempSavePath],NSStringFromClass([self class]),self.resault.shopID]
                          Default:nil
                     isClipCircle:NO];
    self.shopLab.text = self.resault.address;
    self.onSaleLab.text = [NSString stringWithFormat:@"対象商品から%@を割引します。", self.resault.discountRate];
//    [self encodingBarCodeImage];
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *resualt = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    self.desiLab.text = resualt.rankName;
    [self adjustContentViewFrame];
}

- (void)adjustContentViewFrame
{
    
    self.brandLogo.frame = NHRectSetY(self.brandLogo.frame,
                                      CGRectGetMaxY(self.brandImage.frame) + 17.5);
    [self.shopLab sizeToFit];
    if (CGRectGetWidth(self.shopLab.frame) < CGRectGetWidth(self.contentScrol.frame) - 40) {
        self.shopLab.frame = NHRectSetWidth(self.shopLab.frame, CGRectGetWidth(self.contentScrol.frame) - 40);
    }
    self.shopLab.frame = NHRectSetY(self.shopLab.frame,
                                    CGRectGetMaxY(self.brandLogo.frame) + 13.5);
    [self.onSaleLab sizeToFit];
    if (CGRectGetWidth(self.onSaleLab.frame) < CGRectGetWidth(self.contentScrol.frame) - 40) {
        self.onSaleLab.frame = NHRectSetWidth(self.onSaleLab.frame, CGRectGetWidth(self.contentScrol.frame) - 40);
    }
    self.onSaleLab.frame = NHRectSetY(self.onSaleLab.frame,
                                    CGRectGetMaxY(self.shopLab.frame) + 10);
    
//    self.barCode.frame = NHRectSetY(self.barCode.frame,
//                                      CGRectGetMaxY(self.onSaleLab.frame) + 13.5);
    
    self.backBtn.frame = NHRectSetY(self.backBtn.frame,
                                      CGRectGetMaxY(self.onSaleLab.frame) + 13.5);
    self.desiLab.frame = NHRectSetY(self.desiLab.frame,
                                      CGRectGetMaxY(self.backBtn.frame) + 13.5);
    self.contentScrol.contentSize = CGSizeMake(self.contentScrol.contentSize.width,
                                               CGRectGetMaxY(self.desiLab.frame) + 20);
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
