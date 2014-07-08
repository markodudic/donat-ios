//
//	CalendarViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "CalendarViewController.h"
#import "LanguageManager.h"
#import "TreatmentManager.h"
#import "IndicationViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize titleLabel = _titleLabel;

@synthesize mondayLabel = _mondayLabel;
@synthesize tuesdayLabel = _tuesdayLabel;
@synthesize wednesdayLabel = _wednesdayLabel;
@synthesize thursdayLabel = _thursdayLabel;
@synthesize fridayLabel = _fridayLabel;
@synthesize saturdayLabel = _saturdayLabel;
@synthesize sundayLabel = _sundayLabel;

@synthesize containerView = _containerView;

- (NSUInteger)firstWeekdayInMonth {
	NSDateComponents *firstDay = [_monthShown copy];
	firstDay.day = 1;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *firstDate = [gregorian dateFromComponents:firstDay];
	NSDateComponents *calcDay = [gregorian components:NSWeekdayCalendarUnit fromDate:firstDate];
	if ([calcDay weekday] == 1)
		return 7;
	else
		return [calcDay weekday] - 1;
}

- (void)calendar {
}

- (void)settings {
	[self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)updateTitle {
	self.titleLabel.text = [NSString stringWithFormat:@"%@ %04d", [[LanguageManager sharedManager] stringForMonth:_monthShown.month], (int)_monthShown.year];
}

- (void)updateCalendar {
	[self updateTitle];

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

	[dateComponents setMonth:_monthShown.month];
	NSRange range = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[gregorian dateFromComponents:dateComponents]];

	NSInteger numberOfDays = range.length;

	if (dateComponents.month > 1) {
		dateComponents.month = dateComponents.month - 1;
	} else {
		dateComponents.month = 12;
		dateComponents.year = dateComponents.year - 1;
	}

	range = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[gregorian dateFromComponents:dateComponents]];

	NSInteger numberOfPreviousDays = range.length;

	NSInteger firstDay = [self firstWeekdayInMonth] - 2;
	BOOL curMonth = _currentDate.year == _monthShown.year && _currentDate.month == _monthShown.month;

	NSUInteger prevYear = _monthShown.year;
	NSUInteger nextYear = _monthShown.year;
	NSUInteger prevMonth = _monthShown.month - 1;
	NSUInteger nextMonth = _monthShown.month + 1;
	if (prevMonth == 0) {
		prevMonth = 12;
		prevYear -= 1;
	}
	if (nextMonth > 12) {
		nextMonth = 1;
		nextYear += 1;
	}
	NSDateComponents *prevComponents = [[NSDateComponents alloc] init];
	[prevComponents setYear:prevYear];
	[prevComponents setMonth:prevMonth];

	NSDateComponents *nextComponents = [[NSDateComponents alloc] init];
	[nextComponents setYear:nextYear];
	[nextComponents setMonth:nextMonth];

	NSDateComponents *currComponents = [[NSDateComponents alloc] init];
	[currComponents setYear:_monthShown.year];
	[currComponents setMonth:_monthShown.month];

	NSInteger dayNextMonth = 1;

	for (int i = 0; i < [_fields count]; i++) {
		long day = i - firstDay;
		CalendarFieldView *tempView = [_fields objectAtIndex:i];
		tempView.today = curMonth && day == _currentDate.day;
		if (day > 0 && day < numberOfDays + 1) {
			tempView.day = i - firstDay;
			tempView.currentMonth = YES;
			[currComponents setDay:tempView.day];
			tempView.date = [gregorian dateFromComponents:currComponents];
		} else {
			if (i < 20) {  // crude? yeah, but it works...
				tempView.day = numberOfPreviousDays - firstDay + i;
				[prevComponents setDay:tempView.day];
				tempView.date = [gregorian dateFromComponents:prevComponents];
			} else {
				tempView.day = dayNextMonth++;
				[nextComponents setDay:tempView.day];
				tempView.date = [gregorian dateFromComponents:nextComponents];
			}
			tempView.currentMonth = NO;
		}
	}
}

- (void)prepareFields {
	CGFloat top = IS_IPHONE_5 ? 19.0f : 20.0f;

	NSMutableArray *tempFields = [[NSMutableArray alloc] initWithCapacity:35];

	for (unsigned int y = 0; y < 6; y++) {
		CGFloat left = 18.0f;
		for (unsigned int x = 0; x < 7; x++) {
			CGRect frame = CGRectMake(left, top, 38.0f, IS_IPHONE_5 ? 60.0f : 45.0f);

			CalendarFieldView *tempView = [[CalendarFieldView alloc] initWithFrame:frame];
			tempView.delegate = self;
			tempView.day = 0;
			tempView.today = NO;
			tempView.hasDrunk = NO;

			[_containerView addSubview:tempView];

			[tempFields addObject:tempView];

			left += 41.0f;
		}
		top += IS_IPHONE_5 ? 63.0f : 48.0;
	}

	_fields = tempFields;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	[_titleLabel setFont:kCalendarTitleFont];

	UIFont *daysFont = kCalendarDaysFont;

	[_mondayLabel setFont:daysFont];
	_mondayLabel.text = [[LanguageManager sharedManager] stringForDay:1];
	[_tuesdayLabel setFont:daysFont];
	_tuesdayLabel.text = [[LanguageManager sharedManager] stringForDay:2];
	[_wednesdayLabel setFont:daysFont];
	_wednesdayLabel.text = [[LanguageManager sharedManager] stringForDay:3];
	[_thursdayLabel setFont:daysFont];
	_thursdayLabel.text = [[LanguageManager sharedManager] stringForDay:4];
	[_fridayLabel setFont:daysFont];
	_fridayLabel.text = [[LanguageManager sharedManager] stringForDay:5];
	[_saturdayLabel setFont:daysFont];
	_saturdayLabel.text = [[LanguageManager sharedManager] stringForDay:6];
	[_sundayLabel setFont:daysFont];
	_sundayLabel.text = [[LanguageManager sharedManager] stringForDay:7];

	UIBarButtonItem *calendarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"calendar-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(calendar)];
	calendarItem.enabled = NO;

	UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];

	NSArray *buttonsArray = @[settingsItem, calendarItem];
	self.navigationItem.rightBarButtonItems = buttonsArray;

	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	_monthShown = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:today];
	_currentDate = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];

	[self prepareFields];

	[self updateCalendar];
}

- (void)createBorder:(UILabel *)label {
	label.layer.borderColor = [UIColor redColor].CGColor;
	label.layer.borderWidth = 1.0f;
}

- (void)viewWillLayoutSubviews {
	CGRect frame = CGRectMake(18.0f, 122.0f, 38.0f, 25.0f);
	[_mondayLabel setFrame:frame];

	frame.origin.x += 41;
	[_tuesdayLabel setFrame:frame];

	frame.origin.x += 41;
	[_wednesdayLabel setFrame:frame];

	frame.origin.x += 41;
	[_thursdayLabel setFrame:frame];

	frame.origin.x += 41;
	[_fridayLabel setFrame:frame];

	frame.origin.x += 41;
	[_saturdayLabel setFrame:frame];

	frame.origin.x += 41;
	[_sundayLabel setFrame:frame];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)leftButtonPressed:(UIButton *)sender {
	if (_monthShown.month > 1) {
		[_monthShown setMonth:_monthShown.month - 1];
	} else {
		[_monthShown setMonth:12];
		[_monthShown setYear:_monthShown.year - 1];
	}
	[self updateCalendar];
}

- (IBAction)rightButtonPressed:(UIButton *)sender {
	if (_monthShown.month < 12) {
		[_monthShown setMonth:_monthShown.month + 1];
	} else {
		[_monthShown setMonth:1];
		[_monthShown setYear:_monthShown.year + 1];
	}
	[self updateCalendar];
}

#pragma mark - CalendarFieldView

- (void)dateWasClicked:(NSDate *)date {
	IndicationType indicationType = [[TreatmentManager sharedManager] indicationForDate:date];

	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	IndicationViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"indicationViewController"];
	viewController.justShowInfo = YES;
	viewController.indicationType = indicationType;
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
