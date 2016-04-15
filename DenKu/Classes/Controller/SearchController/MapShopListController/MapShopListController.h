//
//  MapShopListController.h
//  DenKu
//
//  Created by Mac on 14/11/11.
//  Copyright (c) 2014年 ___ JJs___. All rights reserved.
//

#import "NHViewController.h"

typedef NS_ENUM(NSInteger, MapShowLevelTactic) {
    MapInViewOfList = 0,
    MapInViewOfLast = 1,
    MapInViewOfMyLocal = 2
};

@interface MapShopListController : NHViewController
@property (nonatomic, assign) MapShowLevelTactic tactic;
@property (nonatomic, strong) NSArray *shopList;
@end
