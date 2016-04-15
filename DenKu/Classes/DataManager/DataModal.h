

#import <Foundation/Foundation.h>

@interface ClassifyDetail : NSObject
@property (nonatomic, strong) NSString *catId;
@property (nonatomic, strong) NSString *catName;
@property (nonatomic, strong) NSString *catDesc;
@property (nonatomic, strong) NSString *parentId;

+ (ClassifyDetail *)classifyDetailWith:(NSDictionary *)dic;
@end

@interface BrandDetail : NSObject
@property (nonatomic, strong) NSString *brandDesc;
@property (nonatomic, strong) NSString *brandImage;
@property (nonatomic, strong) NSString *brandImage2;
@property (nonatomic, strong) NSString *brandImage3;
@property (nonatomic, strong) NSString *brandNote;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *catId;
@property (nonatomic, strong) NSString *brandLogo;
@property (nonatomic, strong) NSString *siteUrl;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *sortOrder;
@property (nonatomic, strong) NSString *brandTag;
@property (nonatomic, strong) NSString *catName;

@property (nonatomic, strong) NSString *delFlg;
@property (nonatomic, strong) NSString *discountOutContents;
@property (nonatomic, strong) NSString *discountRate;
@property (nonatomic, strong) NSString *expiredDateFrom;
@property (nonatomic, strong) NSString *expiredDateTo;
@property (nonatomic, strong) NSString *insertTime;
@property (nonatomic, strong) NSString *loginID;
@property (nonatomic, strong) NSString *mStatus;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *propertyID;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *QRFlg;

@property (nonatomic, strong) NSString *ecUrl;
@property (nonatomic, strong) NSString *blCode;
@property (nonatomic, strong) NSString *kpCode;
@property (nonatomic, strong) NSString *newsID;
@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSString *newsContent;


+ (BrandDetail *)brandDetailWiht:(NSDictionary *)dic;

@end

@interface ShopDetail : NSObject
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopNote;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *brandLogo;
@property (nonatomic, strong) NSString *creditDestinationId;
@property (nonatomic, strong) NSString *delFlg;
@property (nonatomic, strong) NSString *expiredDateFrom;
@property (nonatomic, strong) NSString *expiredDateTo;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *insertTime;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *loginId;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *openTimeFrom;
@property (nonatomic, strong) NSString *openTimeTo;
@property (nonatomic, strong) NSString *openTime;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *restDay;
@property (nonatomic, strong) NSString *shopDesc;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *targetUserKbnId;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *updateTime;


+ (ShopDetail *)shopDetailWiht:(NSDictionary *)dic;

@end

@interface NewsDetail : NSObject
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *areaRangeId;
@property (nonatomic, strong) NSString *contents;
@property (nonatomic, strong) NSString *delFlg;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *imgPath1;
@property (nonatomic, strong) NSString *imgPath2;
@property (nonatomic, strong) NSString *imgPath3;
@property (nonatomic, strong) NSString *insertTime;
@property (nonatomic, strong) NSString *onlineDate;
@property (nonatomic, strong) NSString *pushFlg;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *supplyId;
@property (nonatomic, strong) NSString *supplyTimeFrom;
@property (nonatomic, strong) NSString *supplyTimeTo;
@property (nonatomic, strong) NSString *targetAge;
@property (nonatomic, strong) NSString *targetSex;
@property (nonatomic, strong) NSString *targetUserKbnId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *sender;


+ (NewsDetail *)newsDetailWith:(NSDictionary *)dic;

@end

@interface QRResualt : NSObject
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *brandID;
@property (nonatomic, strong) NSString *brandLogo;
@property (nonatomic, strong) NSString *brandImage;
@property (nonatomic, strong) NSString *discountRate;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *barCode;

+ (QRResualt *)QRResualtWith:(NSDictionary *)dic;

@end

@interface DesiResualt : NSObject<NSCoding>
@property (nonatomic, strong) NSString *expiredDateFrom;
@property (nonatomic, strong) NSString *expiredDateTo;
@property (nonatomic, strong) NSString *rankID;
@property (nonatomic, strong) NSString *rankName;
@property (nonatomic, strong) NSString *projectID;

+ (DesiResualt *)designationWith:(NSDictionary *)dic;
- (BOOL)isExpire;

@end




