

#import "SearchController.h"
#import "ShopListController.h"
#import "BrandListController.h"
#import "AutoTimerButton.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DataManager.h"
#import "MapShopListController.h"

@interface SearchController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet AutoTimerButton *nearbyBtn;
@property (nonatomic, strong) GMSMapView *mapTool;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) BOOL isWaitingLocation;
@property (nonatomic, assign) int eventCode;
@end

@implementation SearchController
- (IBAction)clickBrandSearchBtn:(id)sender {
//    if (self.searchBar.text.length > 0) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [self performSegueWithIdentifier:@"SearchBrandList" sender:@"hello world"];
//    }
}

- (IBAction)clicnNearbyBtn:(AutoTimerButton *)sender {
    if (self.location) {
        self.isWaitingLocation = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationServiceFailed) object:nil];
        sender.buttonState = Loading;
        NSString *lat = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
        NSString *lon = [NSString stringWithFormat:@"%f", self.location.coordinate.longitude];

        [[DataManager shareDataManager] shopListWith:lon And:lat Finished:^(BOOL result, int errCode, NSArray *list){
            sender.buttonState = Normal;
            if (!result) {
                [[iToast makeText:NSLocalizedString(@"NetWorkFail", nil)] show];
            } else {
                if (list.count == 0) {
                    [[iToast makeText:NSLocalizedString(@"NearbyNoShop", nil)] show];
                } else {
                    if (self == self.navigationController.topViewController) {
                        [self performSegueWithIdentifier:@"MapShopList" sender:list];
                    }
                }
            }
        }];
    } else {
        if ([CLLocationManager locationServicesEnabled]) {
            [self mapFree];
            sender.buttonState = Loading;
            [self createLocationService];
            self.isWaitingLocation = YES;
            [self performSelector:@selector(locationServiceFailed) withObject:nil afterDelay:60];
        } else {
            NSLog(@"location services is %d", [CLLocationManager locationServicesEnabled]);
        }
    }
}

- (void)locationServiceFailed
{
    [[iToast makeText:NSLocalizedString(@"MapFailed", nil)] show];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    if (location) {
        self.location = location;
        if (self.isWaitingLocation) {
            [self clicnNearbyBtn:self.nearbyBtn];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nearbyBtn.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self mapFree];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createLocationService];
}

- (void)mapFree
{
    self.nearbyBtn.buttonState = Normal;
    self.isWaitingLocation = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationServiceFailed) object:nil];
    [self.mapTool removeObserver:self forKeyPath:@"myLocation"];
    [self.mapTool removeFromSuperview];
    self.mapTool = nil;

}

- (void)createLocationService
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:10];
    self.mapTool = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self.mapTool addObserver:self
                   forKeyPath:@"myLocation"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    [self.view addSubview:self.mapTool];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapTool.myLocationEnabled = YES;

    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self mapFree];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0) {
        [self performSegueWithIdentifier:@"SearchShopList" sender:searchBar.text];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *dest = [segue destinationViewController];
    if ([dest isKindOfClass:[ShopListController class]]) {
        if ([sender isKindOfClass:[NSString class]]) {
            ((ShopListController *)dest).keyWords = sender;
            ((ShopListController *)dest).title = sender;
        } else {
            CLLocation *location = sender;
            ((ShopListController *)dest).latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
            ((ShopListController *)dest).longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        }
    } else if ([dest isKindOfClass:[BrandListController class]]) {
        ((BrandListController *)dest).keyWords = sender;
    } else if ([dest isKindOfClass:[MapShopListController class]]) {
        ((MapShopListController *)dest).tactic = MapInViewOfMyLocal;
        ((MapShopListController *)dest).shopList = sender;
    }
}


@end
