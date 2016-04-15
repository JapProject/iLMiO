

#import "HttpManager.h"

@interface HttpManager (UpdateUserInfo)
- (void)updateUserINfo:(NSString *)userID
                   And:(NSString *)birthday
                   And:(NSString *)sex
                   And:(NSString *)address
                   And:(NSString *)buildingType
                   And:(NSString *)deviceID
                   And:(NSString *)deviceType
                   And:(NSString *)pushFlg
                   And:(NSString *)rankID
           Finished:(void (^)(BOOL, int, NSString *, DesiResualt *))block;
@end
