

#import <Foundation/Foundation.h>
#import "DataModal.h"

FOUNDATION_EXPORT NSString * const kUserRankID;
FOUNDATION_EXPORT NSString * const kUserBirthday;
FOUNDATION_EXPORT NSString * const kUserSex;
FOUNDATION_EXPORT NSString * const kUserAddress;
FOUNDATION_EXPORT NSString * const kUserClassify;
FOUNDATION_EXPORT NSString * const kUserNotifyAllow;
FOUNDATION_EXPORT NSString * const kUseRankIDChangeNotify;


@protocol AppMainControllerProtocol <NSObject>

- (void)handleAPNS:(NSDictionary *)apnsInfo;

@end

@protocol AppLaunchControllerProtocol <NSObject>

- (BOOL)handleAPNSAbnormal:(BOOL)isOpen;

@end

@interface DataManager : NSObject

+ (DataManager *)shareDataManager;

- (BOOL)isNeedRegister;

- (void)setDeviceToken:(NSString *)token;
- (void)prepareMustData:(void (^)())block;

- (void)setMainController:(id<AppMainControllerProtocol>)homeController;
- (void)setLaunchController:(id<AppLaunchControllerProtocol>)launchController;
- (void)setAPNS:(NSDictionary *)apnsInfo;
- (BOOL)getAPNSOpen;
- (BOOL)isRankExpire;
- (BOOL)isNeedShowGuide;

///////
- (void)designation:(NSString *)ranKId
           Finished:(void (^)(BOOL resualt, int errorCode, NSString *msg))block;
- (void)registerNew:(NSString *)birthday
                And:(NSString *)sex
                And:(NSString *)address
                And:(NSString *)buildingType
                And:(NSString *)notify
           Finished:(void (^)(BOOL resualt, int errorCode, NSString *msg))block;
- (void)updateUserINfo:(NSString *)birthday
                   And:(NSString *)sex
                   And:(NSString *)address
                   And:(NSString *)buildingType
                   And:(NSString *)notify
                   And:(NSString *)rankID
           Finished:(void (^)(BOOL resualt, int errorCode, NSString *msg))block;

- (void)recommendListFinished:(void (^)(BOOL result, int errCode, NSArray *list))block;
- (void)classifyList:(void (^)(BOOL result, int errCode, NSArray *classifyList))block;
- (void)brandDetail:(NSString *)brandID Finished:(void (^)(BOOL result, int errCode, BrandDetail *detail))block;
- (void)shopListWithBrand:(NSString *)brandID Finiehed:(void (^)(BOOL result, int errCode, NSArray *list))block;
- (void)shopListWith:(NSString *)longitude And:(NSString *)latitude Finished:(void (^)(BOOL result, int errCode, NSArray *list))block;
- (void)brandList:(NSString *)classifyId Finiehed:(void (^)(BOOL result, int errCode, NSArray *list))block;
- (void)SearchShopWithWords:(NSString *)keyWords Finiehed:(void (^)(BOOL result, int errCode, NSArray *list))block;
- (void)shopDetail:(NSString *)shopID Finiehed:(void (^)(BOOL result, int errCode, ShopDetail *detail))block;
- (void)SearchBrandWithWords:(NSString *)keyWords Finiehed:(void (^)(BOOL result, int errCode, NSString *msg, NSArray *list))block;
- (void)newsList:(NSString *)page Finished:(void (^)(BOOL result, int errCode, NSString *page, NSNumber *totalPage, NSArray *list))block;
- (void)newsDetail:(NSString *)newsID Finiehed:(void (^)(BOOL result, int errCode, NewsDetail *detail))block;
- (void)QRcheck:(NSString *)shopID And:(NSString *)branID Finished:(void (^)(BOOL resualt, int errCode, QRResualt *qrResualt))block;
- (void)refreshUserInfoFinished:(void (^)(BOOL resualt, int errorCode, NSString *msg))block;
@end

@interface DataManager (private)

@end
