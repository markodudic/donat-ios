//
//	CalendarFieldView.m
//	DonatMG
//
//	Created by Goran Blažič on 06/07/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "CalendarFieldView.h"

@implementation CalendarFieldView

@synthesize delegate = _delegate;
@synthesize today = _today;
@synthesize day = _day;
@synthesize date = _date;
@synthesize indicationType = _indicationType;
@synthesize shouldDrink = _shouldDrink;
@synthesize currentMonth = _currentMonth;

- (void)buttonClicked:(id)button {
	if (_day > 0 && _day < 32)
		[_delegate dateWasClicked:_date];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_today = NO;
		_day = 0;
		_date = [NSDate date];

		self.backgroundColor = kCalendarFieldColorWhite;

		_glassIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ikona-kozarec.png"]];
		_todayIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ikona-danes.png"]];

		CGRect tempFrame = _glassIcon.frame;
		tempFrame.origin.x = frame.size.width - tempFrame.size.width - 2.0f;
		tempFrame.origin.y = 2.0f;
		_glassIcon.frame = tempFrame;

		_glassIcon.hidden = YES;
		[self addSubview:_glassIcon];

		tempFrame = _todayIcon.frame;
		tempFrame.origin.x = frame.size.width - tempFrame.size.width - 2.0f;
		tempFrame.origin.y = _glassIcon.frame.origin.y + _glassIcon.frame.size.height;
		_todayIcon.frame = tempFrame;

		_todayIcon.hidden = YES;
		[self addSubview:_todayIcon];

		CGFloat top = tempFrame.origin.y + tempFrame.size.height;
		tempFrame = CGRectMake(0.0f, top, frame.size.width, frame.size.height - top);

		_numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_numberButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[_numberButton.titleLabel setFont:kCalendarNumbersFont];
		[_numberButton setTitleColor:[UIColor colorWithRed:0.0078125f green:0.23046875f blue:0.1796875f alpha:1.0f] forState:UIControlStateNormal];
		[_numberButton setTitle:@"" forState:UIControlStateNormal];
		[_numberButton setFrame:tempFrame];

		[self addSubview:_numberButton];
	}
	return self;
}

- (void)updateDrinkIcon {
	_glassIcon.hidden = !_shouldDrink;
	_glassIcon.alpha = [[NSDate date] compare:_date] == NSOrderedAscending ? 1.0f : 0.5f;
	self.backgroundColor = _shouldDrink ? kCalendarFieldColorGray : kCalendarFieldColorWhite;
}

- (void)setToday:(BOOL)today {
	_today = today;
	_todayIcon.hidden = !_today;
}

- (void)setDay:(NSUInteger)day {
	_day = day;
	if (_day > 0 && _day < 32)
		[_numberButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)_day] forState:UIControlStateNormal];
	else
		[_numberButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)setShouldDrink:(BOOL)shouldDrink {
	_shouldDrink = shouldDrink;
	[self updateDrinkIcon];
}

- (void)setDate:(NSDate *)date {
	_date = date;
	[self updateDrinkIcon];
}

- (void)setCurrentMonth:(BOOL)currentMonth {
	_currentMonth = currentMonth;
	_numberButton.alpha = _currentMonth ? 1.0f : 0.3f;
}

@end
