//
//	NSDate+DateTools.m
//	DonatMG
//
//	Created by Goran Blažič on 11/08/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "NSDate+DateTools.h"

typedef NS_ENUM(NSUInteger, DTDateComponent){
	DTDateComponentEra,
	DTDateComponentYear,
	DTDateComponentMonth,
	DTDateComponentDay,
	DTDateComponentHour,
	DTDateComponentMinute,
	DTDateComponentSecond,
	DTDateComponentWeekday,
	DTDateComponentWeekdayOrdinal,
	DTDateComponentQuarter,
	DTDateComponentWeekOfMonth,
	DTDateComponentWeekOfYear,
	DTDateComponentYearForWeekOfYear,
	DTDateComponentDayOfYear
};

static const unsigned int allCalendarUnitFlags = NSYearCalendarUnit | NSQuarterCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekOfMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSEraCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit;

static NSString *defaultCalendarIdentifier = nil;
static NSCalendar *implicitCalendar = nil;

@implementation NSDate (DateTools)

+ (void)load {
	[self setDefaultCalendarIdentifier:NSGregorianCalendar];
}

+ (NSDate *)todayWithoutTime {
	return [[NSDate date] dateWithoutTime];
}

- (NSDate *)dateWithoutTime {
	return [self dateWithoutTimeFromDate:self];
}

- (NSDate *)dateWithoutTimeFromDate:(NSDate *)date {
	NSDateComponents *components = [implicitCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
	return [implicitCalendar dateFromComponents:components];
}

- (NSInteger)year{
	return [self componentForDate:self type:DTDateComponentYear calendar:nil];
}

- (NSInteger)month{
	return [self componentForDate:self type:DTDateComponentMonth calendar:nil];
}

- (NSInteger)day{
	return [self componentForDate:self type:DTDateComponentDay calendar:nil];
}

- (NSInteger)componentForDate:(NSDate *)date type:(DTDateComponent)component calendar:(NSCalendar *)calendar {
	if (!calendar) {
		calendar = [[self class] implicitCalendar];
	}

	unsigned int unitFlags = 0;

	if (component == DTDateComponentYearForWeekOfYear) {
		unitFlags = NSYearCalendarUnit | NSQuarterCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekOfMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSEraCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit | NSYearForWeekOfYearCalendarUnit;
	} else {
		unitFlags = allCalendarUnitFlags;
	}

	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];

	switch (component) {
		case DTDateComponentEra:
			return [dateComponents era];
		case DTDateComponentYear:
			return [dateComponents year];
		case DTDateComponentMonth:
			return [dateComponents month];
		case DTDateComponentDay:
			return [dateComponents day];
		case DTDateComponentHour:
			return [dateComponents hour];
		case DTDateComponentMinute:
			return [dateComponents minute];
		case DTDateComponentSecond:
			return [dateComponents second];
		case DTDateComponentWeekday:
			return [dateComponents weekday];
		case DTDateComponentWeekdayOrdinal:
			return [dateComponents weekdayOrdinal];
		case DTDateComponentQuarter:
			return [dateComponents quarter];
		case DTDateComponentWeekOfMonth:
			return [dateComponents weekOfMonth];
		case DTDateComponentWeekOfYear:
			return [dateComponents weekOfYear];
		case DTDateComponentYearForWeekOfYear:
			return [dateComponents yearForWeekOfYear];
		case DTDateComponentDayOfYear:
			return [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
		default:
			break;
	}
	
	return 0;
}

+ (NSString *)defaultCalendarIdentifier {
	return defaultCalendarIdentifier;
}

+ (void)setDefaultCalendarIdentifier:(NSString *)identifier {
	defaultCalendarIdentifier = [identifier copy];
	implicitCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:defaultCalendarIdentifier ?: NSGregorianCalendar];
}

+ (NSCalendar *)implicitCalendar {
	return implicitCalendar;
}

@end
