

#import "HttpManager.h"

@interface HttpManager (NewsDetail)
- (void)newsDetail:(NSString *)newsID Finiehed:(void (^)(BOOL result, int errCode, NewsDetail *detail))block;
@end
