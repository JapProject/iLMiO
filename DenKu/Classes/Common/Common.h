

#import <Foundation/Foundation.h>
#import "iToast.h"

@interface Common : NSObject
+ (BOOL)authPhoneNumber:(NSString *)phone;
+ (BOOL)authIdentify:(NSString *)ID;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)URLEncodedString:(NSString *)content;
+ (NSString *)tempSavePath;
+ (UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset;
+ (NSString *)imageURLRevise:(NSString *)string;
+ (CGRect)getFrameWith320WidthFrame:(CGRect)frame;
@end


CG_EXTERN CGRect NHRectSetX(CGRect rect, CGFloat x);
CG_EXTERN CGRect NHRectSetY(CGRect rect, CGFloat y);
CG_EXTERN CGRect NHRectSetWidth(CGRect rect, CGFloat width);
CG_EXTERN CGRect NHRectSetHeight(CGRect rect, CGFloat height);
