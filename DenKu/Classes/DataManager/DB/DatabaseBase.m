

#import "DatabaseBase.h"
#import "DataManager.h"

@implementation DatabaseBase

static FMDatabaseQueue *dbQueue;
static FMDatabasePool  *dbPool;

+ (void)closeDataBase
{
    [dbQueue close];
    [dbPool releaseAllDatabases];
}

+ (void)openDataBase
{
    NSArray *paths = \
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = \
    [documentDirectory stringByAppendingPathComponent:@"DB"];
    dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    dbPool = [[FMDatabasePool alloc] initWithPath:dbPath];
}

- (void)queueInDatabase:(void (^)(FMDatabase *db))block
{
    [dbQueue inDatabase:block];
}

- (void)queueInDatabaseAsyn:(void (^)(FMDatabase *db))block
{
    [dbQueue inDatabaseAsync:block];
}

- (void)queueInTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    [dbQueue inTransaction:block];
}

- (void)queueInTransactionAsync:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    [dbQueue inTransactionAsync:block];
}

- (void)poolInDatabase:(void (^)(FMDatabase *db))block
{
    [dbPool inDatabase:block];
}

- (void)poolInTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    [dbPool inTransaction:block];
}

@end
