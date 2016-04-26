

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DataManager.h"
#import "BrandsModel.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define iOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

@interface AppDelegate ()

@property(nonatomic,strong) NSString *trackViewUrl;

@end

@implementation AppDelegate
- (void)registerPushNotice:(NSDictionary *)launchOptions{
    if(iOS8) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert];
    }
    if (launchOptions) {
        if([self pushNotificationOpen]) {
            NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if (pushNotificationKey) {
                if([UIApplication sharedApplication].applicationIconBadgeNumber>0){
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                }
                //TO DO:
                [[DataManager shareDataManager] setAPNS:pushNotificationKey];
            }
        } else {
            //do nothing...
        }
    } else {
        if([UIApplication sharedApplication].applicationIconBadgeNumber>0){
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    }
}


- (void)checkUpdate{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSError *error;
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/lookup?id=950650546"];
    NSURLRequest *request= [NSURLRequest requestWithURL:url];
    NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dict=  [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSArray *res= [dict objectForKey:@"results"];
    if(res != nil && [res count]){
        NSDictionary *resDict= [res objectAtIndex:0];
        NSString *newVersion = [resDict objectForKey:@"version"];
        self.trackViewUrl=[resDict objectForKey:@"trackViewUrl"];
        if(newVersion != nil && ![newVersion isEqualToString:@""]){
            NSArray *nowArray = [nowVersion componentsSeparatedByString:@"."];
            NSArray *newArray = [newVersion componentsSeparatedByString:@"."];
            
            int nowIntPart = [[nowArray objectAtIndex:0] intValue];
            int nowDecimalPart = [[nowArray objectAtIndex:1] intValue];
            int newIntPart = [[newArray objectAtIndex:0] intValue];
            int newDecimalPart = [[newArray objectAtIndex:1] intValue];
            
            if(newIntPart > nowIntPart || (newIntPart == nowIntPart && newDecimalPart > nowDecimalPart)){
                NSString *message = @"最新バージョンのアプリが公開されています。Appstoreで最新のアプリにアップデートしましょう！";
                UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"アップデートのお知らせ" message:message   delegate:self     cancelButtonTitle:nil otherButtonTitles:@"AppStoreへ", nil ];
                [alert show];
            }
        }
        
        /*if([nowVersion isEqualToString:newVersion]==NO)
         {
         NSString *message=[[NSString alloc] initWithFormat:@"当前版本为%@，最新版本为%@", nowVersion, newVersion];
         UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"检测版本更新" message:message   delegate:self     cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil ];
         [alert show];
         }else{
         UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"检测版本更新" message:@"已经是最新版本了" delegate:self     cancelButtonTitle:@"取消" otherButtonTitles:nil];
         [alert show];
         }*/
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSURL *url= [NSURL URLWithString:@"https://itunes.apple.com/jp/app/ilmio/id950650546?mt=8"];
    [[UIApplication sharedApplication] openURL:url];

}


- (BOOL)pushNotificationOpen
{
    if (iOS8) {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        return (types & UIRemoteNotificationTypeAlert);
    } else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return (types & UIRemoteNotificationTypeAlert);
    }
}
void UncaughtExceptionHandler(NSException *exception)
{
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *urlStr = [NSString stringWithFormat:@"mailto:system2@mitsui-designtec.co.jp?subject=DenKu Bug Report &body=Thanks for your coorperation!"
                        "AppName:ilmio"\
                        "Details:"
                        "%@"
                        "--------------------------"
                        "%@"
                        "---------------------"
                        "%@",
                        name,reason,[arr componentsJoinedByString:@""]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    if ([GMSServices provideAPIKey:@"AIzaSyDKRYjRZ0ag7AQmpY7E51DX-RuN3xpinpQ"]) {
        NSLog(@"google map sucess");
    };
    [GMSServices sharedServices];
    NSLog(@"Open source licenses:\n%@", [GMSServices openSourceLicenseInfo]);
    
    [self registerPushNotice:launchOptions];
    [self checkUpdate];
    [self getBrandModel];
    return YES;
}


-(void)getBrandModel{
    
    
    NSData *udObject = [[NSUserDefaults standardUserDefaults] objectForKey:KBrandsModel];
    NSArray * modelArray = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    if (!modelArray) {
        NSError *error;
        NSURL *url = [NSURL URLWithString:@"http://catalog.livingstyle.jp/apps/iLMiO/brandMaster.json"];
        NSURLRequest *request= [NSURLRequest requestWithURL:url];
        NSData *response=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dict=  [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        if(dict){
            
            NSArray * array=dict[@"brands"];
            NSMutableArray * temprray = [NSMutableArray array];
            for (int i=0; i<array.count; i++) {
                NSDictionary * tempDic = array[i];
                BrandsModel * model = [[BrandsModel alloc]init];
                model.name = tempDic[@"name"];
                model.InteriorPlusCode = tempDic[@"InteriorPlusCode"];
                model.iLMioCode = tempDic[@"iLMioCode"];
                [temprray addObject:model];
            }
            NSData *userObj = [NSKeyedArchiver archivedDataWithRootObject:temprray];
            [[NSUserDefaults standardUserDefaults] setObject:userObj forKey:KBrandsModel];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
    
    
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];

    [[DataManager shareDataManager] setDeviceToken:token];
    NSLog(@"My token is:%@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat:@"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if([UIApplication sharedApplication].applicationIconBadgeNumber>0){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    [[DataManager shareDataManager] setAPNS:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

@end
