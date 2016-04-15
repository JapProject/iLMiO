

#import "Common.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Common
+ (BOOL)authPhoneNumber:(NSString *)phone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:phone];
    BOOL res2 = [regextestcm evaluateWithObject:phone];
    BOOL res3 = [regextestcu evaluateWithObject:phone];
    BOOL res4 = [regextestct evaluateWithObject:phone];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    } else {
        return NO;
    }
    //    if (self.phoneField.text.length != 11) return NO;
    //    NSString *regex = @"^1[3|4|5|8][0-9]\d{4,8}$";
    //
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //
    //    return [pred evaluateWithObject:self.phoneField.text];
}

+ (BOOL)authIdentify:(NSString *)ID
{
    return NO;
}

+ (NSString *)md5:(NSString *)str

{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
}

+ (NSString *)URLEncodedString:(NSString *)content
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (CFStringRef)content,
                                                                     (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                     NULL,
                                                                     kCFStringEncodingUTF8));
}

+ (NSString *)tempSavePath
{
    return NSTemporaryDirectory();
}

+ (UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
    
}

+ (NSString *)imageURLRevise:(NSString *)string
{
    if ([string hasPrefix:@"http://"]) {
        return string;
    } else {
        return [NSString stringWithFormat:@"http://www1099gk.sakura.ne.jp%@", string];//正式服务器
//         return [NSString stringWithFormat:@"http://153.121.37.86/%@", string];//测试服务器
    }
}

+ (CGRect)getFrameWith320WidthFrame:(CGRect)frame
{
    CGAffineTransform captureSizeTransform = \
    CGAffineTransformMakeScale(SCREEN_WIDTH / 320 , SCREEN_WIDTH / 320);
    
    return CGRectApplyAffineTransform(frame, captureSizeTransform);
}

@end


CGRect NHRectSetX(CGRect rect, CGFloat x)
{
    CGRect retRect;
    retRect.origin.x = x;
    retRect.origin.y = CGRectGetMinY(rect);
    retRect.size.width = CGRectGetWidth(rect);
    retRect.size.height = CGRectGetHeight(rect);
    return retRect;
}

CGRect NHRectSetY(CGRect rect, CGFloat y)
{
    CGRect retRect;
    retRect.origin.x = CGRectGetMinX(rect);
    retRect.origin.y = y;
    retRect.size.width = CGRectGetWidth(rect);
    retRect.size.height = CGRectGetHeight(rect);
    return retRect;
}

CGRect NHRectSetWidth(CGRect rect, CGFloat width)
{
    CGRect retRect;
    retRect.origin.x = CGRectGetMinX(rect);
    retRect.origin.y = CGRectGetMinY(rect);
    retRect.size.width = width;
    retRect.size.height = CGRectGetHeight(rect);
    return retRect;
}

CGRect NHRectSetHeight(CGRect rect, CGFloat height)
{
    CGRect retRect;
    retRect.origin.x = CGRectGetMinX(rect);
    retRect.origin.y = CGRectGetMinY(rect);
    retRect.size.width = CGRectGetWidth(rect);
    retRect.size.height = height;
    return retRect;
}