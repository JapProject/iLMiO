//
// Copyright (c) 2013 Justin M Fischer
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  UBLRView.m
//  7blur
//
//  Created by JUSTIN M FISCHER on 9/02/13.
//  Copyright (c) 2013 Justin M Fischer. All rights reserved.
//

#import "BLRView.h"
#import "UIImage+ImageEffects.h"

@interface BLRView ()


@property(nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

@end

@implementation BLRView
- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self insertSubview:self.backgroundImageView atIndex:0];
    }
    return self;
}
- (id) initWithCoder:(NSCoder *) aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self insertSubview:self.backgroundImageView atIndex:0];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

+ (BLRView *) load:(UIView *) view {
    BLRView *blur = [[[NSBundle mainBundle] loadNibNamed:@"BLRView" owner:nil options:nil] objectAtIndex:0];
    
    blur.parent = view;
//    blur.location = CGPointMake(0, 64);
    
//    blur.frame = CGRectMake(blur.location.x, -(blur.frame.size.height + blur.location.y), blur.frame.size.width, blur.frame.size.height);
    
    return blur;
}

+ (BLRView *) loadWithLocation:(CGPoint) point parent:(UIView *) view {
    BLRView *blur = [[[NSBundle mainBundle] loadNibNamed:@"BLRView" owner:nil options:nil] objectAtIndex:0];
    
    blur.parent = view;
//    blur.location = point;
    
    blur.frame = CGRectMake(0, 0, blur.frame.size.width, blur.frame.size.height);
    
    return blur;
}

- (void) awakeFromNib {
}

- (void) unload {
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    [self removeFromSuperview];
}

- (void) blurBackground {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)), NO, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -self.parent.frame.origin.x, -self.parent.frame.origin.y);
    CALayer *layer = self.parent.layer;
    [layer renderInContext:context];
    
    //Snapshot finished in 0.051982 seconds.
//    [self.parent drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)) afterScreenUpdates:NO];

    __block UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Blur finished in 0.004884 seconds.
        snapshot = [snapshot applyBlurWithCrop:self.targetFrame
                                        resize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
                                    blurRadius:self.colorComponents.radius
                                     tintColor:self.colorComponents.tintColor
                         saturationDeltaFactor:self.colorComponents.saturationDeltaFactor
                                     maskImage:self.colorComponents.maskImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = snapshot;
        });
    });
}

- (void) blurWithColor:(BLRColorComponents *) components {
    if(self.blurType == KBlurUndefined) {
        
        self.blurType = KStaticBlur;
        self.colorComponents = components;
    }
    
    [self blurBackground];
}

- (void) blurWithColor:(BLRColorComponents *) components updateInterval:(float) interval {
    self.blurType = KLiveBlur;
    self.colorComponents = components;
    
    self.timer = CreateDispatchTimer(interval * NSEC_PER_SEC, 1ull * NSEC_PER_SEC, dispatch_get_main_queue(), ^{[self blurWithColor:components];});
}

dispatch_source_t CreateDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        
        dispatch_resume(timer);
    }
    
    return timer;
}

- (void) slideDown {
    [UIView animateWithDuration:0.25f animations:^{
        
        self.frame = self.targetFrame;
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        if(self.blurType == KStaticBlur) {
            [self blurWithColor:self.colorComponents];
        }
    }];
}
- (void)showWithoutAnimate
{
    self.alpha = 1;
    if(self.blurType == KStaticBlur) {
        [self blurWithColor:self.colorComponents];
    }
}

- (void)hiddenWithoutAnimate
{
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    self.alpha = 0;
}

- (void) slideUp {
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.frame = NHRectSetHeight(self.frame, 0);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
}

@end

@interface BLRColorComponents()
@end

@implementation BLRColorComponents

+ (BLRColorComponents *) lightEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 6;
    components.tintColor = [UIColor colorWithWhite:.8f alpha:.2f];
    components.saturationDeltaFactor = 1.8f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) darkEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:0.0f green:0.0 blue:0.0f alpha:.7f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) coralEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) neonEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

+ (BLRColorComponents *) skyEffect {
    BLRColorComponents *components = [[BLRColorComponents alloc] init];
    
    components.radius = 8;
    components.tintColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:.1f];
    components.saturationDeltaFactor = 3.0f;
    components.maskImage = nil;
    
    return components;
}

// ...

@end
