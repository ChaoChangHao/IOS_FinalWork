//
//  AppDelegate.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/5/25.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"

#import <MagicalRecord/MagicalRecord.h>




@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Final_Work2"];
//    
//    [Item MR_truncateAll];
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY/MM/dd"];
//    NSDate *startDate = [formatter dateFromString:@"2017/01/01"];
//    NSDate *endDate = [formatter dateFromString:@"2017/12/31"];
//    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
//    NSArray *categoryArray = @[@"食物",@"交通",@"其他",@"娛樂",@"收入"];
//    for (int i = 0; i < 2000; i++) {
//        Item *item = [Item MR_createEntity];
//        item.category = categoryArray[arc4random()%5];
//        item.name = [NSString stringWithFormat:@"test%i",i];
//        item.priceValue = arc4random()%400 + 1;
//        NSTimeInterval randomInterval = random()% (int)interval;
//        
//        item.date = [formatter dateFromString:[formatter stringFromDate:[startDate dateByAddingTimeInterval:randomInterval]]];
//        NSLog(@"%@",item);
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self showRootView];
    
    [self.window makeKeyAndVisible];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        NSLog(@"Yes");
  
        [[NSUserDefaults standardUserDefaults] setInteger:10000 forKey:@"budget"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"startdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everLaunched"];
        NSLog(@"No");
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

- (void)addItem {
//    Item *item = [Item MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
//    item.name = @"FirstName";
//    item.category = @"FirstType";
//    item.priceValue = 30;
//    item.date = [NSDate dateWithTimeIntervalSince1970:0];
//    item.image = @"FirstImage";
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    [MagicalRecord cleanUp];
}




#pragma mark - Private Methods
- (void)showRootView {
    RootViewController* root = [[RootViewController alloc] initWithNibName:@"RootView" bundle:nil];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:root];
    [self.window setRootViewController:navigation];
    
}







@end
