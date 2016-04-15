
#import "AppDelegate.h"
#import "DataManager.h"
#import "DatabaseBase.h"
#import "HttpManager+Designation.h"
#import "HttpManager+Register.h"
#import "HttpManager+RecommendList.h"
#import "HttpManager+Classify.h"
#import "HttpManager+BrandDetail.h"
#import "HttpManager+ShopListWithBrandID.h"
#import "HttpManager+SearchShopWithWords.h"
#import "HttpManager+ShopDetail.h"
#import "HttpManager+SearchBrandWithWords.h"
#import "HttpManager+NewsList.h"
#import "HttpManager+NewsDetail.h"
#import "HttpManager+BrandList.h"
#import "HttpManager+ShopListWithMap.h"
#import "HttpManager+UpdateUserInfo.h"
#import "HttpManager+QRCheck.h"
#import "HttpManager+RefreshUserInfo.h"

NSString * const kUserRankID = @"rankID";
NSString * const kUserBirthday = @"birthday";
NSString * const kUserSex = @"sex";
NSString * const kUserAddress = @"address";
NSString * const kUserClassify = @"classify";
NSString * const kUserNotifyAllow = @"notify";
NSString * const kUserID = @"userID";
NSString * const kUseRankIDChangeNotify = @"UseRankIDChangeNotify";

@interface DataManager ()
@property (nonatomic, strong) NSArray *recommendBrandList;
@property (nonatomic, strong) NSArray *classifyList;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, copy) void (^completeMustDataBlock)();
@property (nonatomic, weak) id<AppMainControllerProtocol> homeController;
@property (nonatomic, strong) NSDictionary *apnsInfo;
@property (nonatomic, weak) id<AppLaunchControllerProtocol> launchController;
@end

@implementation DataManager

static DataManager *manager;

+ (void)initialize
{
    if (self == [DataManager class]) {
        manager = [[DataManager alloc] init];
    }
}

+ (DataManager *)shareDataManager
{
    return manager;
}

- (id)init
{
    if (self = [super init]) {

    }
    return self;
}
- (BOOL)isNeedRegister
{
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    NSString *sex = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSex];
    if (rank.rankID.length > 0 && sex.length > 0) {
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)token
{
    self.deviceID = token;
    if (self.completeMustDataBlock) {
        self.completeMustDataBlock();
        self.completeMustDataBlock = nil;
    }
}

- (void)prepareMustData:(void (^)())block
{
    BOOL isOpenAPNS = [self checkAPNSOpen];
    
    if (self.deviceID || TARGET_IPHONE_SIMULATOR ||
        (isOpenAPNS ? NO : [self.launchController handleAPNSAbnormal:isOpenAPNS])) {
        if (!self.deviceID) {
            self.deviceID = @"";
        }
        block();
    } else {
        self.completeMustDataBlock = block;
    }
}

- (void)setMainController:(id<AppMainControllerProtocol>)homeController
{
    if (!self.homeController) {
        self.homeController = homeController;
        if (self.apnsInfo) {
            [self.homeController handleAPNS:self.apnsInfo];
            self.apnsInfo = nil;
        }
    }
}

- (void)setAPNS:(NSDictionary *)apnsInfo
{
    if (self.homeController) {
        [self.homeController handleAPNS:apnsInfo];
    } else {
        self.apnsInfo = apnsInfo;
    }
}

- (BOOL)getAPNSOpen
{
    if (self.deviceID.length == 0 && !TARGET_IPHONE_SIMULATOR) {
        if ([self checkAPNSOpen]) {
            [(AppDelegate *)[UIApplication sharedApplication].delegate registerPushNotice:nil];
        } else {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isRankExpire
{
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    return [rank isExpire];
}

- (BOOL)isNeedShowGuide
{
    BOOL ret = ![[[NSUserDefaults standardUserDefaults] objectForKey:@"AlreadyShowGuide"] boolValue];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"AlreadyShowGuide"];
    return ret;
}

- (BOOL)checkAPNSOpen
{
    BOOL isOpenAPNS = YES;
    if (CurrentVersion < 8.0) {
        isOpenAPNS = [[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone;
    } else {
        isOpenAPNS = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    return isOpenAPNS;
}

- (void)designation:(NSString *)ranKId Finished:(void (^)(BOOL, int, NSString *))block
{
    [[HttpManager shareHttpManager] designation:ranKId Finished:\
     ^(BOOL resualt, int errorCode, NSString *msg, DesiResualt *result){
         if (resualt && errorCode == 0 && resualt) {
             NSData *rankData = [NSKeyedArchiver archivedDataWithRootObject:result];
             [[NSUserDefaults standardUserDefaults] setObject:rankData forKey:kUserRankID];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         block(resualt, errorCode, msg);
    }];
}

- (void)registerNew:(NSString *)birthday
                And:(NSString *)sex
                And:(NSString *)address
                And:(NSString *)buildingType
                And:(NSString *)notify
           Finished:(void (^)(BOOL, int, NSString *))block
{
    notify = ([self checkAPNSOpen] ? notify : @"1");
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *resualt = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    [[HttpManager shareHttpManager] registerNew:([birthday isEqualToString:@"-    -    -"] ? @"1900-01-01" : birthday)
                                            And:sex
                                            And:(address.length == 0 ? @"未指定" : address)
                                            And:(buildingType.length == 0 ? @"未指定" : buildingType)
                                            And:self.deviceID
                                            And:@"1"
                                            And:notify
                                            And:resualt.rankID
                                       Finished:\
     ^(BOOL resualt, int errorCode, NSString *msg, NSString *userID){
         if (resualt && errorCode == 0) {
             if (![birthday isEqualToString:@"-    -    -"]) {
                 [[NSUserDefaults standardUserDefaults] setObject:birthday forKey:kUserBirthday];
             }
             if (address.length != 0) {
                 [[NSUserDefaults standardUserDefaults] setObject:address forKey:kUserAddress];
             }
             if (buildingType.length != 0) {
                 [[NSUserDefaults standardUserDefaults] setObject:buildingType forKey:kUserClassify];
             }
             [[NSUserDefaults standardUserDefaults] setObject:sex forKey:kUserSex];
             [[NSUserDefaults standardUserDefaults] setObject:notify forKey:kUserNotifyAllow];
             [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserID];

             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         block(resualt, errorCode, msg);
    }];
}

- (void)updateUserINfo:(NSString *)birthday
                   And:(NSString *)sex
                   And:(NSString *)address
                   And:(NSString *)buildingType
                   And:(NSString *)notify
                   And:(NSString *)rankID
              Finished:(void (^)(BOOL resualt, int errorCode, NSString *msg))block
{
//    if (self.deviceID.length == 0 && !TARGET_IPHONE_SIMULATOR && [notify isEqualToString:@"0"]) {
//        block(YES, -1, NSLocalizedString(@"NotifyWaiting", nil));
//    } else {
        [[HttpManager shareHttpManager] updateUserINfo:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]
                                                   And:([birthday isEqualToString:@"-    -    -"] ? @"1900-01-01" : birthday)
                                                   And:sex
                                                   And:(address.length == 0 ? @"未指定" : address)
                                                   And:(buildingType.length == 0 ? @"未指定" : buildingType)
                                                   And:self.deviceID
                                                   And:@"1"
                                                   And:notify
                                                   And:rankID
                                              Finished: \
         ^(BOOL resualt, int errorCode, NSString *msg, DesiResualt *result){
             if (resualt && errorCode == 0 && resualt) {
                 NSData *rankData = [NSKeyedArchiver archivedDataWithRootObject:result];
                 [[NSUserDefaults standardUserDefaults] setObject:rankData forKey:kUserRankID];
                 if (![birthday isEqualToString:@"-    -    -"]) {
                     [[NSUserDefaults standardUserDefaults] setObject:birthday forKey:kUserBirthday];
                 }
                 if (address.length != 0) {
                     [[NSUserDefaults standardUserDefaults] setObject:address forKey:kUserAddress];
                 }
                 if (buildingType.length != 0) {
                     [[NSUserDefaults standardUserDefaults] setObject:buildingType forKey:kUserClassify];
                 }
                 [[NSUserDefaults standardUserDefaults] setObject:sex forKey:kUserSex];
                 [[NSUserDefaults standardUserDefaults] setObject:notify forKey:kUserNotifyAllow];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kUseRankIDChangeNotify object:nil];
             }
             block(resualt, errorCode, msg);
         }];
//    }
}

- (void)recommendListFinished:(void (^)(BOOL result, int errCode, NSArray *list))block
{
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    NSString * rankid = @"-1";
    if (rank) {
        rankid = rank.projectID;
    }
    [[HttpManager shareHttpManager] recommendList:@"recommend" And:rankid Finished:\
    ^(BOOL result, int errCode, NSArray *list){
        self.recommendBrandList = list;
        block(result, errCode, self.recommendBrandList);
    }];
}

- (void)classifyList:(void (^)(BOOL, int, NSArray *))block
{
    if (self.classifyList.count > 0) {
        block(YES, 0, self.classifyList);
        return;
    }
    [[HttpManager shareHttpManager] classifyList:^(BOOL result, int errCode, NSArray *list){
        self.classifyList = list;
        block(result, errCode, self.classifyList);
    }];
}

- (void)brandDetail:(NSString *)brandID Finished:(void (^)(BOOL, int, BrandDetail *))block
{
    if (brandID) {
        NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
        DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
        NSString * rankid = @"";
        if (rank) {
            rankid = rank.rankID;
        }
        [[HttpManager shareHttpManager] brandDetail:brandID And:rankid Finiehed:block];
    } else {
        block(NO, 0, nil);
    }
}

- (void)shopListWithBrand:(NSString *)brandID Finiehed:(void (^)(BOOL, int, NSArray *))block
{
    if (brandID) {
        [[HttpManager shareHttpManager] shopListWithBrand:brandID Finiehed:block];
    } else {
        block(NO, 0, nil);
    }
}

- (void)shopListWith:(NSString *)longitude And:(NSString *)latitude Finished:(void (^)(BOOL result, int errCode, NSArray *list))block
{
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    [[HttpManager shareHttpManager] shopListWith:longitude And:latitude And:rank.projectID Finished:block];
}

- (void)brandList:(NSString *)classifyId Finiehed:(void (^)(BOOL, int, NSArray *))block
{
    if (classifyId) {
        NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
        DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
        [[HttpManager shareHttpManager] brandList:classifyId And:rank.projectID Finiehed:block];
    } else {
        block(NO, 0, nil);
    }
}

- (void)SearchShopWithWords:(NSString *)keyWords Finiehed:(void (^)(BOOL, int, NSArray *))block
{
    if (keyWords) {
        NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
        DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
        [[HttpManager shareHttpManager] SearchShopWithWords:keyWords And:rank.projectID Finiehed:block];
    } else {
        block(NO, 0, nil);
    }
}

- (void)shopDetail:(NSString *)shopID Finiehed:(void (^)(BOOL, int, ShopDetail *))block
{
    if (shopID) {
        [[HttpManager shareHttpManager] shopDetail:shopID Finiehed:block];
    } else {
        block(NO, 0, nil);
    }
}
- (void)SearchBrandWithWords:(NSString *)keyWords Finiehed:(void (^)(BOOL result, int errCode, NSString *msg, NSArray *list))block
{
    if (keyWords) {
        NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
        DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
        [[HttpManager shareHttpManager] SearchBrandWithWords:keyWords And:rank.projectID Finiehed:block];
    } else {
        block(NO, 0, nil, nil);
    }
}

- (void)newsList:(NSString *)page Finished:(void (^)(BOOL, int, NSString *, NSNumber *, NSArray *))block
{
    if (page) {
        [[HttpManager shareHttpManager] newsList:page Finished:block];
    } else {
        block(NO, 0, page, 0, nil);
    }
}
- (void)newsDetail:(NSString *)newsID Finiehed:(void (^)(BOOL result, int errCode, NewsDetail *detail))block
{
    if (newsID) {
        [[HttpManager shareHttpManager] newsDetail:newsID Finiehed:block];
    } else {
        block(NO, 0, nil);
    }
}

- (void)QRcheck:(NSString *)shopID And:(NSString *)branID Finished:(void (^)(BOOL, int, QRResualt *))block
{
    NSString *date = [NSString stringWithFormat:@"%ld", (long)[NSDate date].timeIntervalSince1970];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSString *timeSlot = [NSString stringWithFormat:@"%ld:%ld", (long)[dateComponent hour], (long)[dateComponent minute]];
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    int birYear = 1900;  int birMon = 1;  int birDay = 1;
    NSString *birthday = [[NSUserDefaults standardUserDefaults] objectForKey:kUserBirthday];
    if (birthday) {
        NSArray *tmpArr = [birthday componentsSeparatedByString:@"-"];
        birYear = [tmpArr[0] intValue];
        birMon = [tmpArr[2] intValue];
        birDay = [tmpArr[0] intValue];
    }
    int per = (int)[dateComponent year] - birYear;
    if ([dateComponent month] - birMon < 0 ||
        ([dateComponent month] - birMon == 0 && [dateComponent day] - birDay < 0)) {
        per --;
    }
    NSString *period = [NSString stringWithFormat:@"%d", (per/10)*10];
    NSString *sex = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSex];
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAddress];
    [[HttpManager shareHttpManager] QRCheck:shopID
                                        And:branID
                                        And:date
                                        And:timeSlot
                                        And:rank.rankID
                                        And:period
                                        And:sex
                                        And:(address.length == 0 ? @"未指定" : address)
                                        And:@"アプリ"
                                   Finished:block];
}

- (void)refreshUserInfoFinished:(void (^)(BOOL, int, NSString *))block
{
    NSData *rankData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserRankID];
    DesiResualt *rank = [NSKeyedUnarchiver unarchiveObjectWithData:rankData];
    [[HttpManager shareHttpManager] refreshUserInfo:rank.projectID Finished:\
     ^(BOOL resualt, int errorCode, NSString *msg, DesiResualt *result){
         if (resualt && errorCode == 0 && resualt) {
             NSData *rankData = [NSKeyedArchiver archivedDataWithRootObject:result];
             [[NSUserDefaults standardUserDefaults] setObject:rankData forKey:kUserRankID];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         block(resualt, errorCode, msg);
     }];
}
@end

@implementation DataManager (private)

@end


