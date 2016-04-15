

#import "HttpManager.h"

@interface HttpManager (QRCheck)
- (void)QRCheck:(NSString *)shopId
            And:(NSString *)brandId
            And:(NSString *)date
            And:(NSString *)timeSlot
            And:(NSString *)rankId
            And:(NSString *)period
            And:(NSString *)sex
            And:(NSString *)Address
            And:(NSString *)medium
       Finished:(void (^)(BOOL resualt, int errCode, QRResualt *qrResualt))block;
@end
