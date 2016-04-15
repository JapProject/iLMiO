

#import "HttpManager.h"

@interface HttpManager (ClassifyDetail)
- (void)classifyDetail:(NSString *)classifyId Finiehed:(void (^)(BOOL result, int errCode, NSDictionary *detail))block;
@end
