

#import "NewsListController.h"
#import "DataManager.h"
#import "NewsListCell.h"
#import "MJRefresh.h"
#import "NewsDetailController.h"

@interface NewsListController ()<MJRefreshBaseViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (nonatomic, strong) NSMutableArray *sectionList;
@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSNumber *totalPage;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) MJRefreshFooterView *footer;
@end

@implementation NewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRankIDChanged:) name:kUseRankIDChangeNotify object:nil];
    self.sectionList = [NSMutableArray arrayWithCapacity:10];
    self.newsList = [NSMutableArray arrayWithCapacity:10];
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.contentTable;
    self.header.delegate = self;
    self.footer = [MJRefreshFooterView footer];
    self.footer.scrollView = self.contentTable;
    self.footer.delegate = self;
    [self.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_header free];
    [_footer free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userRankIDChanged:(id)sender
{
    [self.header beginRefreshing];
}

- (void)parseNewsList:(NSArray *)list
{
    assert(list.count > 0);
//    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:10];
//    NSMutableArray *news = [NSMutableArray arrayWithCapacity:10];
//    NSArray *tmpArr = [list sortedArrayUsingComparator:^(NewsDetail *obj1, NewsDetail *obj2){
//        return [obj1.insertTime compare:obj2.insertTime];
//    }];
//    for (int i = 0; i < tmpArr.count; i++) {
//        NewsDetail *detail = tmpArr[i];
//        NSUInteger index = [sections indexOfObjectPassingTest:\
//                            ^(NSString *obj, NSUInteger idx, BOOL *stop){
//                                *stop = [obj isEqualToString:detail.sender];
//                                return *stop;
//                            }];
//        if (index != NSNotFound) {
//            NSMutableArray *list = news[index];
//            [list addObject:detail];
//        } else {
//            NSMutableArray *list = [NSMutableArray arrayWithCapacity:10];
//            [list addObject:detail];
//            [news addObject:list];
//            [sections addObject:detail.sender];
//        }
//    }
    
//    [self.sectionList addObjectsFromArray:sections];
    [self.newsList addObjectsFromArray:list];
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.header) {
        self.page = 0;
        self.totalPage = nil;
    }
    if (refreshView == self.footer && self.totalPage && self.page == [self.totalPage intValue]) {
        [refreshView endRefreshing];
        return;
    }
    
    [[DataManager shareDataManager] newsList:[NSString stringWithFormat:@"%d", self.page + 1]
                                    Finished:\
     ^(BOOL result, int errCode, NSString *page, NSNumber *totalPage, NSArray *list){
         if ([page intValue] != self.page + 1) {
             [refreshView endRefreshing];
             return ;
         }
         if (!result) {
             [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
         }
         if (list.count > 0) {
             self.page = [page intValue];
             if (self.page == 1) {
                 [self.newsList removeAllObjects];
                 [self.sectionList removeAllObjects];
             }
             [self parseNewsList:list];
             self.totalPage = totalPage;
             [self.contentTable reloadData];
         }
         [refreshView endRefreshing];
     }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UILabel *lab = [[UILabel alloc] init];
//    lab.text = [NSString stringWithFormat:@"    %@", self.sectionList[section]];
//    lab.font = [UIFont systemFontOfSize:14];
//    lab.backgroundColor = [UIColor lightGrayColor];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell" forIndexPath:indexPath];
    NewsDetail *detail = self.newsList[indexPath.row];
    cell.timeLab.text = detail.insertTime;
    cell.titleLab.text = detail.title;
    cell.detailLab.text = detail.contents;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsDetail *detail = self.newsList[indexPath.row];
    [self performSegueWithIdentifier:@"NewsDetail" sender:detail];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NewsDetailController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[NewsDetailController class]]) {
        dest.newsID = ((NewsDetail *)sender).ID;
    }
}


@end
