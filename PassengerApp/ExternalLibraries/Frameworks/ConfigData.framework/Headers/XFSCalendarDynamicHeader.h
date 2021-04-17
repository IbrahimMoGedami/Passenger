//
//  FSCalendarDynamicHeader.h
//  Pods
//
//  Created by DingWenchao on 6/29/15.
//
//  动感头文件，仅供框架内部使用。
//  Private header, don't use it.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "XFSCalendar.h"
#import "XFSCalendarCell.h"
#import "XFSCalendarHeaderView.h"
#import "XFSCalendarStickyHeader.h"
#import "XFSCalendarCollectionView.h"
#import "XFSCalendarCollectionViewLayout.h"
#import "XFSCalendarScopeHandle.h"
#import "XFSCalendarCalculator.h"
#import "XFSCalendarTransitionCoordinator.h"
#import "XFSCalendarDelegationProxy.h"

@interface XFSCalendar (Dynamic)

@property (readonly, nonatomic) XFSCalendarCollectionView *collectionView;
@property (readonly, nonatomic) XFSCalendarScopeHandle *scopeHandle;
@property (readonly, nonatomic) XFSCalendarCollectionViewLayout *collectionViewLayout;
@property (readonly, nonatomic) XFSCalendarTransitionCoordinator *transitionCoordinator;
@property (readonly, nonatomic) XFSCalendarCalculator *calculator;
@property (readonly, nonatomic) BOOL floatingMode;
@property (readonly, nonatomic) NSArray *visibleStickyHeaders;
@property (readonly, nonatomic) CGFloat preferredHeaderHeight;
@property (readonly, nonatomic) CGFloat preferredWeekdayHeight;
@property (readonly, nonatomic) UIView *bottomBorder;

@property (readonly, nonatomic) NSCalendar *gregorian;
@property (readonly, nonatomic) NSDateComponents *components;
@property (readonly, nonatomic) NSDateFormatter *formatter;

@property (readonly, nonatomic) UIView *contentView;
@property (readonly, nonatomic) UIView *daysContainer;

@property (assign, nonatomic) BOOL needsAdjustingViewFrame;

- (void)invalidateHeaders;
- (void)adjustMonthPosition;
- (void)configureAppearance;

- (BOOL)isPageInRange:(NSDate *)page;
- (BOOL)isDateInRange:(NSDate *)date;

- (CGSize)sizeThatFits:(CGSize)size scope:(XFSCalendarScope)scope;

@end

@interface XFSCalendarAppearance (Dynamic)

@property (readwrite, nonatomic) XFSCalendar *calendar;

@property (readonly, nonatomic) NSDictionary *backgroundColors;
@property (readonly, nonatomic) NSDictionary *titleColors;
@property (readonly, nonatomic) NSDictionary *subtitleColors;
@property (readonly, nonatomic) NSDictionary *borderColors;

@end

@interface XFSCalendarWeekdayView (Dynamic)

@property (readwrite, nonatomic) XFSCalendar *calendar;

@end

@interface XFSCalendarCollectionViewLayout (Dynamic)

@property (readonly, nonatomic) CGSize estimatedItemSize;

@end

@interface XFSCalendarDelegationProxy()<XFSCalendarDataSource,XFSCalendarDelegate,XFSCalendarDelegateAppearance>
@end


