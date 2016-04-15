

#import "HttpManager.h"

@interface HttpManager (RefreshUserInfo)
- (void)refreshUserInfo:(NSString *)projectID
               Finished:(void (^)(BOOL resualt, int errorCode, NSString *msg, DesiResualt *result))block;
@end
