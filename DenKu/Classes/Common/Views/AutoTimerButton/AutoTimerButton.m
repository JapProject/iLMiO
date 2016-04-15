

#import "AutoTimerButton.h"

@interface AutoTimerButton ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, assign) int time;
@end

@implementation AutoTimerButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.time = 60;
        self.normalTitle = [self titleForState:UIControlStateNormal];
        self.normalBackgroundColor = self.backgroundColor;
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.loadingView];
        self.loadingView.center = CGPointMake(CGRectGetWidth(self.frame)/2,
                                              CGRectGetHeight(self.frame)/2);
        self.loadingView.alpha = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    self.loadingView.activityIndicatorViewStyle = activityIndicatorViewStyle;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    return self.loadingView.activityIndicatorViewStyle;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        self.normalTitle = [self titleForState:UIControlStateNormal];
    }
    [super setTitle:title forState:state];
}

- (void)setButtonState:(ButtonState)buttonState
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    switch (buttonState) {
        case Normal: {
            self.enabled = YES;
            self.loadingView.alpha = 0;
            [self setTitle:self.normalTitle forState:UIControlStateNormal];
            self.backgroundColor = self.normalBackgroundColor;
        }
            break;
        case Loading: {
            self.enabled = NO;
            [self setTitle:@"" forState:UIControlStateNormal];
            self.loadingView.alpha = 1;
            self.loadingView.center = CGPointMake(CGRectGetWidth(self.frame)/2,
                                                  CGRectGetHeight(self.frame)/2);
            [self.loadingView startAnimating];
        }
            break;
        case Timer: {
            [self setTitle:[NSString stringWithFormat:@"%d", self.time] forState:UIControlStateDisabled];
            self.enabled = NO;
            self.loadingView.alpha = 0;
            self.backgroundColor = [UIColor grayColor];
            [self performSelector:@selector(updateTitle) withObject:nil afterDelay:1.0];
        }
            break;
        default:
            break;
    }
    _buttonState = buttonState;
}
- (void)updateTitle
{
    if (self.time == 0) {
        self.time = 60;
        self.buttonState = Normal;
    } else {
        self.time --;
        [self setTitle:[NSString stringWithFormat:@"%d", self.time] forState:UIControlStateDisabled];
        [self performSelector:@selector(updateTitle) withObject:nil afterDelay:1.0];
    }
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.normalBackgroundColor = nil;
    self.normalTitle = nil;
    self.loadingView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
