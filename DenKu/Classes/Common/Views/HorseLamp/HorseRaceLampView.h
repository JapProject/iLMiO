//
//  HorseRaceLampView.h
//  PhonePlus
//
//  Created by chengang on 13-12-10.
//  Copyright (c) 2013年 LongMaster Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorseRaceLampView;

@protocol HorseRaceLampViewDelegate <NSObject>

- (UIView *)createContentView:(HorseRaceLampView *)view;
- (int)countContent:(HorseRaceLampView *)view;
- (void)refreshContent:(HorseRaceLampView *)view IndexPage:(int)index ContentView:(UIView *)content;

@optional
- (int)startIndexPage:(HorseRaceLampView *)view;
- (void)clickPage:(HorseRaceLampView *)view Index:(int)index;

@end

@interface HorseRaceLampView : UIView<UIScrollViewDelegate>
@property (nonatomic, assign) UIImage *backgroundImg;
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) id<HorseRaceLampViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData;
@end
