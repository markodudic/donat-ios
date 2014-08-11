//
//	NSDate+DateTools.h
//	DonatMG
//
//	Created by Goran Blažič on 11/08/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateTools)

+ (NSDate *)todayWithoutTime;
- (NSDate *)dateWithoutTime;
- (NSDate *)dateWithoutTimeFromDate:(NSDate *)date;

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;

+ (NSString *)defaultCalendarIdentifier;
+ (void)setDefaultCalendarIdentifier:(NSString *)identifier;

@end
