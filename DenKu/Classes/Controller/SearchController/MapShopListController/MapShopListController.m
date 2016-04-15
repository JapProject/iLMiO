//
//  MapShopListController.m
//  DenKu
//
//  Created by Mac on 14/11/11.
//  Copyright (c) 2014年 ___ JJs___. All rights reserved.
//

#import "MapShopListController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DataModal.h"
#import "PicHttpManager.h"
#import "ShopDetailController.h"

@interface Marker : GMSMarker
@property (nonatomic, retain) NSURL *downURL;
@property (nonatomic, retain) NSString *savePath;
@property (nonatomic, retain) NSDictionary *json;
- (void)setIconWith:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path;

@end

@implementation Marker

- (void)setIconWith:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path
{
    removeNotifyForPic(self, self.savePath);
    registerNotifyForPic(self, path, @selector(imageChanged));
    self.downURL = url;
    self.savePath = path;
    
    PicHttpManager *manager = GET_SINGLETON_FOR_CLASS(PicHttpManager);
    UIImage *image = [manager imageWithPath:path];
    if (image) {
        self.icon = image;
        if (isForce) {
            [manager httpForPic:path DownURL:url Json:json];
        }
    } else {
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
            [[NSFileManager defaultManager] createDirectoryAtPath:path
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        [manager httpForPic:path DownURL:url Json:json];
    }
}

- (void)imageChanged
{
    PicHttpManager *manager = GET_SINGLETON_FOR_CLASS(PicHttpManager);
    UIImage *image = [manager imageWithPath:self.savePath];
    if (image) {
        self.icon = image;
    }
}


- (void)dealloc
{
    removeNotifyForPic(self, self.savePath);
}


@end

@interface MapShopListController ()<GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@end

@implementation MapShopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[((ShopDetail *)self.shopList[0]).latitude floatValue]
                                                            longitude:[((ShopDetail *)self.shopList[0]).longitude floatValue]
                                                                 zoom:12];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.view = self.mapView;
    
    NSMutableArray *markers = [NSMutableArray arrayWithCapacity:self.shopList.count];
    for (ShopDetail *detail in self.shopList) {
        Marker *_marker = [[Marker alloc] init];
        _marker.map = self.mapView;
        _marker.userData = detail;
        _marker.title = detail.shopName;
        _marker.snippet = detail.shopNote;
        _marker.position = CLLocationCoordinate2DMake([detail.latitude floatValue], [detail.longitude floatValue]);
        [markers addObject:_marker];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GMSCameraUpdate *update = nil;
        switch (self.tactic) {
            case MapInViewOfLast: {
                Marker *_marker = [markers lastObject];
                update = [GMSCameraUpdate setTarget:_marker.position zoom:17];
            }
                break;
            case MapInViewOfMyLocal: {
                update = [GMSCameraUpdate setTarget:self.mapView.myLocation.coordinate zoom:17];
            }
                break;
            default: {
                GMSCoordinateBounds *bounds;
                for (Marker *_marker in markers) {
                    if (bounds == nil) {
                        bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:_marker.position
                                                                      coordinate:_marker.position];
                    }
                    bounds = [bounds includingCoordinate:_marker.position];
                }
                update =[GMSCameraUpdate fitBounds:bounds
                                       withPadding:30.0f];
            }
                break;
        }

        [self.mapView moveCamera:update];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    if (marker.userData) {
        [self performSegueWithIdentifier:@"MapToShop" sender:marker.userData];
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
