

#import "HttpManager.h"

@interface HttpManager (BrandList)
- (void)brandList:(NSString *)classifyId And:(NSString *)rankID Finiehed:(void (^)(BOOL result, int errCode, NSArray *list))block;

@end
