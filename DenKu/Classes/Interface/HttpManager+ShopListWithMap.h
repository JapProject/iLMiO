

#import "HttpManager.h"

@interface HttpManager (ShopListWithMap)
- (void)shopListWith:(NSString *)longitude And:(NSString *)latitude And:(NSString *)rankID Finished:(void (^)(BOOL result, int errCode, NSArray *list))block;

@end
