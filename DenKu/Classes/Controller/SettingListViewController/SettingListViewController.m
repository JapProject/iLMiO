//
//  SettingListViewController.m
//  ilmio
//
//  Created by niko on 15/8/10.
//  Copyright (c) 2015年 com.mitsui-designtec. All rights reserved.
//

#import "SettingListViewController.h"
#import "WebViewController.h"

@interface SettingListViewController () <UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    self.titles = @[@"   会員種別",
                    @"   ユーザー情報",
                    @"   通知",
                    @"   利用規約",
                    @"   プライバシーポリシー",
                    @"   ヘルプ"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark -- tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"SettinglistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 1, cell.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [cell addSubview:line];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self performSegueWithIdentifier:@"pushToMyaccout" sender:@""];
        }
            break;
            
        case 1:
        {
            [self performSegueWithIdentifier:@"pushToMyinfoview" sender:@""];
        }
            break;
            
        case 2:
        {
            [self performSegueWithIdentifier:@"pushToNoti" sender:@""];
        }
            break;
            
        case 3:
        {
            [self performSegueWithIdentifier:@"pushtoweb" sender:@"agreement1"];
        }
            break;
            
        case 4:
        {
            [self performSegueWithIdentifier:@"pushtoweb" sender:@"agreement2"];
        }
            break;
            
        case 5:
        {
            [self performSegueWithIdentifier:@"pushtoweb" sender:@"http://www1099gk.sakura.ne.jp/odm/qa.html"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WebViewController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[WebViewController class]]) {
        dest.urlStrng = sender;
    }
}


@end
