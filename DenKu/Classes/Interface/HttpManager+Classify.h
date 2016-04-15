

#import "HttpManager.h"

@interface HttpManager (Classify)
- (void)classifyList:(void (^)(BOOL result, int errCode, NSArray *classifyList))block;
@end
