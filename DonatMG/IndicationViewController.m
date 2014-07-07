//
//	IndicationViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "IndicationViewController.h"
#import "SettingsManager.h"

@interface IndicationViewController ()

@end

@implementation IndicationViewController

@synthesize indicationType = _indicationType;
@synthesize justShowInfo = _justShowInfo;

@synthesize scrollView = _scrollView;

@synthesize headerPanel = _headerPanel;
@synthesize headerButton = _headerButton;
@synthesize headerLabel = _headerLabel;
@synthesize drinkPanel = _drinkPanel;
@synthesize drinkButton = _drinkButton;
@synthesize drinkTableContainer = _drinkTableContainer;
@synthesize durationPanel = _durationPanel;
@synthesize durationButton = _durationButton;
@synthesize durationLabel = _durationLabel;
@synthesize startPanel = _startPanel;
@synthesize dayButton = _dayButton;
@synthesize monthButton = _monthButton;
@synthesize yearButton = _yearButton;
@synthesize bigButton = _bigButton;

- (void)updateViewActivation {
	_amActive = [[SettingsManager sharedManager] activeIndication] == _indicationType;
	[self.bigButton setTitle:_amActive ? ___(@"button_indication_stop") : ___(@"button_indication_start") forState:UIControlStateNormal];
}

- (void)setStartDate:(NSDateComponents *)date {
	[self.dayButton setTitle:[NSString stringWithFormat:@"%2lu", (unsigned long)date.day] forState:UIControlStateNormal];
	[self.monthButton setTitle:[NSString stringWithFormat:@"%02lu", (unsigned long)date.month] forState:UIControlStateNormal];
	[self.yearButton setTitle:[NSString stringWithFormat:@"%04lu", (unsigned long)date.year] forState:UIControlStateNormal];
}

- (void)calculateViews:(BOOL)animated {
	CGFloat headerAngle = _openHeader ? M_PI : 0.0f;
	CGFloat drinkAngle = _openDrink ? M_PI : 0.0f;
	CGFloat durationAngle = _openDuration ? M_PI : 0.0f;

	CGRect headerFrame = CGRectMake(.0f, 2.0f, 320.0f, _openHeader ? _desiredHeaderHeight : 117.0f);
	self.headerLabel.numberOfLines = _openHeader ? 0 : 3;
	self.headerLabel.lineBreakMode = _openHeader ? NSLineBreakByWordWrapping : NSLineBreakByTruncatingTail;
	CGRect drinkFrame = CGRectMake(.0f, headerFrame.origin.y + headerFrame.size.height, 320.0f, _openDrink ? _desiredDrinkHeight : 44.0f);
	CGRect durationFrame = CGRectMake(.0f, drinkFrame.origin.y + drinkFrame.size.height, 320.0f, _openDuration ? _desiredDurationHeight : 44.0f);

	CGSize contentSize = CGSizeMake(320.0f, durationFrame.origin.y + durationFrame.size.height);

	CGRect startFrame = CGRectMake(.0f, contentSize.height, 320.0f, self.startPanel.frame.size.height);
	if (!_justShowInfo) {
		contentSize.height += startFrame.size.height;
	}
	_startPanel.hidden = _justShowInfo;

	void (^animationBlock)(void) = ^{
		self.headerPanel.frame = headerFrame;
		self.headerButton.transform = CGAffineTransformMakeRotation(headerAngle);

		self.drinkPanel.frame = drinkFrame;
		self.drinkButton.transform = CGAffineTransformMakeRotation(drinkAngle);

		self.durationPanel.frame = durationFrame;
		self.durationButton.transform = CGAffineTransformMakeRotation(durationAngle);

		self.startPanel.frame = startFrame;
		self.startPanel.hidden = _justShowInfo;

		self.scrollView.contentSize = contentSize;
	};

	if (animated)
		[UIView animateWithDuration:.33f animations:animationBlock];
	else
		animationBlock();
}

- (void)calendar {
	[self performSegueWithIdentifier:@"showCalendar" sender:self];
}

- (void)settings {
	[self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	_openHeader = NO;
	_openDrink = NO;
	_openDuration = NO;

	// TODO: Calculate the actual heights
	_desiredDrinkHeight = 100.0f;
	_desiredDurationHeight = 150.0f;

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	[self updateViewActivation];

	UIFont *titlesFont = kTitlesFont;
	UIFont *textFont = kTextFont;
	UIFont *dateFont = kDateSelectFont;
	UIFont *subtitlesFont = kSubtitlesFont;

	[self.headerTitle setFont:titlesFont];
	[self.headerLabel setFont:textFont];
	[self.drinkTitle setFont:subtitlesFont];
	[self.durationTitle setFont:subtitlesFont];
	[self.startTitle setFont:subtitlesFont];
	[self.durationLabel setFont:textFont];
	[self.dayButton.titleLabel setFont:dateFont];
	[self.monthButton.titleLabel setFont:dateFont];
	[self.yearButton.titleLabel setFont:dateFont];
	[self.bigButton.titleLabel setFont:titlesFont];

	self.drinkTitle.text = ___(@"drinking");
	self.durationTitle.text = ___(@"interval");
	self.startTitle.text = ___(@"start_date");

	switch (_indicationType) {
		case kZaprtost:
			self.headerIcon.image = [UIImage imageNamed:@"icon_zaprtost.png"];
			self.headerTitle.text = ___(@"indication_1");
			self.headerLabel.text = ___(@"indication_1_desc");
			self.durationLabel.text = ___(@"indication_1_time");
			break;
		case kZgaga:
			self.headerIcon.image = [UIImage imageNamed:@"icon_zgaga.png"];
			self.headerTitle.text = ___(@"indication_2");
			self.headerLabel.text = ___(@"indication_2_desc");
			self.durationLabel.text = ___(@"indication_2_time");
			break;
		case kMagnezij:
			self.headerIcon.image = [UIImage imageNamed:@"icon_mg.png"];
			self.headerTitle.text = ___(@"indication_3");
			self.headerLabel.text = ___(@"indication_3_desc");
			self.durationLabel.text = ___(@"indication_3_time");
			break;
		case kSladkorna:
			self.headerIcon.image = [UIImage imageNamed:@"icon_sladkorna.png"];
			self.headerTitle.text = ___(@"indication_4");
			self.headerLabel.text = ___(@"indication_4_desc");
			self.durationLabel.text = ___(@"indication_4_time");
			break;
		case kSlinavka:
			self.headerIcon.image = [UIImage imageNamed:@"icon_slinavka.png"];
			self.headerTitle.text = ___(@"indication_5");
			self.headerLabel.text = ___(@"indication_5_desc");
			self.durationLabel.text = ___(@"indication_5_time");
			break;
		case kSecniKamni:
			self.headerIcon.image = [UIImage imageNamed:@"icon_secni_kamni.png"];
			self.headerTitle.text = ___(@"indication_6");
			self.headerLabel.text = ___(@"indication_6_desc");
			self.durationLabel.text = ___(@"indication_6_time");
			break;
		case kDebelost:
			self.headerIcon.image = [UIImage imageNamed:@"icon_debelost.png"];
			self.headerTitle.text = ___(@"indication_7");
			self.headerLabel.text = ___(@"indication_7_desc");
			self.durationLabel.text = ___(@"indication_7_time");
			break;
		case kSrceOzilje:
			self.headerIcon.image = [UIImage imageNamed:@"icon_srce_ozilje.png"];
			self.headerTitle.text = ___(@"indication_8");
			self.headerLabel.text = ___(@"indication_8_desc");
			self.durationLabel.text = ___(@"indication_8_time");
			break;
		case kStres:
			self.headerIcon.image = [UIImage imageNamed:@"icon_stres.png"];
			self.headerTitle.text = ___(@"indication_9");
			self.headerLabel.text = ___(@"indication_9_desc");
			self.durationLabel.text = ___(@"indication_9_time");
			break;
		case kPocutje:
			self.headerIcon.image = [UIImage imageNamed:@"icon_pocutje.png"];
			self.headerTitle.text = ___(@"indication_10");
			self.headerLabel.text = ___(@"indication_10_desc");
			self.durationLabel.text = ___(@"indication_10_time");
			break;
		default:
			break;
	}


	CGRect headerLabelFrame = [self.headerLabel.text boundingRectWithSize:CGSizeMake(self.headerLabel.frame.size.width, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.headerLabel.font} context:nil];

	_desiredHeaderHeight = self.headerLabel.frame.origin.y + headerLabelFrame.size.height + 20.0f;


	CGRect durationLabelFrame = [self.durationLabel.text boundingRectWithSize:CGSizeMake(self.durationLabel.frame.size.width, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.headerLabel.font} context:nil];

	_desiredDurationHeight = self.durationLabel.frame.origin.y + durationLabelFrame.size.height + 20.0f;


	UIBarButtonItem *calendarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(calendar)];

	UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];

	NSArray *buttonsArray = @[settingsItem, calendarItem];
	self.navigationItem.rightBarButtonItems = buttonsArray;


	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:today];
	[self setStartDate:dateComponents];
}

- (void)viewWillAppear:(BOOL)animated {
	[self calculateViews:NO];
}

- (void)viewWillLayoutSubviews {
	[self calculateViews:NO];
}

- (IBAction)headerPressed:(UIButton *)sender {
	_openHeader = !_openHeader;
	[self calculateViews:YES];
}

- (IBAction)drinkPressed:(UIButton *)sender {
	_openDrink = !_openDrink;
	[self calculateViews:YES];
}

- (IBAction)durationPressed:(UIButton *)sender {
	_openDuration = !_openDuration;
	[self calculateViews:YES];
}

- (IBAction)activationPressed:(UIButton *)sender {
	if (_justShowInfo)
		return;

	if (_amActive) {
		[[SettingsManager sharedManager] setActiveIndication:kUnknown];
	} else {
		[[SettingsManager sharedManager] setActiveIndication:self.indicationType];
	}
	[self updateViewActivation];
}

- (IBAction)datePressed:(UIButton *)sender {
	if (_justShowInfo)
		return;

	DLog();
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
