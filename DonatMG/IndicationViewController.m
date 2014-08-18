//
//	IndicationViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "IndicationViewController.h"
#import "SettingsManager.h"
#import "TreatmentManager.h"

#import "InsetLabel.h"

@interface IndicationViewController ()

@end

@implementation IndicationViewController

@synthesize dummyField = _dummyField;

@synthesize startDate = _startDate;

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
	_amActive = [[TreatmentManager sharedManager] activeIndication] == _indicationType;
	[self.bigButton setTitle:_amActive ? ___(@"button_indication_stop") : ___(@"button_indication_start") forState:UIControlStateNormal];
}

- (void)updateDateShown {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:_startDate];

	[self.dayButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)dateComponents.day] forState:UIControlStateNormal];
	NSString *monthIdentifier = [NSString stringWithFormat:@"month_%lu_short", (unsigned long)dateComponents.month];
	[self.monthButton setTitle:___(monthIdentifier) forState:UIControlStateNormal];
	[self.yearButton setTitle:[NSString stringWithFormat:@"%04lu", (unsigned long)dateComponents.year] forState:UIControlStateNormal];
}

- (void)setStartDate:(NSDate *)startDate {
	_startDate = startDate;
	[self updateDateShown];
}

- (void)setHistoryItem:(CalendarHistoryEntry *)historyItem {
	_historyItem = historyItem;
	[self updateDateShown];
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
//	if (!_justShowInfo) {
		contentSize.height += startFrame.size.height;
//	}
//	_startPanel.hidden = _justShowInfo;
	_bigButton.enabled = !_justShowInfo;

	void (^animationBlock)(void) = ^{
		self.headerPanel.frame = headerFrame;
		self.headerButton.transform = CGAffineTransformMakeRotation(headerAngle);

		self.drinkPanel.frame = drinkFrame;
		self.drinkButton.transform = CGAffineTransformMakeRotation(drinkAngle);

		self.durationPanel.frame = durationFrame;
		self.durationButton.transform = CGAffineTransformMakeRotation(durationAngle);

		self.startPanel.frame = startFrame;
//		self.startPanel.hidden = _justShowInfo;

		self.scrollView.contentSize = contentSize;
	};

	if (animated)
		[UIView animateWithDuration:.33f animations:animationBlock];
	else
		animationBlock();
}

- (CGFloat)calculateHeightForText:(NSString *)text withFont:(UIFont *)font andWidth:(CGFloat)width {
	CGRect neededFrame = [text boundingRectWithSize:CGSizeMake(width, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
	return neededFrame.size.height + 4.0f;
}

- (CGFloat)prepareMethodTable {
	NSArray *tableRows = [[TreatmentManager sharedManager] stringsForIndication:_indicationType];

	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2.0f, 5.0f, 2.0f, 5.0f);

	CGFloat width1 = 112.0f;
	CGFloat width2 = 83.0f;
	CGFloat width3 = 83.0f;

	BOOL oddRow = YES;
	CGRect panelFrame = _drinkTableContainer.frame;

	CGFloat top = 0.0f;
	for (NSArray *row in tableRows) {
		NSString *string1 = row[0];
		NSString *string2 = [NSString stringWithFormat:@"%@\r%@", row[1], row[2]];
		NSString *string3 = row[3];

		CGFloat height1 = [self calculateHeightForText:string1 withFont:kIndicationMethodHeaderFont andWidth:width1 - edgeInsets.left - edgeInsets.right];
		CGFloat height2 = [self calculateHeightForText:string2 withFont:kIndicationMethodHeaderFont andWidth:width2 - edgeInsets.left - edgeInsets.right];
		CGFloat height3 = [self calculateHeightForText:string3 withFont:kIndicationMethodHeaderFont andWidth:width3 - edgeInsets.left - edgeInsets.right];

		CGFloat rowHeight = MAX(height1, MAX(height2, height3));

		InsetLabel *headLabel = [[InsetLabel alloc] initWithFrame:CGRectMake(0.0f, top, width1, rowHeight)];
		headLabel.edgeInsets = edgeInsets;
		headLabel.lineBreakMode = NSLineBreakByWordWrapping;
		headLabel.numberOfLines = 0;
		[headLabel setFont:kIndicationMethodHeaderFont];
		[headLabel setText:string1];
		headLabel.backgroundColor = oddRow ? kIndicationMethodRowColor1 : kIndicationMethodRowColor2;
		[_drinkTableContainer addSubview:headLabel];

		InsetLabel *textLabel1 = [[InsetLabel alloc] initWithFrame:CGRectMake(width1 + 1.0f, top, width2, rowHeight)];
		textLabel1.edgeInsets = edgeInsets;
		textLabel1.lineBreakMode = NSLineBreakByWordWrapping;
		textLabel1.numberOfLines = 0;
		[textLabel1 setFont:kIndicationMethodTextFont];
		[textLabel1 setText:string2];
		textLabel1.backgroundColor = oddRow ? kIndicationMethodRowColor1 : kIndicationMethodRowColor2;
		[_drinkTableContainer addSubview:textLabel1];

		InsetLabel *textLabel2 = [[InsetLabel alloc] initWithFrame:CGRectMake(width1 + width2 + 2.0f, top, width3, rowHeight)];
		textLabel2.edgeInsets = edgeInsets;
		textLabel2.lineBreakMode = NSLineBreakByWordWrapping;
		textLabel2.numberOfLines = 0;
		[textLabel2 setFont:kIndicationMethodTextFont];
		[textLabel2 setText:string3];
		textLabel2.backgroundColor = oddRow ? kIndicationMethodRowColor1 : kIndicationMethodRowColor2;
		[_drinkTableContainer addSubview:textLabel2];

		top += rowHeight + 1.0f;
		oddRow = !oddRow;
	}

	panelFrame.size.height = top - 1.0f;

	return panelFrame.origin.y + panelFrame.size.height + 20.0f;
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
	[self.durationLabel setFrame:CGRectMake(self.durationLabel.frame.origin.x, self.durationLabel.frame.origin.y, durationLabelFrame.size.width, durationLabelFrame.size.height)];

	_desiredDurationHeight = self.durationLabel.frame.origin.y + durationLabelFrame.size.height + 20.0f;


	_desiredDrinkHeight = [self prepareMethodTable];


	UIBarButtonItem *calendarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(calendar)];

	UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];

	NSArray *buttonsArray = @[settingsItem, calendarItem];
	self.navigationItem.rightBarButtonItems = buttonsArray;

	if (_historyItem) {
		_startDate = _historyItem.startDate;
	} else {
		_startDate = _amActive ? [[TreatmentManager sharedManager] indicationActivation] : [NSDate date];
	}
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:_startDate];
	[self updateDateShown];

	_datePicker = [[UIDatePicker alloc] init];
	_datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[[LanguageManager sharedManager] currentLangId]];
	_datePicker.datePickerMode = UIDatePickerModeDate;

	[_datePicker setDate:_startDate animated:NO];
	[_datePicker setMinimumDate:_startDate];

	[dateComponents setYear:dateComponents.year + 1];
	[_datePicker setMaximumDate:[gregorian dateFromComponents:dateComponents]];

	self.dummyField.inputView = _datePicker;
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
		[[TreatmentManager sharedManager] cancelActiveTreatment];
		_startDate = [NSDate date];
		[self updateDateShown];
		[self.navigationController popViewControllerAnimated:YES];
	} else {
		[[TreatmentManager sharedManager] startTreatmentForIndication:self.indicationType fromDate:_startDate];
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:___(@"confirmation_title")
														  message:___(@"confirmation_desc")
														 delegate:self
												cancelButtonTitle:___(@"confirmation_back")
												otherButtonTitles:nil];

		[message show];
	}
	[self updateViewActivation];
}

- (IBAction)datePressed:(UIButton *)sender {
	if (_justShowInfo)
		return;

	[self.dummyField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)cancelEdit:(UIBarButtonItem *)sender {
	[self.dummyField resignFirstResponder];
}

- (void)doneEditing:(UIBarButtonItem *)sender {
	[self.dummyField resignFirstResponder];
	self.startDate = _datePicker.date;
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
	toolBar.barStyle = UIBarStyleDefault;
	toolBar.tintColor = [UIColor darkGrayColor];

	UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ikona-zapri.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)];
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ikona-puscica_dol.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(doneEditing:)];
	[toolBar setItems:[NSArray arrayWithObjects:cancelBtn, flexibleItem, doneBtn, nil]];

	textField.inputAccessoryView = toolBar;

	[_datePicker setDate:_startDate animated:NO];

	return YES;
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
