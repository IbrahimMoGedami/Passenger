//
//  FSCalendarTransitionCoordinator.h
//  FSCalendar
//
//  Created by dingwenchao on 3/13/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "XFSCalendar.h"
#import "XFSCalendarCollectionView.h"
#import "XFSCalendarCollectionViewLayout.h"
#import "XFSCalendarScopeHandle.h"

typedef NS_ENUM(NSUInteger, XFSCalendarTransition) {
    XFSCalendarTransitionNone,
    XFSCalendarTransitionMonthToWeek,
    XFSCalendarTransitionWeekToMonth
};
typedef NS_ENUM(NSUInteger, XFSCalendarTransitionState) {
    XFSCalendarTransitionStateIdle,
    XFSCalendarTransitionStateChanging,
    XFSCalendarTransitionStateFinishing,
};

@interface XFSCalendarTransitionCoordinator : NSObject <UIGestureRecognizerDelegate>

@property (weak, nonatomic) XFSCalendar *calendar;
@property (weak, nonatomic) XFSCalendarCollectionView *collectionView;
@property (weak, nonatomic) XFSCalendarCollectionViewLayout *collectionViewLayout;

@property (assign, nonatomic) XFSCalendarTransition transition;
@property (assign, nonatomic) XFSCalendarTransitionState state;

@property (assign, nonatomic) CGSize cachedMonthSize;

@property (readonly, nonatomic) XFSCalendarScope representingScope;

- (instancetype)initWithCalendar:(XFSCalendar *)calendar;

- (void)performScopeTransitionFromScope:(XFSCalendarScope)fromScope toScope:(XFSCalendarScope)toScope animated:(BOOL)animated;
- (void)performBoundingRectTransitionFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth duration:(CGFloat)duration;

- (void)handleScopeGesture:(id)sender;

@end


@interface XFSCalendarTransitionAttributes : NSObject

@property (assign, nonatomic) CGRect sourceBounds;
@property (assign, nonatomic) CGRect targetBounds;
@property (strong, nonatomic) NSDate *sourcePage;
@property (strong, nonatomic) NSDate *targetPage;
@property (assign, nonatomic) NSInteger focusedRowNumber;
@property (assign, nonatomic) NSDate *focusedDate;
@property (strong, nonatomic) NSDate *firstDayOfMonth;

@end

