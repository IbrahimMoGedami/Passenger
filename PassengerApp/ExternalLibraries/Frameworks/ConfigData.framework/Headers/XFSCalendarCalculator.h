//
//  FSCalendarCalculator.h
//  FSCalendar
//
//  Created by dingwenchao on 30/10/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

struct XFSCalendarCoordinate {
    NSInteger row;
    NSInteger column;
};
typedef struct XFSCalendarCoordinate XFSCalendarCoordinate;

@interface XFSCalendarCalculator : NSObject

@property (weak  , nonatomic) XFSCalendar *calendar;

@property (readonly, nonatomic) NSInteger numberOfSections;

- (instancetype)initWithCalendar:(XFSCalendar *)calendar;

- (NSDate *)safeDateForDate:(NSDate *)date;

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath scope:(XFSCalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date;
- (NSIndexPath *)indexPathForDate:(NSDate *)date scope:(XFSCalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date atMonthPosition:(XFSCalendarMonthPosition)position;
- (NSIndexPath *)indexPathForDate:(NSDate *)date atMonthPosition:(XFSCalendarMonthPosition)position scope:(XFSCalendarScope)scope;

- (NSDate *)pageForSection:(NSInteger)section;
- (NSDate *)weekForSection:(NSInteger)section;
- (NSDate *)monthForSection:(NSInteger)section;
- (NSDate *)monthHeadForSection:(NSInteger)section;

- (NSInteger)numberOfHeadPlaceholdersForMonth:(NSDate *)month;
- (NSInteger)numberOfRowsInMonth:(NSDate *)month;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (XFSCalendarMonthPosition)monthPositionForIndexPath:(NSIndexPath *)indexPath;
- (XFSCalendarCoordinate)coordinateForIndexPath:(NSIndexPath *)indexPath;

- (void)reloadSections;

@end
