

#import "HttpManager.h"

@interface HttpManager (SearchShopWithWords)
- (void)SearchShopWithWords:(NSString *)keyWords And:(NSString *)rankID Finiehed:(void (^)(BOOL result, int errCode, NSArray *list))block;

@end
