

#import "BrandListController.h"
#import "BrandListCell.h"
#import "DataManager.h"
#import "BrandDetailController.h"

@interface BrandListController ()
@property (weak, nonatomic) IBOutlet UITableView *brandTable;
@property (nonatomic, strong) NSArray *list;
@end

@implementation BrandListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.keyWords) {
        self.navigationItem.title = @"クーポン一覧";
        [[DataManager shareDataManager] SearchBrandWithWords:self.keyWords Finiehed:^(BOOL result, int errCode, NSString *msg, NSArray *list){
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            } else {
                if (errCode == 0) {
                    self.list = list;
                    [self.brandTable reloadData];
                } else {
                    [[iToast makeText:msg] show];
                }
            }
        }];
    } else if (self.classifyId) {
        [[DataManager shareDataManager] brandList:self.classifyId Finiehed:^(BOOL result, int errCode, NSArray *list){
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            }
            self.list = list;
            [self.brandTable reloadData];
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandListCell *cell  = (BrandListCell *)[tableView dequeueReusableCellWithIdentifier:@"BrandListCell" forIndexPath:indexPath];
    BrandDetail *detail = self.list[indexPath.row];
    [cell.brandLogo setImageWith:[NSURL URLWithString:[Common imageURLRevise:detail.brandImage]]
                            Json:nil
                           Force:NO
                        SavePath:[NSString stringWithFormat:@"%@%@%@_logo",
                                  [Common tempSavePath],
                                  NSStringFromClass([self class]),
                                  detail.brandId]
                         Default:nil
                    isClipCircle:NO];
    cell.brandName.text = detail.brandName;
    cell.brandNote.text = detail.catName;
    cell.brandDesc.text = detail.discountOutContents;
    if (detail.discountRate.length == 0) {
        cell.brandRate.hidden = YES;
    } else {
        cell.brandRate.hidden = NO;
        cell.brandRate.text = detail.discountRate;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BrandDetail *detail = self.list[indexPath.row];
    [self performSegueWithIdentifier:@"ListToBrandDetail" sender:detail];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BrandDetailController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[BrandDetailController class]]) {
        dest.brandID = ((BrandDetail *)sender).brandId;
    }
}


@end
