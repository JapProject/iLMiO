

#import "ShopListController.h"
#import "DataManager.h"
#import "BLRView.h"
#import "ShopDetailController.h"

@interface ShopListController ()
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet BLRView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *searchResualtLab;

@property (nonatomic, strong) NSArray *list;

@end

@implementation ShopListController

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
    self.loadingView.parent = self.contentTable;
    self.loadingView.targetFrame = self.loadingView.frame;
    [self.loadingView blurWithColor:[BLRColorComponents darkEffect] updateInterval:.2f];
    [self.loadingView showWithoutAnimate];
    self.navigationItem.title = \
    [NSString stringWithFormat:@"\"%@\"店舗一覧", (self.title ? self.title : @"")];
    if (self.brandID) {
        [[DataManager shareDataManager] shopListWithBrand:self.brandID Finiehed:^(BOOL result, int errCode, NSArray *list){
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            }
            self.list = list;
            [self.contentTable reloadData];
            [self.loadingView hiddenWithoutAnimate];
            self.searchResualtLab.text = [NSString stringWithFormat:@"”%@”で検索した結果 %lu件が該当しました", (self.title ? self.title : @""), (unsigned long)self.list.count];
        }];
    } else if (self.keyWords) {
        [[DataManager shareDataManager] SearchShopWithWords:self.keyWords Finiehed:^(BOOL result, int errCode, NSArray *list){
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            }
            self.list = list;
            [self.contentTable reloadData];
            [self.loadingView hiddenWithoutAnimate];
            self.searchResualtLab.text = [NSString stringWithFormat:@"”%@”で検索した結果 %lu件が該当しました", (self.title ? self.title : @""), (unsigned long)self.list.count];
        }];
    } else {
        [[DataManager shareDataManager] shopListWith:self.longitude And:self.latitude Finished:^(BOOL result, int errCode, NSArray *list){
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            }
            self.list = list;
            [self.contentTable reloadData];
            [self.loadingView hiddenWithoutAnimate];
            self.searchResualtLab.text = [NSString stringWithFormat:@"”%@”で検索した結果 %lu件が該当しました", (self.title ? self.title : @""), (unsigned long)self.list.count];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.loadingView unload];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.contentTable.scrollEnabled = NO;
    self.maskView.hidden = NO;
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentTable.scrollEnabled = YES;
    self.maskView.hidden = YES;
}

- (IBAction)gestureRecognizer:(UIGestureRecognizer *)recognizer
{
    if (![[recognizer view] isKindOfClass:[UITextField class]]) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListCell" forIndexPath:indexPath];
    ShopDetail  *detail = self.list[indexPath.row];
    cell.textLabel.text = detail.shopName;
    cell.detailTextLabel.text = detail.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopDetail  *detail = self.list[indexPath.row];
    [self performSegueWithIdentifier:@"ShopDetail" sender:detail];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (searchBar.text.length > 0) {
        [self.loadingView blurWithColor:[BLRColorComponents darkEffect]];
        [self.loadingView showWithoutAnimate];
        [[DataManager shareDataManager] SearchShopWithWords:searchBar.text Finiehed:^(BOOL result, int errCode, NSArray *list){
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            }
            self.list = list;
            [self.contentTable reloadData];
            [self.loadingView hiddenWithoutAnimate];
            self.title = searchBar.text;
            self.navigationItem.title = \
            [NSString stringWithFormat:@"\"%@\"店舗一覧", (self.title ? self.title : @"")];            self.searchResualtLab.text = [NSString stringWithFormat:@"\"%@\"で検索した結果 %d件が該当しました", (self.title ? self.title : @""), self.list.count];
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ShopDetailController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[ShopDetailController class]]) {
        dest.shopID = ((ShopDetail *)sender).shopID;
    }
}


@end
