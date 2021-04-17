//
//  FSCalendarStaticHeader.h
//  FSCalendar
//
//  Created by dingwenchao on 9/17/15.
//  Copyright (c) 2015 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFSCalendar,XFSCalendarAppearance;

@interface XFSCalendarStickyHeader : UICollectionReusableView

@property (weak, nonatomic) XFSCalendar *calendar;

@property (weak, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSDate *month;

- (void)configureAppearance;

@end
