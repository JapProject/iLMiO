//
//  HorseRaceLampView.m
//  PhonePlus
//
//  Created by chengang on 13-12-10.
//  Copyright (c) 2013年 LongMaster Inc. All rights reserved.
//

#import "HorseRaceLampView.h"

@interface HorseRaceLampView ()

@property (nonatomic, retain) UIImageView *backgroundImgView;
@property (nonatomic, retain) UIScrollView *containView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIView *prePage;
@property (nonatomic, retain) UIView *currentPage;
@property (nonatomic, retain) UIView *nextPage;

@end

@implementation HorseRaceLampView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundImgView = \
        [[[UIImageView alloc] initWithFrame:\
          [self rectMakeWith:CGPointZero And:frame.size]] autorelease];
        [self addSubview:self.backgroundImgView];
        
        self.containView = \
        [[[UIScrollView alloc] initWithFrame:\
          [self rectMakeWith:CGPointZero And:frame.size]] autorelease];
        [self addSubview:self.containView];
        self.containView.backgroundColor = [UIColor clearColor];
        self.containView.pagingEnabled = YES;
        self.containView.delegate = self;
        self.containView.userInteractionEnabled = YES;
        self.containView.showsHorizontalScrollIndicator = NO;
        self.containView.showsVerticalScrollIndicator = NO;
        self.containView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        
        self.pageControl = \
        [[[UIPageControl alloc] initWithFrame:CGRectMake(self.containView.frame.origin.x,
                                                         self.containView.frame.origin.y + self.containView.frame.size.height - 20,
                                                         self.containView.frame.size.width, 20.0)] autorelease];
        [self addSubview:self.pageControl];
        self.pageControl.backgroundColor = [UIColor clearColor];
        [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
        [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        CGRect frame = self.frame;
        self.backgroundImgView = \
        [[[UIImageView alloc] initWithFrame:\
          [self rectMakeWith:CGPointZero And:frame.size]] autorelease];
        [self addSubview:self.backgroundImgView];
        
        self.containView = \
        [[[UIScrollView alloc] initWithFrame:\
          [self rectMakeWith:CGPointZero And:frame.size]] autorelease];
        [self addSubview:self.containView];
        self.containView.backgroundColor = [UIColor clearColor];
        self.containView.pagingEnabled = YES;
        self.containView.delegate = self;
        self.containView.userInteractionEnabled = YES;
        self.containView.showsHorizontalScrollIndicator = NO;
        self.containView.showsVerticalScrollIndicator = NO;
        self.containView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        
        self.pageControl = \
        [[[UIPageControl alloc] initWithFrame:CGRectMake(self.containView.frame.origin.x,
                                                         self.containView.frame.origin.y + self.containView.frame.size.height - 20,
                                                         self.containView.frame.size.width, 20.0)] autorelease];
        [self addSubview:self.pageControl];
        self.pageControl.backgroundColor = [UIColor clearColor];
        [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
        [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    }
    return self;
}

- (void)removeFromSuperview
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.delegate = nil;
    [super removeFromSuperview];
}

- (void)dealloc
{
    self.backgroundImgView = nil;
    self.containView = nil;
    self.pageControl = nil;
    self.prePage = nil;
    self.currentPage = nil;
    self.nextPage = nil;
    
    [super dealloc];
}

- (void)reloadData
{
    self.pageControl.numberOfPages = [self.delegate countContent:self];
    self.pageControl.currentPage = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(startIndexPage:)]) {
        self.pageControl.currentPage = [self.delegate startIndexPage:self];
    }
    [self setNeedsLayout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.currentPage) {
        self.pageControl.numberOfPages = [self.delegate countContent:self];
        self.pageControl.currentPage = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(startIndexPage:)]) {
            self.pageControl.currentPage = [self.delegate startIndexPage:self];
        }
        
        self.prePage = [self.delegate createContentView:self];
        self.prePage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = \
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContent)];
        [self.prePage addGestureRecognizer:tap];
        [tap release];
        self.currentPage = [self.delegate createContentView:self];
        self.currentPage.userInteractionEnabled = YES;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(tapContent)];
        [self.currentPage addGestureRecognizer:tap];
        [tap release];
        self.nextPage = [self.delegate createContentView:self];
        self.nextPage.userInteractionEnabled = YES;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(tapContent)];
        [self.nextPage addGestureRecognizer:tap];
        [tap release];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runTimePage) object:nil];
        [self performSelector:@selector(runTimePage) withObject:nil afterDelay:5.0];
        
        [self.containView addSubview:self.prePage];
        [self.containView addSubview:self.currentPage];
        [self.containView addSubview:self.nextPage];
        
        self.containView.contentOffset = CGPointMake(self.containView.frame.size.width, 0);
    }
    
    self.prePage.frame = \
    [self rectMakeWith:CGPointZero And:self.containView.frame.size];
    self.currentPage.frame = \
    [self rectMakeWith:CGPointMake(self.containView.frame.size.width, 0)
                   And:self.containView.frame.size];
    self.nextPage.frame = \
    [self rectMakeWith:CGPointMake(self.containView.frame.size.width * 2, 0)
                   And:self.containView.frame.size];
    
    int currentIndex = (int)self.pageControl.currentPage;
    if (self.pageControl.numberOfPages == 0) {
        return;
    }
    int setIndex = (int)(currentIndex == 0 ? self.pageControl.numberOfPages - 1 : currentIndex - 1);
    [self.delegate refreshContent:self IndexPage:setIndex ContentView:self.prePage];
    [self.delegate refreshContent:self IndexPage:currentIndex ContentView:self.currentPage];
    setIndex = (currentIndex == self.pageControl.numberOfPages - 1 ? 0 : currentIndex + 1);
    [self.delegate refreshContent:self IndexPage:setIndex ContentView:self.nextPage];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    CGRect sourceFrame = self.frame;
    CGRect containFrame = CGRectZero;
    containFrame.origin.x += contentInset.left;
    containFrame.origin.y += contentInset.top;
    containFrame.size.width = \
    sourceFrame.size.width - containFrame.origin.x - contentInset.right;
    containFrame.size.height = \
    sourceFrame.size.height - containFrame.origin.y - contentInset.bottom;
    self.containView.frame = containFrame;
    self.pageControl.frame = CGRectMake(self.containView.frame.origin.x,
                                        self.containView.frame.origin.y + self.containView.frame.size.height - 20,
                                        self.containView.frame.size.width, 20.0);
    self.containView.contentSize = \
    CGSizeMake(self.containView.frame.size.width * 3, self.containView.frame.size.height);
    _contentInset = contentInset;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect sourceFrame = self.frame;
    CGRect containFrame = CGRectZero;
    containFrame.origin.x += _contentInset.left;
    containFrame.origin.y += _contentInset.top;
    containFrame.size.width = \
    sourceFrame.size.width - containFrame.origin.x - _contentInset.right;
    containFrame.size.height = \
    sourceFrame.size.height - containFrame.origin.y - _contentInset.bottom;
    self.containView.frame = containFrame;
    self.pageControl.frame = CGRectMake(self.containView.frame.origin.x,
                                        self.containView.frame.origin.y + self.containView.frame.size.height - 20,
                                        self.containView.frame.size.width, 20.0);
    self.containView.contentSize = \
    CGSizeMake(self.containView.frame.size.width * 3, self.containView.frame.size.height);
}

- (void)setBackgroundImg:(UIImage *)backgroundImg
{
    self.backgroundImgView.image = backgroundImg;
    _backgroundImg = backgroundImg;
}

- (CGRect)rectMakeWith:(CGPoint)point And:(CGSize)size
{
    CGRect rect = CGRectZero;
    rect.origin = point;
    rect.size = size;
    return rect;
}

// 定时器 绑定的方法
- (void)runTimePage
{
    int currentIndex = self.pageControl.currentPage;
    int nextPage = (currentIndex == self.pageControl.numberOfPages - 1 ? 0 : currentIndex + 1);
    self.pageControl.currentPage = nextPage;
    [UIView animateWithDuration:.7 animations:^{
        [self.containView setContentOffset:CGPointMake(self.containView.frame.size.width * 2, 0)];
    }completion:^(BOOL finished){
        [self scrollViewDidEndScrollingAnimation:self.containView];
    }];
//    [self.containView setContentOffset:CGPointMake(self.containView.frame.size.width * 2, 0) animated:YES];
    [self performSelector:@selector(runTimePage) withObject:nil afterDelay:5.0];
}

- (void)tapContent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPage:Index:)]) {
        [self.delegate clickPage:self Index:self.pageControl.currentPage];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runTimePage) object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelector:@selector(runTimePage) withObject:nil afterDelay:5.0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentIndexOfContain = scrollView.contentOffset.x / self.containView.frame.size.width;
    switch (currentIndexOfContain) {
        case 0: {
            int currentIndex = self.pageControl.currentPage;
            currentIndex = (currentIndex == 0 ? self.pageControl.numberOfPages - 1 : currentIndex - 1);
            self.pageControl.currentPage = currentIndex;
            int nextPage = (currentIndex == 0 ? self.pageControl.numberOfPages - 1 : currentIndex - 1);
            UIView *tmpView = self.nextPage;
            self.nextPage = self.currentPage;
            self.nextPage.frame = \
            [self rectMakeWith:CGPointMake(self.containView.frame.size.width * 2, 0)
                           And:self.containView.frame.size];
            self.currentPage = self.prePage;
            self.currentPage.frame = \
            [self rectMakeWith:CGPointMake(self.containView.frame.size.width, 0)
                           And:self.containView.frame.size];
            self.prePage = tmpView;
            self.prePage.frame = \
            [self rectMakeWith:CGPointZero And:self.containView.frame.size];
            [self.delegate refreshContent:self IndexPage:nextPage ContentView:self.prePage];
            self.containView.contentOffset = CGPointMake(self.containView.frame.size.width, 0);
        }
            break;
        case 2: {
            int currentIndex = self.pageControl.currentPage;
            currentIndex = (currentIndex == self.pageControl.numberOfPages - 1 ? 0 : currentIndex + 1);
            self.pageControl.currentPage = currentIndex;
            int nextPage = (currentIndex == self.pageControl.numberOfPages - 1 ? 0 : currentIndex + 1);
            UIView *tmpView = self.prePage;
            self.prePage = self.currentPage;
            self.prePage.frame = \
            [self rectMakeWith:CGPointZero And:self.containView.frame.size];
            self.currentPage = self.nextPage;
            self.currentPage.frame = \
            [self rectMakeWith:CGPointMake(self.containView.frame.size.width, 0)
                           And:self.containView.frame.size];
            self.nextPage = tmpView;
            self.nextPage.frame = \
            [self rectMakeWith:CGPointMake(self.containView.frame.size.width * 2, 0)
                           And:self.containView.frame.size];
            [self.delegate refreshContent:self IndexPage:nextPage ContentView:self.nextPage];
            self.containView.contentOffset = CGPointMake(self.containView.frame.size.width, 0);
        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    UIView *tmpView = self.prePage;
    self.prePage = self.currentPage;
    self.prePage.frame = \
    [self rectMakeWith:CGPointZero And:self.containView.frame.size];
    self.currentPage = self.nextPage;
    self.currentPage.frame = \
    [self rectMakeWith:CGPointMake(self.containView.frame.size.width, 0)
                   And:self.containView.frame.size];
    self.nextPage = tmpView;
    self.nextPage.frame = \
    [self rectMakeWith:CGPointMake(self.containView.frame.size.width * 2, 0)
                   And:self.containView.frame.size];
    int currentIndex = self.pageControl.currentPage;
    if (self.pageControl.numberOfPages == 0) {
        return;
    }
    int nextPage = (currentIndex == self.pageControl.numberOfPages - 1 ? 0 : currentIndex + 1);
    [self.delegate refreshContent:self IndexPage:nextPage ContentView:self.nextPage];
    self.containView.contentOffset = CGPointMake(self.containView.frame.size.width, 0);
}

//#pragma mark -
//#pragma CAAnimationDelegate
//- (void)animationDidStart:(CAAnimation *)anim
//{
//    
//}
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//}

@end
