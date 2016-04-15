

#import "HttpManager.h"

@interface HttpManager (BrandDetail)
- (void)brandDetail:(NSString *)brandId And:(NSString *)rankID Finiehed:(void (^)(BOOL result, int errCode, BrandDetail *detail))block;

@end
