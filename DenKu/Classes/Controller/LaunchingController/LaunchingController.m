
#import "LaunchingController.h"
#import "DataManager.h"

@interface LaunchingController ()<AppLaunchControllerProtocol>

@end

@implementation LaunchingController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[DataManager shareDataManager] setLaunchController:self];
    
    //直接进入首页
     [self performSegueWithIdentifier:@"GoAppWithoutLogin" sender:nil];
//    [[DataManager shareDataManager] prepareMustData:^(){
//        if ([[DataManager shareDataManager] isNeedRegister]) {
//            [self performSegueWithIdentifier:@"GoApp" sender:nil];
//        } else {
//            [self performSegueWithIdentifier:@"GoAppWithoutLogin" sender:nil];
//        }
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AppLaunchControllerProtocol
- (BOOL)handleAPNSAbnormal:(BOOL)isOpen
{
    [[iToast makeText:NSLocalizedString(@"NotifyAbnormal", nil)] show];
    return YES;
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
