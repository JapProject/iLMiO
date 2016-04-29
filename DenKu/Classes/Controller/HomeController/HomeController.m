

#import "HomeController.h"
#import "DataModal.h"
#import "CellectionCell1.h"
#import "AutoTimerButton.h"
#import "BrandDetailController.h"
#import "BrandListController.h"
#import "BLRView.h"
#import "AutoDownLoadImageButton.h"
#import "ClassfiyTableViewCell.h"
#import "DateRegistController.h"

#import "LaunchingController.h"
#import "DesignationController.h"

@interface HomeController (AppMainController)<AppMainControllerProtocol>

@end

@implementation HomeController (AppMainController)
#pragma mark - AppMainControllerProtocol
- (void)handleAPNS:(NSDictionary *)apnsInfo
{
    self.tabBarController.selectedIndex = 2;
}
@end

@interface HomeController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet BLRView *classifyBgView;
@property (weak, nonatomic) IBOutlet UITableView *classifyTab;
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;
//@property (weak, nonatomic) IBOutlet UILabel *headBrand;
//@property (weak, nonatomic) IBOutlet UILabel *headClassify;
//@property (weak, nonatomic) IBOutlet AutoDownLoadImageButton *headImgView;

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, weak) NSArray *classifyList;
@end

@implementation HomeController
- (IBAction)clickHeadImgBtn:(id)sender {
    if (self.list.count > 0) {
        BrandDetail *detail = self.list[0];
        [self performSegueWithIdentifier:@"BrandDetail" sender:detail];
    }
}
- (IBAction)clickTitleBtn:(id)sender {
    [self hidenClassifyViewWith:^(BOOL finished){
        [self reloadRecommendList];
        [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }];
}

-(id)init{
    if (self = [super init]) {
        self.loginDetail = [[BrandDetail alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRankIDChanged:) name:kUseRankIDChangeNotify object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([[DataManager shareDataManager] isNeedShowGuide]) {
        float width = CGRectGetWidth(self.guideScrollView.frame);
        UIWindow * currentWindow = [UIApplication sharedApplication].keyWindow ;
        [self.guideScrollView removeFromSuperview];
        [currentWindow addSubview:self.guideScrollView];
        self.guideScrollView.hidden = NO;
        self.guideScrollView.contentSize = CGSizeMake(width * (3 + 1), CGRectGetHeight(self.guideScrollView.frame));
        for (int i = 0; i < 3; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, CGRectGetHeight(self.guideScrollView.frame))];
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d", i]];
            [self.guideScrollView addSubview:img];
        }
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(width * 3, 0, width, CGRectGetHeight(self.guideScrollView.frame))];
        tmpView.backgroundColor = [UIColor clearColor];
        [self.guideScrollView addSubview:tmpView];
        
    } else {
        self.guideScrollView.hidden = YES;
    }
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [self.classifyBgView removeFromSuperview];
    self.classifyBgView.parent = self.tabBarController.view;
    self.classifyBgView.frame = NHRectSetHeight(self.classifyBgView.frame, 0);
    self.classifyBgView.targetFrame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64-50);
    [window addSubview:self.classifyBgView];

    [self reloadRecommendList];
    if ([[DataManager shareDataManager] isRankExpire]) {
        DateRegistController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"DateRegistController"];
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[DataManager shareDataManager] setMainController:self];
    if (self.loginDetail.brandName) {
        [self performSegueWithIdentifier:@"BrandDetail" sender:self.loginDetail];
        self.loginDetail = nil;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userRankIDChanged:(id)sender
{
    [self clickTitleBtn:nil];
}

- (void)reloadRecommendList
{
    [[DataManager shareDataManager] recommendListFinished:^(BOOL result, int errCode, NSArray *list){
        if (!result) {
            [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
        }
        if (list.count == 0) {
            self.list = @[[[BrandDetail alloc] init]];
        } else {
            self.list = list;
        }
        [self.collectionView reloadData];
//        if (self.list.count > 0) {
//            BrandDetail *detail = self.list[0];
//            self.headBrand.text = detail.brandName;
//            self.headClassify.text = detail.catName;
//            [self.headImgView setImageWith:[NSURL URLWithString:[Common imageURLRevise:detail.brandImage]]
//                                Json:nil
//                               Force:NO
//                            SavePath:[NSString stringWithFormat:@"%@%@%@",
//                                      [Common tempSavePath],
//                                      NSStringFromClass([self class]),
//                                      detail.brandId]
//                             Default:nil];
//        }
    }];
}

- (void)hidenClassifyViewWith:(void (^)(BOOL finished))completeBlock
{
//    self.classifyList = nil;
//    [self.classifyTab reloadData];
//    [UIView animateWithDuration:.3 animations:^(){
//        self.classifyBgView.frame = CGRectMake(0, CGRectGetMinY(self.classifyBgView.frame),
//                                               CGRectGetWidth(self.view.frame), 0);
//    } completion:completeBlock];
    [self.classifyBgView slideUp];
    completeBlock(YES);
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.classifyList.count % 3 == 0) {
        return self.classifyList.count / 3;
    }
    return self.classifyList.count / 3 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"classfiyCell";
    UINib *nib = [UINib nibWithNibName:@"ClassfiyTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    ClassfiyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell.buttonA addTarget:self action:@selector(classfiyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonB addTarget:self action:@selector(classfiyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonC addTarget:self action:@selector(classfiyClicked:) forControlEvents:UIControlEventTouchUpInside];

    cell.backgroundColor = [UIColor clearColor];
    ClassifyDetail *detail = self.classifyList[indexPath.row * 3];
    cell.buttonA.tag = indexPath.row * 3 + 100;
    [cell.buttonA setTitle:detail.catName forState:UIControlStateNormal];
    if (self.classifyList.count - 1 >= indexPath.row * 3 + 1) {
        detail = self.classifyList[indexPath.row * 3 + 1];
        cell.buttonB.tag = indexPath.row * 3 + 1 + 100;
        [cell.buttonB setTitle:detail.catName forState:UIControlStateNormal];
    }
    else {
        cell.buttonB.tag = 0;
        [cell.buttonB setTitle:nil forState:UIControlStateNormal];
    }
    if (self.classifyList.count - 1 >= indexPath.row * 3 + 2) {
        detail = self.classifyList[indexPath.row * 3 + 2];
        cell.buttonC.tag = indexPath.row * 3 + 2 + 100;
        [cell.buttonC setTitle:detail.catName forState:UIControlStateNormal];
    }
    else {
        cell.buttonC.tag = 0;
        [cell.buttonC setTitle:nil forState:UIControlStateNormal];
    }
    NSInteger rows;
    if (self.classifyList.count % 3 == 0) {
        rows = self.classifyList.count / 3;
    }
    else {
        rows = self.classifyList.count / 3 + 1;
    }
    if (indexPath.row != rows - 1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, cell.frame.size.height - 1, cell.frame.size.width - 30, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        [cell addSubview:lineView];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    header.backgroundColor = [UIColor clearColor];
    return header;
}


- (void)classfiyClicked:(UIButton *)sender {
    
    ClassifyDetail *detail = self.classifyList[sender.tag - 100];
    [self hidenClassifyViewWith:^(BOOL finished){
        [[DataManager shareDataManager] brandList:detail.catId Finiehed:^(BOOL result, int errCode, NSArray *list){
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            }
            if (list.count == 0) {
                self.list = @[[[BrandDetail alloc] init]];
            } else {
                self.list = list;
            }
            [self.collectionView reloadData];
            //            if (self.list.count > 0) {
            //                BrandDetail *detail = self.list[0];
            //                self.headBrand.text = detail.brandName;
            //                self.headClassify.text = detail.catName;
            //                [self.headImgView setImageWith:[NSURL URLWithString:[Common imageURLRevise:detail.brandImage]]
            //                                          Json:nil
            //                                         Force:NO
            //                                      SavePath:[NSString stringWithFormat:@"%@%@%@",
            //                                                [Common tempSavePath],
            //                                                NSStringFromClass([self class]),
            //                                                detail.brandId]
            //                                       Default:nil];
            //            }
        }];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout/UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = CGRectZero;
    switch (indexPath.row) {
        case 0: {
            frame = [Common  getFrameWith320WidthFrame:CGRectMake(0, 0, 210, 120)];
        }
            break;
        case 1: {
            frame = [Common  getFrameWith320WidthFrame:CGRectMake(0, 0, 95, 120)];
        }
            break;
        default: {
            frame = [Common  getFrameWith320WidthFrame:CGRectMake(0, 0, 152.5, 150)];
        }
            break;
    }
    return frame.size;
}
                                                            
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.list ? self.list.count + 1 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandDetail *detail = nil;
    switch (indexPath.row) {
        case 0: {
            detail = self.list[indexPath.row];
        }
            break;
        case 1: {
            return [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection2" forIndexPath:indexPath];
        }
            break;
        default: {
            detail = self.list[indexPath.row - 1];
        }
            break;
    }
    CellectionCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection1" forIndexPath:indexPath];
    if (detail.brandName.length > 0) {
        cell.brandLab.text = detail.brandName;
        cell.brandNameBg.hidden = NO;
    } else {
        cell.brandNameBg.hidden = YES;

    }
//    cell.classifyLab.text = detail.catName;
    [cell.image setImageWith:[NSURL URLWithString:[Common imageURLRevise:detail.brandImage]]
                        Json:nil
                       Force:NO
                    SavePath:[NSString stringWithFormat:@"%@%@%@",
                              [Common tempSavePath],
                              NSStringFromClass([self class]),
                              detail.brandId]
                     Default:nil];
    return cell;
}

- (IBAction)clickClassifyBtn:(AutoTimerButton *)sender {
    //如果没有登录弹出登录
    [[DataManager shareDataManager] prepareMustData:^(){
        if ([[DataManager shareDataManager] isNeedRegister]) {
            [[iToast makeText:NSLocalizedString(@"未ログインの場合は使えません", nil)] show];
            return ;
        }
        else{
            sender.buttonState = Loading;
            [[DataManager shareDataManager] classifyList:^(BOOL result, int errCode, NSArray *list){
                if (!result) {
                    [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
                }
                
                //        [self.classifyBgView blurWithColor:[BLRColorComponents lightEffect] updateInterval:.3f];
                [self.classifyBgView slideDown];
                self.classifyList = list;
                [self.classifyTab reloadData];
                
                //        [UIView animateWithDuration:.3 animations:^(){
                //            self.classifyBgView.frame = CGRectMake(0, CGRectGetMinY(self.classifyBgView.frame),
                //                                                   CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - CGRectGetMinY(self.classifyBgView.frame));
                //        } completion:^(BOOL finished){
                //        }];
                sender.buttonState = Normal;
            }];
        }
    }];

   

 }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BrandDetail *detail = nil;
    switch (indexPath.row) {
        case 0: {
            detail = self.list[indexPath.row];
        }
            break;
        case 1: {
            return;
        }
            break;
        default: {
            detail = self.list[indexPath.row - 1];
        }
            break;
    }

     if (detail.brandName) {
    //如果没有登录弹出登录
    [[DataManager shareDataManager] prepareMustData:^(){
        if ([[DataManager shareDataManager] isNeedRegister]) {
            [self performSegueWithIdentifier:@"GoAppLogin" sender:detail];

           
        }
         return;
    }];
        
         
    }
       if (detail.brandName) {
        [self performSegueWithIdentifier:@"BrandDetail" sender:detail];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BrandDetailController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[BrandDetailController class]]) {
        dest.brandID = ((BrandDetail *)sender).brandId;
        return;
    }
    BrandListController *dest1 = (BrandListController *)dest;
    if ([dest1 isKindOfClass:[BrandListController class]]) {
        dest1.classifyId = ((ClassifyDetail *)sender).catId;
        return;
    }
    
    
    UINavigationController * nav = (UINavigationController *)[segue destinationViewController];
    if ([nav.topViewController isKindOfClass:[DesignationController class]]) {
        DesignationController * des = (DesignationController*)nav.topViewController;
        des.detail = (BrandDetail *)sender;
    }
   
  
}

#pragma mark- scrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offsetX = self.guideScrollView.contentOffset.x;
     int index  = offsetX/CGRectGetWidth(self.guideScrollView.frame);
    if (index > 3 - 1) {
        self.guideScrollView.hidden = YES;
       
    }else{
//        self.guideScrollView.contentOffset =CGPointMake(CGRectGetWidth(self.guideScrollView.frame)*index, 0);
    }
}
@end

