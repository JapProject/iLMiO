

#import "BrandDetailController.h"
#import "HorseRaceLampView.h"
#import "AutoDownLoadImageView.h"
#import "DataManager.h"
#import "ShopListController.h"
#import "QRCheckController.h"
#import "AutoTimerButton.h"
#import "NewsDetailController.h"
#import "BrandsModel.h"

@interface UILabel (Copy)
-(BOOL)canBecomeFirstResponder;
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender;
@end

@implementation UILabel (Copy)

-(BOOL)canBecomeFirstResponder
{
    return [self.text hasPrefix:@"クーポンコード："];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

-(void)copy:(id)sender
{
    int end = [self.text rangeOfString:@"\n"].location;
    int start = [self.text rangeOfString:@"クーポンコード："].length;
    if (end != 0 && start != 0 && end > start) {
        NSString *copyString = [self.text substringWithRange:NSMakeRange(start, end - start)];
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = copyString;
    }
}

@end

@interface BrandDetailController ()<HorseRaceLampViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (weak, nonatomic) IBOutlet HorseRaceLampView *horesLamp;
//@property (weak, nonatomic) IBOutlet UILabel *brandLab;
@property (weak, nonatomic) IBOutlet AutoDownLoadImageView *brandLogo;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
@property (weak, nonatomic) IBOutlet AutoTimerButton *QRBtn;
@property (weak, nonatomic) IBOutlet UILabel *labLab;
@property (weak, nonatomic) IBOutlet UILabel *siteLab;
@property (weak, nonatomic) IBOutlet UIView *rateView;
//@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *freeLab;
@property (weak, nonatomic) IBOutlet UIImageView *TextImage;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet UIView *newsView;
@property (weak, nonatomic) IBOutlet UITextView *newsContentView;
@property (strong, nonatomic) IBOutlet UIButton *newsDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *latestNews;
@property (weak, nonatomic) IBOutlet UIButton *newsListButton;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak,nonatomic) IBOutlet UIButton * BrandButton;

@property (nonatomic, strong) BrandDetail *detail;
@end

@implementation BrandDetailController


- (IBAction)detailBrand:(id)sender {
    
    
    NSData *udObject = [[NSUserDefaults standardUserDefaults] objectForKey:KBrandsModel];
    NSArray * modelArray = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"iLMioCode == %d",[self.brandID intValue]];
    NSArray * array = [modelArray filteredArrayUsingPredicate:predicate];
    if (array.count !=0) {
        BrandsModel * model = [array firstObject];
        NSString * InteriorPlusCode = model.InteriorPlusCode;
        NSString *urlString = [NSString stringWithFormat:@"https://dr.cir.io/ur/mJsLkA?brand_id=%@",InteriorPlusCode];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
   
}

- (IBAction)longPressGestureRecognizer:(id)sender {
    [self.bottomLab becomeFirstResponder];
    [[UIMenuController sharedMenuController] setTargetRect:self.bottomLab.frame inView:self.bottomLab.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}
- (IBAction)clickShopBtn:(id)sender {
    if ([self.detail.QRFlg intValue] == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.detail.ecUrl]];
    } else {
        [self performSegueWithIdentifier:@"ShopList" sender:self.detail];
    }
}
- (IBAction)clickQRBtn:(AutoTimerButton *)sender {
    if ([[DataManager shareDataManager] isRankExpire]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"会員期限が切れています。自動更新しますか？"
                                                       delegate:self
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles:@"Cancel", nil];
        [alert show];
    } else {
        [self performSegueWithIdentifier:@"QRCheck" sender:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            self.QRBtn.buttonState = Loading;
            [[DataManager shareDataManager] refreshUserInfoFinished:\
            ^(BOOL resualt, int errorCode, NSString *msg){
                if (resualt) {
                    if (errorCode == 0) {
                        [self performSegueWithIdentifier:@"QRCheck" sender:nil];
                    } else {
                        [[iToast makeText:msg] show];
                    }
                } else {
                    [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
                }
                self.QRBtn.buttonState = Normal;
            }];
        }
            break;
        default:
            
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSData *udObject = [[NSUserDefaults standardUserDefaults] objectForKey:KBrandsModel];
    NSArray * modelArray = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"iLMioCode == %d",[self.brandID intValue]];
    NSArray * array = [modelArray filteredArrayUsingPredicate:predicate];
    if (array.count !=0) {
        self.BrandButton.hidden = YES;
    }else{
        self.BrandButton.hidden = YES;
    }
    
    self.horesLamp.delegate = self;
    [[DataManager shareDataManager] brandDetail:self.brandID Finished:^(BOOL result, int errCode, BrandDetail *detail){
        if (!result) {
            [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
        }
        if (detail) {
            self.detail = detail;
            [self reloadContentView];
        }
    }];
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
                                          CGRectGetMaxY(self.horesLamp.frame) + 20,
                                          width, height);
        [self adjustContentViewFrame];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustContentViewFrame
{
    CGFloat nextY = CGRectGetMaxY(self.brandLogo.frame);
    if (CGRectGetWidth(self.newsView.frame) < CGRectGetWidth(self.contentScroll.frame) - 30) {
        self.newsView.frame = NHRectSetWidth(self.newsView.frame, CGRectGetWidth(self.contentScroll.frame));
    }
    self.newsView.frame = NHRectSetY(self.newsView.frame, nextY + 15);
    nextY = CGRectGetMaxY(self.newsView.frame);
    [self.descLab sizeToFit];
    if (CGRectGetWidth(self.descLab.frame) < CGRectGetWidth(self.contentScroll.frame) - 30) {
        self.descLab.frame = NHRectSetWidth(self.descLab.frame, CGRectGetWidth(self.contentScroll.frame) - 30);
    }
    self.descLab.frame = NHRectSetY(self.descLab.frame, nextY + 15);
    nextY = CGRectGetMaxY(self.descLab.frame);
    self.shopBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - self.shopBtn.frame.size.width / 2, nextY + 10, SCREEN_WIDTH / 2 , SCREEN_WIDTH / 2.0 / 194.0 * 49);
    
    nextY = CGRectGetMaxY(self.shopBtn.frame);
    
    if (!self.QRBtn.hidden && [self.detail.brandName isEqualToString:@"BIC CAMERA"])
    {
        [self.contentScroll addSubview:self.QRBtn];
        self.QRBtn.frame = CGRectMake((SCREEN_WIDTH - self.QRBtn.frame.size.width) / 2 - 5, nextY - 5, self.QRBtn.frame.size.width, self.QRBtn.frame.size.height);
        nextY = CGRectGetMaxY(self.QRBtn.frame) - 15;
    }
    
    if (!self.TextImage.hidden) {
        self.TextImage.frame = NHRectSetY(self.TextImage.frame, nextY + 15);
        nextY = CGRectGetMaxY(self.TextImage.frame);
    }
    self.labLab.frame = NHRectSetY(self.labLab.frame, nextY + 10);
    nextY = CGRectGetMaxY(self.labLab.frame);
    [self.siteLab sizeToFit];
    if (CGRectGetWidth(self.siteLab.frame) < CGRectGetWidth(self.contentScroll.frame) - 30) {
        self.siteLab.frame = NHRectSetWidth(self.siteLab.frame, CGRectGetWidth(self.contentScroll.frame) - 30);
    }
    self.siteLab.frame = NHRectSetY(self.siteLab.frame, nextY + 10);
    nextY = CGRectGetMaxY(self.siteLab.frame);
    
//    self.QRBtn.frame = CGRectMake((SCREEN_WIDTH - self.QRBtn.frame.size.width) / 2, nextY + 10, 109 , 72);
    
    
    
    [self.bottomLab sizeToFit];
    if (CGRectGetWidth(self.bottomLab.frame) < CGRectGetWidth(self.contentScroll.frame) - 30) {
        self.bottomLab.frame = NHRectSetWidth(self.bottomLab.frame, CGRectGetWidth(self.contentScroll.frame));
    }
    self.bottomLab.frame = NHRectSetY(self.bottomLab.frame, self.view.frame.size.height - self.bottomLab.frame.size.height);
    if (!self.QRBtn.hidden && ![self.detail.brandName isEqualToString:@"BIC CAMERA"] && ![self.detail.brandName isEqualToString:@"大塚家具"]) {
        self.QRBtn.frame = NHRectSetY(self.QRBtn.frame, self.bottomLab.frame.origin.y - self.QRBtn.frame.size.height + 2);
    }
//    nextY = CGRectGetMaxY(self.bottomLab.frame);
    if (self.QRBtn.hidden || [self.detail.brandName isEqualToString:@"BIC CAMERA"]){
        self.contentScroll.contentSize = CGSizeMake(self.contentScroll.contentSize.width, nextY + self.bottomLab.frame.size.height);
    }
    else {
        self.contentScroll.contentSize = CGSizeMake(self.contentScroll.contentSize.width, nextY + (self.QRBtn.hidden ? 0 : self.view.frame.size.height - self.QRBtn.frame.origin.y));
    }
    
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
    if (!self.detail.newsContent || [self.detail.newsContent isEqualToString:@""]) {
        self.newsContentView.hidden = YES;
        self.newsDetailButton.hidden = YES;
        self.latestNews.hidden = YES;
        self.newsListButton.hidden = YES;
        self.topLine.hidden = YES;
        self.newsView.frame = CGRectMake(self.newsView.frame.origin.x, self.newsView.frame.origin.y, self.newsView.frame.size.width, 31);
    }
    else {
        self.newsContentView.hidden = NO;
        self.newsDetailButton.hidden = NO;
        self.latestNews.hidden = NO;
        self.newsListButton.hidden = NO;
        self.topLine.hidden = NO;
        self.newsView.frame = CGRectMake(self.newsView.frame.origin.x, self.newsView.frame.origin.y, self.newsView.frame.size.width, 155.0);
        self.newsContentView.text = self.detail.newsContent;
    }
    if (self.detail.discountRate.length == 0) {
        self.rateView.hidden = YES;
    } else {
        self.rateView.hidden = NO;
        NSString *freeText = [self.detail.discountRate stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.freeLab.text = [freeText stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    }
    self.descLab.text = self.detail.brandDesc;
    if ([self.detail.QRFlg intValue] == 1) {
        self.TextImage.hidden = YES;
        self.QRBtn.hidden = YES;
        
        [self.shopBtn setBackgroundImage:[UIImage imageNamed:@"xwebshop_btn"] forState:UIControlStateNormal];
        self.bottomLab.text = [NSString stringWithFormat:@"クーポンコード：%@\n", self.detail.kpCode];

    } else {
        self.TextImage.hidden = YES;
        self.QRBtn.hidden = NO;
    }

    if ([self.detail.brandName isEqualToString:@"BIC CAMERA"]) {
        [self.QRBtn setImage:[UIImage imageNamed:@"biccamera"] forState:UIControlStateNormal];
        [self.QRBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.QRBtn.userInteractionEnabled = NO;
        self.QRBtn.hidden = NO;
        self.QRBtn.frame = NHRectSetHeight(self.QRBtn.frame, 103);
        self.QRBtn.frame = NHRectSetWidth(self.QRBtn.frame, 300);
    }
    if ([self.detail.brandName isEqualToString:@"大塚家具"]) {
        self.QRBtn.userInteractionEnabled = NO;
        self.QRBtn.hidden = YES;
        self.QRBtn.frame = NHRectSetHeight(self.QRBtn.frame, 103);
        self.QRBtn.frame = NHRectSetWidth(self.QRBtn.frame, 300);
    }
    self.siteLab.text = self.detail.discountOutContents;
    
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];

    self.bottomLab.text = [NSString stringWithFormat:@"%@%@", self.bottomLab.text, rank.rankName];
    if (self.detail.blCode.length && [self.detail.blCode intValue] != 0) {
        self.bottomLab.text = [NSString stringWithFormat:@"%@\n(%@)", self.bottomLab.text, self.detail.blCode];
    }
  
    //没有登录
    [[DataManager shareDataManager] prepareMustData:^(){
        if ([[DataManager shareDataManager] isNeedRegister]) {
            self.QRBtn.hidden = YES;
            self.rateView.hidden = YES;
            self.bottomLab.hidden = YES;
            
        }
    }];
    

    [self.horesLamp reloadData];
    [self adjustContentViewFrame];
}

#pragma mark - HorseRaceLampViewDelegate
- (UIView *)createContentView:(HorseRaceLampView *)view
{
    return [[AutoDownLoadImageView alloc] init];
}

- (int)countContent:(HorseRaceLampView *)view
{
    int count = 0;
    if (self.detail.brandImage.length > 0) count ++;
    if (self.detail.brandImage2.length > 0) count ++;
    if (self.detail.brandImage3.length > 0) count ++;

    return count;
}

- (void)refreshContent:(HorseRaceLampView *)view IndexPage:(int)index ContentView:(UIView *)content
{
    AutoDownLoadImageView *contentView = (AutoDownLoadImageView *)content;
    NSString *urlString = nil;
    NSString *path = nil;
    switch (index) {
        case 0: {
            urlString = self.detail.brandImage;
            path = [NSString stringWithFormat:@"%@%@%@_1",
                    [Common tempSavePath],
                    NSStringFromClass([self class]),
                    self.detail.brandId];
        }
            break;
        case 1: {
            urlString = self.detail.brandImage2;
            path = [NSString stringWithFormat:@"%@%@%@_2",
                    [Common tempSavePath],
                    NSStringFromClass([self class]),
                    self.detail.brandId];
        }
            break;
        default: {
            urlString = self.detail.brandImage3;
            path = [NSString stringWithFormat:@"%@%@%@_3",
                    [Common tempSavePath],
                    NSStringFromClass([self class]),
                    self.detail.brandId];
        }
            break;
    }
    [contentView setImageWith:[NSURL URLWithString:[Common imageURLRevise:urlString]]
                         Json:nil
                        Force:NO
                     SavePath:path
                      Default:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ShopListController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[ShopListController class]]) {
        dest.brandID = ((BrandDetail *)sender).brandId;
        dest.title = ((BrandDetail *)sender).brandName;
    }
    if ([dest isKindOfClass:[NewsDetailController class]]) {
        NewsDetailController *newsDetailVC = (NewsDetailController *)dest;
        newsDetailVC.newsID = self.detail.newsID;
    }
}


@end
