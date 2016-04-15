

#import "HttpManager.h"

@interface HttpManager (NewsList)
- (void)newsList:(NSString *)page
        Finished:(void (^)(BOOL result, int errCode, NSString *page, NSNumber *totalPage, NSArray *list))block;
@end
