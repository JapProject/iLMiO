

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

static iToastSettings *sharedSettings = nil;

@interface iToast(private)

- (iToast *) settings;

@end


@implementation iToast
static UIView *view;
static iToast *preToast;
-(void)dealloc{
    [text release];
    [super dealloc];
}

- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}

- (void) show{
    
    if (view) {
        [view removeFromSuperview];
        view = nil;
        [NSObject cancelPreviousPerformRequestsWithTarget:preToast selector:@selector(hideToast) object:nil];
    }
    preToast = self;
	iToastSettings *theSettings = _settings;
	
	if (!theSettings) {
		theSettings = [iToastSettings getSharedSettings];
	}
	
	UIFont *font = [UIFont systemFontOfSize:16];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = text;
    label.textAlignment = 1;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
    [label sizeToFit];
    CGSize textSize = label.frame.size;
    label.frame = CGRectMake(0, 0, textSize.width + 5, textSize.height + 5);
    
	UIButton *v = [[[UIButton alloc] init] autorelease];
	v.frame = CGRectMake(0, 0, textSize.width + 10, textSize.height + 10);
	label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	[v addSubview:label];
	[label release];
	
	v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	v.layer.cornerRadius = 5;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	
	CGPoint point;// = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
	
	if (theSettings.gravity == iToastGravityTop)
	{
		point = CGPointMake(window.frame.size.width / 2, 45);
	}
	else if (theSettings.gravity == iToastGravityBottom) 
	{
        if ([self isKeyboardDisplay]) {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2 - 50);
        } else {
            point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 105);
        }
	}
	else if (theSettings.gravity == iToastGravityCenter) 
	{
		point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2 - 50);
	}
	else
	{
		point = theSettings.postition;
	}
	
	point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
	v.center = point;
	
//	NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/500
//											 target:self selector:@selector(hideToast:)
//										   userInfo:nil repeats:NO];
//	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    [self performSelector:@selector(hideToast) withObject:nil afterDelay:((float)theSettings.duration)/500];
	
	[window addSubview:v];
	
    view = v;
	
//	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (UIView*)findKeyboardView
{
    NSArray* windowList = [[UIApplication sharedApplication] windows];
    for(UIWindow* theWindow in [windowList reverseObjectEnumerator])
    {
        for(UIView* theView in [theWindow subviews])
        {
            if(!strcmp(object_getClassName(theView), "UIPeripheralHostView") ||
               !strcmp(object_getClassName(theView), "UIKeyboard"))
            {
                return theView;
            }
        }
    }
    
    return nil;
}

- (BOOL)isKeyboardDisplay
{
    UIView *keyboard = [self findKeyboardView];
    if (!CGRectIsEmpty(keyboard.frame) && CGRectGetMinY(keyboard.frame) < [[UIScreen mainScreen] bounds].size.height) {
        return YES;
    }
    return NO;
}

- (void)hideToast
{
//	[UIView beginAnimations:nil context:NULL];
//	view.alpha = 0;
//	[UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0;
    }completion:^(BOOL finished){
        [self removeToast:nil];
    }];
}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
    view = nil;
}


+ (iToast *) makeText:(NSString *) _text{
	iToast *toast = [[[iToast alloc] initWithText:_text] autorelease];
	return toast;
}


- (iToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}


+ (iToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityBottom;
		sharedSettings.duration = iToastDurationShort;
	}
	
	return sharedSettings;
	
}

- (id) copyWithZone:(NSZone *)zone{
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

@end