
#import "HttpManager.h"

@interface HttpManager (SearchBrandWithWords)
- (void)SearchBrandWithWords:(NSString *)keyWords And:(NSString *)rankID Finiehed:(void (^)(BOOL, int, NSString *msg, NSArray *))block;

@end
