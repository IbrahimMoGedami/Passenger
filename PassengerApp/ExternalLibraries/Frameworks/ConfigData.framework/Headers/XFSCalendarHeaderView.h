//
//  FSCalendarHeader.h
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import <UIKit/UIKit.h>


@class XFSCalendar, XFSCalendarAppearance, XFSCalendarHeaderLayout, XFSCalendarCollectionView;

@interface XFSCalendarHeaderView : UIView

@property (weak, nonatomic) XFSCalendarCollectionView *collectionView;
@property (weak, nonatomic) XFSCalendarHeaderLayout *collectionViewLayout;
@property (weak, nonatomic) XFSCalendar *calendar;

@property (assign, nonatomic) CGFloat scrollOffset;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) BOOL scrollEnabled;
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;
@property (assign, nonatomic) BOOL needsAdjustingMonthPosition;

- (void)setScrollOffset:(CGFloat)scrollOffset animated:(BOOL)animated;
- (void)reloadData;
- (void)configureAppearance;

@end


@interface XFSCalendarHeaderCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) XFSCalendarHeaderView *header;

@end

@interface XFSCalendarHeaderLayout : UICollectionViewFlowLayout

@end

@interface XFSCalendarHeaderTouchDeliver : UIView

@property (weak, nonatomic) XFSCalendar *calendar;
@property (weak, nonatomic) XFSCalendarHeaderView *header;

@end
