//
//  Configurations.h
//  ConfigData
//
//  Created by Admin on 11/22/18.
//  Copyright © 2018 V3Cube. All rights reserved.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Configurations : NSObject

- (BOOL) isRTLMode;
-  (NSString *_Nullable) getGoogleMapLngCode;
-  (BOOL) isUserLoggedIn;
-  (void) setAppLocal;
-  (NSCalendarIdentifier _Nullable ) getCalendarIdentifire;
-  (NSString *_Nonnull) convertNumToAppLocal:(NSString *_Nullable) numStr;
-  (NSString *_Nonnull) convertNumToEnglish:(NSString *_Nullable) numStr;
-  (NSString *_Nullable) getInfoPlistValue:(NSString *_Nullable) key;
-  (NSString *_Nullable) getPlistValue:(NSString *_Nullable) key fileName:(NSString *_Nullable)fileName;
-  (NSLocale *_Nullable) getAppLocale;
-  (BOOL) isIponeXDevice;
-  (void) setAppThemeNavBar:(UIColor *_Nullable) appThemeTxtColor appThemeColor:(UIColor *_Nonnull)appThemeColor;
-  (void) setDefaultStatusBar;
-  (void) setLightStatusBar;
-  (NSString *_Nonnull) getGoogleServerKey;
-  (NSString *_Nullable) getGoogleIOSKey;

@end
