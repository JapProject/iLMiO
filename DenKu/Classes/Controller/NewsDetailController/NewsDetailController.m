
#import "NewsDetailController.h"
#import "AutoDownLoadImageView.h"
#import "DataManager.h"
#import "HorseRaceLampView.h"

@interface NewsDetailController ()<HorseRaceLampViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrol;
//@property (weak, nonatomic) IBOutlet AutoDownLoadImageView *brandLogo;
@property (weak, nonatomic) IBOutlet HorseRaceLampView *logoHorse;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UITextView *detailText;

@property (nonatomic, strong) NewsDetail *detail;
@end

@implementation NewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logoHorse.delegate = self;
    [[DataManager shareDataManager] newsDetail:self.newsID Finiehed:^(BOOL result, int errCode, NewsDetail *detail){
        if (!result) {
            [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
        }
        self.detail = detail;
//        self.navigationItem.title = self.detail.sender;
        [self reloadContentView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustContentViewFrame
{
    [self.timeLab sizeToFit];
    self.timeLab.frame = NHRectSetX(self.timeLab.frame,
                                     CGRectGetWidth(self.contentScrol.frame) - 15 - CGRectGetWidth(self.timeLab.frame));
    self.timeLab.frame = NHRectSetY(self.timeLab.frame,
                                     CGRectGetMaxY(self.logoHorse.frame) + 10);
    [self.titleLab sizeToFit];
    if (CGRectGetWidth(self.titleLab.frame) < CGRectGetWidth(self.contentScrol.frame) - 30) {
        self.titleLab.frame = NHRectSetWidth(self.titleLab.frame, CGRectGetWidth(self.contentScrol.frame) - 30);
    }
    self.titleLab.frame = NHRectSetY(self.titleLab.frame,
                                    CGRectGetMaxY(self.timeLab.frame) + 25);
    [self.detailLab sizeToFit];
    if (CGRectGetWidth(self.detailLab.frame) < CGRectGetWidth(self.contentScrol.frame) - 30) {
        self.detailLab.frame = NHRectSetWidth(self.detailLab.frame, CGRectGetWidth(self.contentScrol.frame) - 30);
    }
    self.detailLab.frame = NHRectSetY(self.detailLab.frame,
                                     CGRectGetMaxY(self.titleLab.frame) + 8);
    self.contentScrol.contentSize = CGSizeMake(self.contentScrol.contentSize.width,
                                                CGRectGetMaxY(self.detailLab.frame) + 20);
    self.detailText.text = self.detailLab.text;
    self.detailText.frame = CGRectMake(CGRectGetMinX(self.detailLab.frame) - 5, CGRectGetMinY(self.detailLab.frame), self.detailLab.frame.size.width + 10, self.detailLab.frame.size.height + 20.0);
    self.detailLab.hidden = YES;
}

- (void)reloadContentView
{
//    [self.brandLogo setImageWith:[NSURL URLWithString:[Common imageURLRevise:self.detail.imgPath1]]
//                            Json:nil
//                           Force:NO
//                        SavePath:[NSString stringWithFormat:@"%@%@%@_news",
//                                  [Common tempSavePath],
//                                  NSStringFromClass([self class]),
//                                  self.detail.ID]
//                         Default:nil
//                    isClipCircle:YES];
    [self.logoHorse reloadData];
    NSRange range = [self.detail.insertTime rangeOfString:@" "];
    NSString *time = self.detail.insertTime;
    if (range.location != NSNotFound) {
        time = [self.detail.insertTime substringToIndex:range.location];
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    self.timeLab.text = time;
    self.titleLab.text = self.detail.title;
    self.detailLab.text = self.detail.contents;
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
    if (self.detail.imgPath1.length > 0) count ++;
    if (self.detail.imgPath2.length > 0) count ++;
    if (self.detail.imgPath3.length > 0) count ++;
    
    return count;
}

- (void)refreshContent:(HorseRaceLampView *)view IndexPage:(int)index ContentView:(UIView *)content
{
    AutoDownLoadImageView *contentView = (AutoDownLoadImageView *)content;
    NSString *urlString = nil;
    NSString *path = nil;
    switch (index) {
        case 0: {
            urlString = self.detail.imgPath1;
            path = [NSString stringWithFormat:@"%@%@%@_1",
                    [Common tempSavePath],
                    NSStringFromClass([self class]),
                    self.detail.ID];
        }
            break;
        case 1: {
            urlString = self.detail.imgPath2;
            path = [NSString stringWithFormat:@"%@%@%@_2",
                    [Common tempSavePath],
                    NSStringFromClass([self class]),
                    self.detail.ID];
        }
            break;
        default: {
            urlString = self.detail.imgPath3;
            path = [NSString stringWithFormat:@"%@%@%@_3",
                    [Common tempSavePath],
                    NSStringFromClass([self class]),
                    self.detail.ID];
        }
            break;
    }
    [contentView setImageWith:[NSURL URLWithString:[Common imageURLRevise:urlString]]
                         Json:nil
                        Force:NO
                     SavePath:path
                      Default:nil];
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
