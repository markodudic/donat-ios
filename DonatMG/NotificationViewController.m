//
//	NotificationViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 28/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "NotificationViewController.h"
#import "SettingsManager.h"

#define alphaValue 0.3f

@interface NotificationViewController ()

@end

@implementation NotificationViewController

@synthesize notification = _notification;

- (void)calendar {
	[self performSegueWithIdentifier:@"showCalendar" sender:self];
}

- (void)settings {
	[self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	[_dateLabel setFont:kNotificationIndicationTest];
	[_timeOfDayLabel setFont:kNotificationIndicationTest];

	UIColor *backgroundColor = kNotificationTextBackground;
	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2.0f, 5.0f, 2.0f, 5.0f);

	_labelUpLeft = [[InsetLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 70.0f, 30.0f)];
	_labelUpLeft.backgroundColor = backgroundColor;
	[_labelUpLeft setFont:kNotificationText];
	_labelUpLeft.edgeInsets = edgeInsets;
	_labelUpLeft.textAlignment = NSTextAlignmentCenter;
	[_containerView addSubview:_labelUpLeft];

	_labelUpRight = [[InsetLabel alloc] initWithFrame:CGRectMake(74.0f, 0.0f, 206.0f, 30.0f)];
	_labelUpRight.backgroundColor = backgroundColor;
	[_labelUpRight setFont:kNotificationText];
	_labelUpRight.edgeInsets = edgeInsets;
	_labelUpRight.textAlignment = NSTextAlignmentCenter;
	[_containerView addSubview:_labelUpRight];

	_labelDown = [[InsetLabel alloc] initWithFrame:CGRectMake(0.0f, 34.0f, 280.0f, 30.0f)];
	_labelDown.backgroundColor = backgroundColor;
	[_labelDown setFont:kNotificationText];
	_labelDown.edgeInsets = edgeInsets;
	_labelDown.textAlignment = NSTextAlignmentCenter;
	[_containerView addSubview:_labelDown];

	UIBarButtonItem *calendarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(calendar)];

	UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];

	NSArray *buttonsArray = @[settingsItem, calendarItem];
	self.navigationItem.rightBarButtonItems = buttonsArray;
}

- (void)viewWillAppear:(BOOL)animated {
	NSNumber *tempNumber = [_notification.userInfo objectForKey:@"indication"];
	if (tempNumber)
		_indication = [tempNumber unsignedIntegerValue];
	else
		_indication = kUnknown;

	tempNumber = [_notification.userInfo objectForKey:@"timeOfDay"];
	if (tempNumber)
		_timeOfDay = [tempNumber unsignedIntegerValue];
	else
		_timeOfDay = 0;

	NSString *amountString = [_notification.userInfo objectForKey:@"amount"];
	_labelUpLeft.text = amountString;

	NSString *temperatureString = [_notification.userInfo objectForKey:@"temperature"];
	_labelUpRight.text = temperatureString;

	NSString *speedString = [_notification.userInfo objectForKey:@"speed"];
	_labelDown.text = speedString;

	switch (_indication) {
		case kZaprtost:
			_indicationIcon.image = [UIImage imageNamed:@"icon_zaprtost.png"];
			_indicationLabel.text = ___(@"indication_1");
			break;
		case kZgaga:
			_indicationIcon.image = [UIImage imageNamed:@"icon_zgaga.png"];
			_indicationLabel.text = ___(@"indication_2");
			break;
		case kMagnezij:
			_indicationIcon.image = [UIImage imageNamed:@"icon_mg.png"];
			_indicationLabel.text = ___(@"indication_3");
			break;
		case kSladkorna:
			_indicationIcon.image = [UIImage imageNamed:@"icon_sladkorna.png"];
			_indicationLabel.text = ___(@"indication_4");
			break;
		case kSlinavka:
			_indicationIcon.image = [UIImage imageNamed:@"icon_slinavka.png"];
			_indicationLabel.text = ___(@"indication_5");
			break;
		case kSecniKamni:
			_indicationIcon.image = [UIImage imageNamed:@"icon_secni_kamni.png"];
			_indicationLabel.text = ___(@"indication_6");
			break;
		case kDebelost:
			_indicationIcon.image = [UIImage imageNamed:@"icon_debelost.png"];
			_indicationLabel.text = ___(@"indication_7");
			break;
		case kSrceOzilje:
			_indicationIcon.image = [UIImage imageNamed:@"icon_srce_ozilje.png"];
			_indicationLabel.text = ___(@"indication_8");
			break;
		case kStres:
			_indicationIcon.image = [UIImage imageNamed:@"icon_stres.png"];
			_indicationLabel.text = ___(@"indication_9");
			break;
		case kPocutje:
			_indicationIcon.image = [UIImage imageNamed:@"icon_pocutje.png"];
			_indicationLabel.text = ___(@"indication_10");
			break;
		default:
			break;
	}

	[_closeButton setTitle:___(@"close") forState:UIControlStateNormal];

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit fromDate:[NSDate date]];
	_dateLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)dateComponents.day, [[LanguageManager sharedManager] stringForMonth:dateComponents.month]];

	// TODO: Draw the icons and labels here...
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)closeClicked:(UIButton *)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
