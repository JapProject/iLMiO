

#import <UIKit/UIKit.h>

@protocol NHScrollViewDelegate <UIScrollViewDelegate>

-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)scrollView;

@end

@interface NHScrollView : UIScrollView
@property(nonatomic,assign) id<NHScrollViewDelegate>      delegate;

@end
