

#import "NHTabBarController.h"
#import "DataManager.h"
#import "SettingListViewController.h"
@interface NHTabBarController ()<UITabBarControllerDelegate>

@end

@implementation NHTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate =self;
    self.tabBar.tintColor = [UIColor yellowColor];
    self.tabBar.shadowImage = [[UIImage alloc] init];
    self.tabBar.clipsToBounds = YES;
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tab_bar_bg"];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NHNavigationController * nav = (NHNavigationController*)viewController;
    if ([nav.topViewController isKindOfClass:[SettingListViewController class]]) {
        //如果没有登录弹出登录
        NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
        DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
        NSString *sex = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSex];
        if (rank.rankID.length > 0 && sex.length > 0) {
            return YES;
        }else{
             [[iToast makeText:NSLocalizedString(@"未ログインの場合は使えません", nil)] show];
            return NO;
        }

    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
