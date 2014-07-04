//
//	CalendarViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "CalendarViewController.h"
#import "LanguageManager.h"

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

	CGFloat top = IS_IPHONE_5 ? 19.0f : 20.0f;

	for (unsigned int y = 0; y < 5; y++) {
		CGFloat left = 18.0f;
		for (unsigned int x = 0; x < 7; x++) {
			CGRect frame = CGRectMake(left, top, 38.0f, IS_IPHONE_5 ? 73.0f : 55.0f);

			UIView *tempView = [[UIView alloc] initWithFrame:frame];
			tempView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];

			[_containerView addSubview:tempView];

			left += 41.0f;
		}
		top += IS_IPHONE_5 ? 76.0f : 58.0;
	}
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

@end
