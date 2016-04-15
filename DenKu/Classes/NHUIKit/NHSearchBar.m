

#import "NHSearchBar.h"

@implementation NHSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (CurrentVersion < 7.0) {
        self.tintColor = [UIColor whiteColor];
    }
    
    self.frame = NHRectSetHeight(self.frame, 66);
    NSArray *array = ((UIView *)self.subviews[0]).subviews;
    UITextField *textfield = [array lastObject];
    [textfield addObserver:self forKeyPath:@"frame" options:0x01 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSArray *array = ((UIView *)self.subviews[0]).subviews;
    UITextField *textfield = [array lastObject];
    if (CGRectGetHeight(textfield.frame) < CGRectGetHeight(self.frame) - 16) {
        textfield.frame = NHRectSetHeight(textfield.frame, CGRectGetHeight(self.frame) - 16);
    }
}

- (void)removeFromSuperview
{
    self.frame = NHRectSetHeight(self.frame, 66);
    NSArray *array = ((UIView *)self.subviews[0]).subviews;
    UITextField *textfield = [array lastObject];
    [textfield removeObserver:self forKeyPath:@"frame"];
    [super removeFromSuperview];
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
