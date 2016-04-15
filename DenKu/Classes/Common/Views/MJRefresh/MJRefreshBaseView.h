
#import <UIKit/UIKit.h>


typedef enum {
	MJRefreshStatePulling = 1,
    MJRefreshStateNormal = 2,
	MJRefreshStateRefreshing = 3,
    MJRefreshStateWillRefreshing = 4
} MJRefreshState;

typedef enum {
    MJRefreshViewTypeHeader = -1,
    MJRefreshViewTypeFooter = 1 
} MJRefreshViewType;

@class MJRefreshBaseView;


typedef void (^BeginRefreshingBlock)(MJRefreshBaseView *refreshView);
typedef void (^EndRefreshingBlock)(MJRefreshBaseView *refreshView);
typedef void (^RefreshStateChangeBlock)(MJRefreshBaseView *refreshView, MJRefreshState state);


@protocol MJRefreshBaseViewDelegate <NSObject>
@optional
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView;
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state;
@end

@interface MJRefreshBaseView : UIView
{
    UIEdgeInsets _scrollViewInitInset;
    __weak UIScrollView *_scrollView;
    
    __weak UILabel *_lastUpdateTimeLabel;
	__weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
	__weak UIActivityIndicatorView *_activityView;
    
    MJRefreshState _state;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak, readonly) UILabel *lastUpdateTimeLabel;
@property (nonatomic, weak, readonly) UILabel *statusLabel;
@property (nonatomic, weak, readonly) UIImageView *arrowImage;

@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
@property (nonatomic, copy) RefreshStateChangeBlock refreshStateChangeBlock;
@property (nonatomic, copy) EndRefreshingBlock endStateChangeBlock;
@property (nonatomic, weak) id<MJRefreshBaseViewDelegate> delegate;

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
- (void)beginRefreshing;
- (void)endRefreshing;

- (void)free;


- (void)setState:(MJRefreshState)state;
- (int)totalDataCountInScrollView;
@end