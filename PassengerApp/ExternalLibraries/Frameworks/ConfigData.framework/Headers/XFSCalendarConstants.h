//
//  FSCalendarConstane.h
//  FSCalendar
//
//  Created by dingwenchao on 8/28/15.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//  https://github.com/WenchaoD
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - Constants

CG_EXTERN CGFloat const XFSCalendarStandardHeaderHeight;
CG_EXTERN CGFloat const XFSCalendarStandardWeekdayHeight;
CG_EXTERN CGFloat const XFSCalendarStandardMonthlyPageHeight;
CG_EXTERN CGFloat const XFSCalendarStandardWeeklyPageHeight;
CG_EXTERN CGFloat const XFSCalendarStandardCellDiameter;
CG_EXTERN CGFloat const XFSCalendarStandardSeparatorThickness;
CG_EXTERN CGFloat const XFSCalendarAutomaticDimension;
CG_EXTERN CGFloat const XFSCalendarDefaultBounceAnimationDuration;
CG_EXTERN CGFloat const XFSCalendarStandardRowHeight;
CG_EXTERN CGFloat const XFSCalendarStandardTitleTextSize;
CG_EXTERN CGFloat const XFSCalendarStandardSubtitleTextSize;
CG_EXTERN CGFloat const XFSCalendarStandardWeekdayTextSize;
CG_EXTERN CGFloat const XFSCalendarStandardHeaderTextSize;
CG_EXTERN CGFloat const XFSCalendarMaximumEventDotDiameter;
CG_EXTERN CGFloat const XFSCalendarStandardScopeHandleHeight;

UIKIT_EXTERN NSInteger const XFSCalendarDefaultHourComponent;

UIKIT_EXTERN NSString * const XFSCalendarDefaultCellReuseIdentifier;
UIKIT_EXTERN NSString * const XFSCalendarBlankCellReuseIdentifier;
UIKIT_EXTERN NSString * const XFSCalendarInvalidArgumentsExceptionName;

CG_EXTERN CGPoint const XCGPointInfinity;
CG_EXTERN CGSize const XCGSizeAutomatic;

#if TARGET_INTERFACE_BUILDER
#define XFSCalendarDeviceIsIPad NO
#else
#define XFSCalendarDeviceIsIPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#endif

#define XFSCalendarStandardSelectionColor   XFSColorRGBA(31,119,219,1.0)
#define XFSCalendarStandardTodayColor       XFSColorRGBA(198,51,42 ,1.0)
#define XFSCalendarStandardTitleTextColor   XFSColorRGBA(14,69,221 ,1.0)
#define XFSCalendarStandardEventDotColor    XFSColorRGBA(31,119,219,0.75)

#define XFSCalendarStandardLineColor        [[UIColor lightGrayColor] colorWithAlphaComponent:0.30]
#define XFSCalendarStandardSeparatorColor   [[UIColor lightGrayColor] colorWithAlphaComponent:0.60]
#define XFSCalendarStandardScopeHandleColor [[UIColor lightGrayColor] colorWithAlphaComponent:0.50]

#define XFSColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define XFSCalendarInAppExtension [[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]

#if XCGFLOAT_IS_DOUBLE
#define XFSCalendarFloor(c) floor(c)
#define XFSCalendarRound(c) round(c)
#define XFSCalendarCeil(c) ceil(c)
#define XFSCalendarMod(c1,c2) fmod(c1,c2)
#else
#define XFSCalendarFloor(c) floorf(c)
#define XFSCalendarRound(c) roundf(c)
#define XFSCalendarCeil(c) ceilf(c)
#define XFSCalendarMod(c1,c2) fmodf(c1,c2)
#endif

#define XFSCalendarUseWeakSelf __weak __typeof__(self) XFSCalendarWeakSelf = self;
#define XFSCalendarUseStrongSelf __strong __typeof__(self) self = XFSCalendarWeakSelf;


#pragma mark - Deprecated

#define XFSCalendarDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

XFSCalendarDeprecated('borderRadius')
typedef NS_ENUM(NSUInteger, XFSCalendarCellShape) {
    XFSCalendarCellShapeCircle    = 0,
    XFSCalendarCellShapeRectangle = 1
};

typedef NS_ENUM(NSUInteger, XFSCalendarUnit) {
    XFSCalendarUnitMonth = NSCalendarUnitMonth,
    XFSCalendarUnitWeekOfYear = NSCalendarUnitWeekOfYear,
    XFSCalendarUnitDay = NSCalendarUnitDay
};

static inline void XFSCalendarSliceCake(CGFloat cake, NSInteger count, CGFloat *pieces) {
    CGFloat total = cake;
    for (int i = 0; i < count; i++) {
        NSInteger remains = count - i;
        CGFloat piece = XFSCalendarRound(total/remains*2)*0.5;
        total -= piece;
        pieces[i] = piece;
    }
}



