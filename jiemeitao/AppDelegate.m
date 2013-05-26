//
//  AppDelegate.m
//  jiemeitao
//
//  Created by tangyong on 13-5-23.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "AppDelegate.h"

#import "IndexViewController.h"
#import "PersonalViewController.h"
#import <APNSMsgPresentViewController.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    IndexViewController *ic = [[IndexViewController alloc]initWithNibName:@"IndexViewController" bundle:nil];
    PersonalViewController *pc = [[PersonalViewController alloc]initWithNibName:@"PersonalViewController" bundle:nil];
    UINavigationController *nc1 = [[UINavigationController alloc]initWithRootViewController:ic];
    UINavigationController *nc2 = [[UINavigationController alloc]init];
    UINavigationController *nc3 = [[UINavigationController alloc]initWithRootViewController:pc];
    
    OBTabBarController *oc = [[OBTabBarController alloc]initWithViewControllers:@[nc1, nc2, nc3] delegate:self];
    self.window.rootViewController = oc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


- (NSString *)deviceTokenStringFromTokenData:(NSData *)deviceToken
{
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Data From Remove Notification: %@:", userInfo);
    NSString *topic_id = userInfo[@"topic_id"];
    if (topic_id) {
        /** msg **/
        [[APNSMsgManager sharedInstance]presentModalViewControllerWith:topic_id];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [self deviceTokenStringFromTokenData:deviceToken];
    NSLog(@"Device Token is: %@", deviceTokenString);
    
    // Toyawork's iPhone:
    
    
    // todo: 这个地方把token发给服务器
    //    [self sendProviderDeviceToken:devTokenBytes]; // custom method
    
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}



#pragma obtabbarcontroller delegate
- (UIImage *)imageTabAtIndex:(NSUInteger)index
{
    NSArray *images = @[
                        [UIImage imageNamed:@"tab-bar_01-nor"],
                        [[UIImage imageNamed:@"tab-bar_02-nor"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f],
                        [UIImage imageNamed:@"tab-bar_03-nor"],
                        ];
    return images[index];
}

- (UIImage *)highlightedImageTabAtIndex:(NSUInteger)index
{
    NSArray *images = @[
                        [UIImage imageNamed:@"tab-bar_01-sel"],
                        [[UIImage imageNamed:@"tab-bar_02-sel"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f],
                        [UIImage imageNamed:@"tab-bar_03-sel"],
                        ];
    return images[index];
}

- (BOOL)shouldSelectTabAtIndex:(NSUInteger)index
{
    if(index == 1) {
            return NO;
    }
    return YES;
}

- (void) didSelectedTabAtIndex:(NSUInteger)index
{
    if(index == 1) 
        [self createPhotoPickerActionSheet];
}

- (void)createPhotoPickerActionSheet
{
    UIActionSheet *actionsheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionsheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose photo", @"")
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"take photo from camera", @""), NSLocalizedString(@"take photo from library", @""), nil];
        [actionsheet showInView: self.window.rootViewController.view];
    } else {
        actionsheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose photo", @"")
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"take photo from library", @""), nil];
        [actionsheet showInView: self.window.rootViewController.view];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.hidesBottomBarWhenPushed = YES;
    [self.window.rootViewController presentModalViewController:imagePickerController animated:NO];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage  *photo = [info objectForKey:UIImagePickerControllerEditedImage];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
}


@end
