

#ifndef SysConstantDEF_h
#define SysConstantDEF_h

#define DECLARE_SINGLETON_FOR_CLASS(classname) \
+ (classname*)shared##classname;

#define GET_SINGLETON_FOR_CLASS(classname) \
[classname shared##classname]

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}

////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG
#   define NSLog(fmt, ...)  NSLog((@"\n=*={%s}=*=[Line %d]" fmt "\n"), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSLog(fmt, ...)
#endif

////////////////////////////////////////////////////////////////////////////////

#define kNavigationTitleFontSize            [UIFont systemFontOfSize:18]

#define kHTTPRequestTimeOut         60

#define CurrentVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define SCREEN_FRAME [[UIScreen mainScreen] applicationFrame]
#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SIZE         [[UIScreen mainScreen] bounds].size
#define STATUSBAR_HEIGHT    [[UIApplication sharedApplication] statusBarFrame].size.height
#define STATUSBAR_WIDTH     [[UIApplication sharedApplication] statusBarFrame].size.width

#define kColorWithNormalRGB(r, g, b)    [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define KBrandsModel       @"KBrandsModel"

#endif
