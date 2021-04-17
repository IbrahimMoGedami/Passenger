//
//  FSCalendarAnimationLayout.h
//  FSCalendar
//
//  Created by dingwenchao on 1/3/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFSCalendar;

@interface XFSCalendarCollectionViewLayout : UICollectionViewLayout

@property (weak, nonatomic) XFSCalendar *calendar;

@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) UIEdgeInsets sectionInsets;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) CGSize headerReferenceSize;

@end
