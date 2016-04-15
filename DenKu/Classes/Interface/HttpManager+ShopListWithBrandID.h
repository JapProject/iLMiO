

#import "HttpManager.h"

@interface HttpManager (ShopListWithBrandID)
- (void)shopListWithBrand:(NSString *)brandID Finiehed:(void (^)(BOOL result, int errCode, NSArray *list))block;

@end
