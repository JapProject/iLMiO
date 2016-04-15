
#import "MJRefreshConst.h"
#import "MJRefreshHeaderView.h"

@interface MJRefreshHeaderView()
@property (nonatomic, strong) NSDate *lastUpdateTime;
@end

@implementation MJRefreshHeaderView

+ (instancetype)header
{
    return [[MJRefreshHeaderView alloc] init];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    [super setScrollView:scrollView];
    
    self.frame = CGRectMake(0, - MJRefreshViewHeight, scrollView.frame.size.width, MJRefreshViewHeight);
    
    self.lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:MJRefreshHeaderTimeKey];
}

- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateTime forKey:MJRefreshHeaderTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateTimeLabel];
}

- (void)updateTimeLabel
{
    if (!_lastUpdateTime) return;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    if ([cmp1 day] == [cmp2 day]) {
        formatter.dateFormat = @"今日 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) {
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:_lastUpdateTime];
    
    _lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最終更新：%@", time];
}

- (void)setState:(MJRefreshState)state
{
    if (_state == state) return;
    
    MJRefreshState oldState = _state;
    
    [super setState:state];
    
	switch (state) {
		case MJRefreshStatePulling:
        {
            _statusLabel.text = MJRefreshHeaderReleaseToRefresh;
            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case MJRefreshStateNormal:
        {
			_statusLabel.text = MJRefreshHeaderPullToRefresh;
            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top;
                _scrollView.contentInset = inset;
            }];
            
            if (MJRefreshStateRefreshing == oldState) {
                self.lastUpdateTime = [NSDate date];
            }
			break;
        }
            
		case MJRefreshStateRefreshing:
        {
            _statusLabel.text = MJRefreshHeaderRefreshing;
            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top + MJRefreshViewHeight;
                _scrollView.contentInset = inset;
                _scrollView.contentOffset = CGPointMake(0, - _scrollViewInitInset.top - MJRefreshViewHeight);
            }];
			break;
        }
            
        default:
            break;
	}
}

- (CGFloat)validY
{
    return _scrollViewInitInset.top;
}

- (int)viewType
{
    return MJRefreshViewTypeHeader;
}
@end