

#import "HttpManager.h"

@interface HttpManager (Register)
- (void)registerNew:(NSString *)birthday
                And:(NSString *)sex
                And:(NSString *)address
                And:(NSString *)buildingType
                And:(NSString *)deviceID
                And:(NSString *)deviceType
                And:(NSString *)pushFlg
                And:(NSString *)rankId
           Finished:(void (^)(BOOL resualt, int errorCode, NSString *msg, NSString *userID))block;

@end
