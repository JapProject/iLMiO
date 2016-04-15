
#import <UIKit/UIKit.h>
typedef enum {
    Normal,
    Loading,
    Timer
}ButtonState;

@interface AutoTimerButton : UIButton
@property (nonatomic, assign) ButtonState buttonState;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
