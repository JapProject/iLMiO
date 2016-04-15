

#import "HttpManager.h"

@interface HttpManager (Designation)
- (void)designation:(NSString *)ranKId
           Finished:(void (^)(BOOL resualt, int errorCode, NSString *msg, DesiResualt *result))block;
@end
