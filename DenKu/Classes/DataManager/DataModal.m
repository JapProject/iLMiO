

#import "DataModal.h"

@implementation ClassifyDetail

+ (ClassifyDetail *)classifyDetailWith:(NSDictionary *)dic
{
    if (dic) {
        ClassifyDetail *detail = [[ClassifyDetail alloc] init];
        detail.catId = dic[@"cat_id"];
        detail.catName = dic[@"cat_name"];
        detail.catDesc = dic[@"cat_desc"];
        detail.parentId = dic[@"parent_id"];
        return detail;
    }
    return nil;
}

@end


@implementation BrandDetail

+ (BrandDetail *)brandDetailWiht:(NSDictionary *)dic
{
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        BrandDetail *detail = [[BrandDetail alloc] init];
        detail.brandDesc = dic[@"brand_desc"];
        detail.brandImage = dic[@"brand_image"];
        detail.brandImage2 = dic[@"brand_image2"];
        detail.brandImage3 = dic[@"brand_image3"];
        detail.brandNote = dic[@"brand_note"];
        detail.brandName = dic[@"brand_name"];
        detail.catId = dic[@"cat_id"];
        detail.brandLogo = dic[@"brand_logo"];
        detail.siteUrl = dic[@"site_url"];
        detail.brandId = dic[@"brand_id"];
        detail.sortOrder = dic[@"sort_order"];
        detail.brandTag = dic[@"brand_tag"];
        detail.catName = dic[@"cat_name"];
        detail.catName = dic[@"cat_name"];
        
        detail.delFlg = dic[@"del_flg"];
        detail.discountOutContents = dic[@"discount_out_contents"];
        detail.discountRate = dic[@"discount_rate"];
        detail.expiredDateFrom = dic[@"expired_date_from"];
        detail.expiredDateTo = dic[@"expired_date_to"];
        detail.insertTime = dic[@"insert_time"];
        detail.loginID = dic[@"login_id"];
        detail.mStatus = dic[@"m_status"];
        detail.password = dic[@"password"];
        detail.propertyID = dic[@"property_id"];
        detail.updateTime = dic[@"update_time"];
        detail.QRFlg = dic[@"qr_flg"];
        
        detail.ecUrl = dic[@"ec_url"];
        detail.blCode = dic[@"bl_code"];
        detail.kpCode = dic[@"kp_code"];
        
        detail.newsID = dic[@"id"];
        detail.newsTitle = dic[@"title"];
        detail.newsContent = dic[@"contents"];

        return detail;
    }
    return nil;
}

@end

@implementation ShopDetail

+ (ShopDetail *)shopDetailWiht:(NSDictionary *)dic
{
    if (dic) {
        ShopDetail *detail = [[ShopDetail alloc] init];
        detail.shopID = dic[@"shop_id"];
        detail.shopName = dic[@"shop_name"];
        detail.shopNote = dic[@"shop_note"];
        detail.address = dic[@"address"];
        detail.areaId = dic[@"area_id"];
        detail.brandId = dic[@"brand_id"];
        detail.brandLogo = dic[@"brand_logo"];
        detail.creditDestinationId = dic[@"credit_destination_id"];
        detail.delFlg = dic[@"del_flg"];
        detail.expiredDateFrom = dic[@"expired_date_from"];
        detail.expiredDateTo = dic[@"expired_date_to"];
        detail.imgPath = dic[@"img_path"];
        detail.insertTime = dic[@"insert_time"];
        detail.latitude = dic[@"latitude"];
        detail.loginId = dic[@"login_id"];
        detail.longitude = dic[@"longitude"];
        detail.openTimeFrom = dic[@"open_time_from"];
        detail.openTimeTo = dic[@"open_time_to"];
        detail.openTime = dic[@"open_time"];
        detail.password = dic[@"password"];
        detail.restDay = dic[@"rest_day"];
        detail.shopDesc = dic[@"shop_desc"];
        detail.status = dic[@"status"];
        detail.targetUserKbnId = dic[@"target_user_kbn_id"];
        detail.tel = dic[@"tel"];
        detail.updateTime = dic[@"update_time"];

        return detail;
    }
    return nil;
}

@end


@implementation NewsDetail

+ (NewsDetail *)newsDetailWith:(NSDictionary *)dic
{
    if (dic) {
        NewsDetail *detail = [[NewsDetail alloc] init];
        detail.areaId = dic[@"area_id"];
        detail.areaRangeId = dic[@"area_range_id"];
        detail.contents = dic[@"contents"];
        detail.delFlg = dic[@"del_flg"];
        detail.ID = dic[@"id"];
        detail.imgPath1 = dic[@"img_path1"];
        detail.imgPath2 = dic[@"img_path2"];
        detail.imgPath3 = dic[@"img_path3"];
        detail.insertTime = dic[@"insert_time"];
        detail.onlineDate = dic[@"online_date"];
        detail.pushFlg = dic[@"push_flg"];
        detail.status = dic[@"status"];
        detail.supplyId = dic[@"supply_id"];
        detail.supplyTimeFrom = dic[@"supply_time_from"];
        detail.supplyTimeTo = dic[@"supply_time_to"];
        detail.targetAge = dic[@"target_age"];
        detail.targetSex = dic[@"target_sex"];
        detail.targetUserKbnId = dic[@"target_user_kbn_id"];
        detail.title = dic[@"title"];
        detail.updateTime = dic[@"update_time"];
        detail.sender = dic[@"sender"];
        
        return detail;
    }
    return nil;
}

@end


@implementation QRResualt

+ (QRResualt *)QRResualtWith:(NSDictionary *)dic
{
    if (dic) {
        QRResualt *resualt = [[QRResualt alloc] init];
        resualt.shopID = dic[@"shop_id"];
        resualt.brandID = dic[@"brand_id"];
        resualt.brandLogo = dic[@"brand_logo"];
        resualt.brandImage = dic[@"brand_image"];
        resualt.discountRate = dic[@"discount_rate"];
        resualt.address = dic[@"address"];
        resualt.barCode = dic[@"barcode"];
        
        return resualt;
    }
    return nil;
}

@end


@implementation DesiResualt

+ (DesiResualt *)designationWith:(NSDictionary *)dic
{
    if (dic) {
        DesiResualt *resualt = [[DesiResualt alloc] init];
        resualt.expiredDateFrom = dic[@"expired_date_from"];
        resualt.expiredDateTo = dic[@"expired_date_to"];
        resualt.rankID = dic[@"rank_id"];
        resualt.rankName = dic[@"rank_name"];
        resualt.projectID = dic[@"id"];
        
        long long dateFrom = [resualt.expiredDateFrom longLongValue];
        if (dateFrom > 1000000000) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            formatter.dateFormat = @"yyyy-MM-dd";
           resualt.expiredDateFrom = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateFrom]];
        }
        long long dateTo = [resualt.expiredDateTo longLongValue];
        if (dateTo > 1000000000) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            formatter.dateFormat = @"yyyy-MM-dd";
            resualt.expiredDateTo = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:dateTo]];
        }
        
        return resualt;
    }
    return nil;
}

- (BOOL)isExpire
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *expiredDateFrom = [formatter dateFromString:self.expiredDateFrom];
    NSDate *expiredDateTo = [formatter dateFromString:self.expiredDateTo];
    if ([expiredDateFrom timeIntervalSince1970] <= [[NSDate date] timeIntervalSince1970] &&
        [expiredDateTo timeIntervalSince1970] >= [[NSDate date] timeIntervalSince1970]) {
        return NO;
    }
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.expiredDateFrom forKey:@"expired_date_from"];
    [aCoder encodeObject:self.expiredDateTo forKey:@"expired_date_to"];
    [aCoder encodeObject:self.rankID forKey:@"rank_id"];
    [aCoder encodeObject:self.rankName forKey:@"rank_name"];
    [aCoder encodeObject:self.projectID forKey:@"id"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.expiredDateFrom = [aDecoder decodeObjectForKey:@"expired_date_from"];
        self.expiredDateTo = [aDecoder decodeObjectForKey:@"expired_date_to"];
        self.rankID = [aDecoder decodeObjectForKey:@"rank_id"];
        self.rankName = [aDecoder decodeObjectForKey:@"rank_name"];
        self.projectID = [aDecoder decodeObjectForKey:@"id"];
    }
    return self;
}

@end



