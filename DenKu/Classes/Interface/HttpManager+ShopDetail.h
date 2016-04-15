

#import "HttpManager.h"

@interface HttpManager (ShopDetail)
- (void)shopDetail:(NSString *)shopID Finiehed:(void (^)(BOOL result, int errCode, ShopDetail *detail))block;

@end
