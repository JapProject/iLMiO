

#import "NHScrollView.h"

@implementation NHScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewTouchesEnded:withEvent:whichView:)]) {
        [self.delegate scrollViewTouchesEnded:touches withEvent:event whichView:self];
    }
    [super touchesEnded: touches withEvent: event];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
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
