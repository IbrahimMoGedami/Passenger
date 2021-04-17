//
//  FSCalendarDelegationFactory.h
//  FSCalendar
//
//  Created by dingwenchao on 19/12/2016.
//  Copyright © 2016 wenchaoios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFSCalendarDelegationProxy.h"

@interface XFSCalendarDelegationFactory : NSObject

+ (XFSCalendarDelegationProxy *)dataSourceProxy;
+ (XFSCalendarDelegationProxy *)delegateProxy;

@end
