

#import "HttpManager.h"

@interface HttpManager (RecommendList)
- (void)recommendList:(NSString *)type And:(NSString *)rankID Finished:(void (^)(BOOL result, int errCode, NSArray *list))block;

@end
