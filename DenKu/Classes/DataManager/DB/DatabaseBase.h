

#import <Foundation/Foundation.h>
#import "FMDB.h"
//#import "SynthesizeSingleton.h"

@interface DatabaseBase : NSObject

+ (void)closeDataBase;
+ (void)openDataBase;
- (void)queueInDatabase:(void (^)(FMDatabase *db))block;
- (void)queueInDatabaseAsyn:(void (^)(FMDatabase *db))block;
- (void)queueInTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)queueInTransactionAsync:(void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)poolInDatabase:(void (^)(FMDatabase *db))block;
- (void)poolInTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

@end
