//
//	SettingsViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 29/06/14.
//	Copyright (c) 2014 renderspace.si. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsManager.h"
#import "TreatmentManager.h"
#import "Appirater.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;
@synthesize languageField = _languageField;
@synthesize saveButton = _saveButton;
@synthesize rateButton = _rateButton;
@synthesize legalButton = _legalButton;
@synthesize legalLabel = _legalLabel;
@synthesize wakeLabel = _wakeLabel;
@synthesize wakeField = _wakeField;
@synthesize breakfastLabel = _breakfastLabel;
@synthesize breakfastField = _breakfastField;
@synthesize lunchLabel = _lunchLabel;
@synthesize lunchField = _lunchField;
@synthesize dinnerLabel = _dinnerLabel;
@synthesize dinnerField = _dinnerField;
@synthesize sleepLabel = _sleepLabel;
@synthesize sleepField = _sleepField;
@synthesize mealsLabel = _mealsLabel;
@synthesize mealsField = _mealsField;

- (void)setLanguageShown {
	LanguageManager *langManager = [LanguageManager sharedManager];
	self.languageField.text = [langManager languageForId:langManager.currentLangId];
}

- (NSString *)timeToString:(NSDateComponents *)time {
	return [NSString stringWithFormat:@"%2lu:%02lu", (unsigned long)time.hour, (unsigned long)time.minute, nil];
}

- (void)calendar {
	[self performSegueWithIdentifier:@"showCalendar" sender:self];
}

- (void)settings {
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	self.scrollView.contentSize = CGSizeMake(self.containerView.frame.size.width + 40.0f, self.containerView.frame.size.height + 20.0f);

	self.saveButton.titleLabel.font = kSettingsButtonFont;
	self.legalLabel.font = kLegalFont;
	self.legalButton.titleLabel.font = kBoldTextFont;
	//self.rateButton.titleLabel.font = kBoldTextFont;
    [self.rateButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.0f]];

	self.wakeLabel.font = kSettingsLabelFont;
	self.breakfastLabel.font = kSettingsLabelFont;
	self.lunchLabel.font = kSettingsLabelFont;
	self.dinnerLabel.font = kSettingsLabelFont;
	self.sleepLabel.font = kSettingsLabelFont;
	self.mealsLabel.font = kSettingsLabelFont;

	self.languageField.font = kSettingsLabelFont;
	self.languageField.tintColor = [UIColor clearColor];

	self.wakeField.font = kSettingsLabelFont;
	self.wakeField.tintColor = [UIColor clearColor];

	self.breakfastField.font = kSettingsLabelFont;
	self.breakfastField.tintColor = [UIColor clearColor];

	self.lunchField.font = kSettingsLabelFont;
	self.lunchField.tintColor = [UIColor clearColor];

	self.dinnerField.font = kSettingsLabelFont;
	self.dinnerField.tintColor = [UIColor clearColor];

	self.sleepField.font = kSettingsLabelFont;
	self.sleepField.tintColor = [UIColor clearColor];

	self.mealsField.font = kSettingsLabelFont;
	self.mealsField.tintColor = [UIColor clearColor];

	[self setLanguageShown];

	_picker = [[UIPickerView alloc] init];
	_picker.dataSource = self;
	_picker.delegate = self;
	self.languageField.inputView = _picker;
	self.mealsField.inputView = _picker;

	_datePicker = [[UIDatePicker alloc] init];

	_datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"sl"];
	_datePicker.datePickerMode = UIDatePickerModeTime;
	_datePicker.minuteInterval = 1;

	self.wakeField.inputView = _datePicker;
	self.breakfastField.inputView = _datePicker;
	self.lunchField.inputView = _datePicker;
	self.dinnerField.inputView = _datePicker;
	self.sleepField.inputView = _datePicker;

	self.wakeField.text = [self timeToString:[[SettingsManager sharedManager] wakeTime]];
	self.breakfastField.text = [self timeToString:[[SettingsManager sharedManager] breakfastTime]];
	self.lunchField.text = [self timeToString:[[SettingsManager sharedManager] lunchTime]];
	self.dinnerField.text = [self timeToString:[[SettingsManager sharedManager] dinnerTime]];
	self.sleepField.text = [self timeToString:[[SettingsManager sharedManager] sleepingTime]];

	self.mealsField.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[SettingsManager sharedManager] numberOfMeals]];

	UIBarButtonItem *calendarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"calendar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(calendar)];

	UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"settings-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
	settingsItem.enabled = NO;

	NSArray *buttonsArray = @[settingsItem, calendarItem];
	self.navigationItem.rightBarButtonItems = buttonsArray;
}

- (IBAction)langaugeClick:(id)sender {
	[self.languageField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)setLanguageStrings {
	self.wakeLabel.text = ___(@"zbujanje");
	self.breakfastLabel.text = ___(@"zajtrk");
	self.lunchLabel.text = ___(@"kosilo");
	self.dinnerLabel.text = ___(@"vecerja");
	self.sleepLabel.text = ___(@"spanje");
	self.mealsLabel.text = ___(@"obrokov");

	self.legalLabel.text = ___(@"licence");
	[self.saveButton setTitle:___(@"save") forState:UIControlStateNormal];
	[self.legalButton setTitle:___(@"terms_of_use") forState:UIControlStateNormal];
	[self.rateButton setTitle:___(@"rate_title") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// hide the title while view controller is visible
	self.title = @"";

	[self setLanguageStrings];
}

- (IBAction)legalPressed:(id)sender {
	[self performSegueWithIdentifier:@"showLegal" sender:self];
}

- (IBAction)ratePressed:(id)sender {
	[Appirater rateApp];
}

- (IBAction)settingPressed:(UIButton *)sender {
	switch (sender.tag) {
		case 1:
			[self.wakeField becomeFirstResponder];
			break;
		case 2:
			[self.breakfastField becomeFirstResponder];
			break;
		case 3:
			[self.lunchField becomeFirstResponder];
			break;
		case 4:
			[self.dinnerField becomeFirstResponder];
			break;
		case 5:
			[self.sleepField becomeFirstResponder];
			break;
		case 6:
			[self.mealsField becomeFirstResponder];
			break;
		default:
			break;
	}
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// set the title so the "back" button will be shown with the appropriate title
	self.title = NSLocalizedString(@"settings_title", nil);
}

#pragma mark -
#pragma mark Editing responders

- (void)cancelEdit:(UIBarButtonItem *)sender {
	_shouldSave = NO;
	[_fieldBeingEdited resignFirstResponder];
}

- (void)doneEditing:(UIBarButtonItem *)sender {
	_shouldSave = YES;
	[_fieldBeingEdited resignFirstResponder];
}

- (IBAction)savePressed:(UIButton *)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	_fieldBeingEdited = textField;

	if (textField == self.languageField) {
		_amEditingLanguage = YES;

		NSString *langId = [[LanguageManager sharedManager] currentLangId];
		NSInteger select = 0;

		if ([langId isEqualToString:@"sl"]) {
			select = 1;
		} else if ([langId isEqualToString:@"ru"]) {
			select = 2;
		} else if ([langId isEqualToString:@"hr"]) {
			select = 3;
        } else if ([langId isEqualToString:@"it"]) {
            select = 4;
        } else if ([langId isEqualToString:@"de"]) {
            select = 5;
		}

		[_picker reloadAllComponents];
		[_picker selectRow:select inComponent:0 animated:NO];
	} else if (textField == self.mealsField) {
		_amEditingLanguage = NO;
		[_picker reloadAllComponents];
		[_picker selectRow:[[SettingsManager sharedManager] numberOfMeals]-3 inComponent:0 animated:NO];
	} else {
		_amEditingLanguage = NO;

		UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
		toolBar.barStyle = UIBarStyleDefault;
		toolBar.tintColor = [UIColor darkGrayColor];

		UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ikona-zapri.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)];
		UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ikona-puscica_dol.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(doneEditing:)];
		[toolBar setItems:[NSArray arrayWithObjects:cancelBtn, flexibleItem, doneBtn, nil]];

		textField.inputAccessoryView = toolBar;

		NSDateComponents *dateComponents = nil;
		if (textField == self.wakeField) {
			dateComponents = [[SettingsManager sharedManager] wakeTime];
		} else if (textField == self.breakfastField) {
			dateComponents = [[SettingsManager sharedManager] breakfastTime];
		} else if (textField == self.lunchField) {
			dateComponents = [[SettingsManager sharedManager] lunchTime];
		} else if (textField == self.dinnerField) {
			dateComponents = [[SettingsManager sharedManager] dinnerTime];
		} else if (textField == self.sleepField) {
			dateComponents = [[SettingsManager sharedManager] sleepingTime];
		}

		NSDate * now = [[NSDate alloc] init];
		NSCalendar *cal = [NSCalendar currentCalendar];
		NSDateComponents *comps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
		[comps setHour:dateComponents.hour];
		[comps setMinute:dateComponents.minute];
		NSDate *date = [cal dateFromComponents:comps];
		[_datePicker setDate:date animated:NO];
	}

	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (_shouldSave) {
		NSDate *date = [_datePicker date];
		NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];

		if (textField == self.wakeField) {
			[[SettingsManager sharedManager] setWakeTime:components];
			self.wakeField.text = [self timeToString:[[SettingsManager sharedManager] wakeTime]];
			[[TreatmentManager sharedManager] recalculateTreatment];
		} else if (textField == self.breakfastField) {
			[[SettingsManager sharedManager] setBreakfastTime:components];
			self.breakfastField.text = [self timeToString:[[SettingsManager sharedManager] breakfastTime]];
			[[TreatmentManager sharedManager] recalculateTreatment];
		} else if (textField == self.lunchField) {
			[[SettingsManager sharedManager] setLunchTime:components];
			self.lunchField.text = [self timeToString:[[SettingsManager sharedManager] lunchTime]];
			[[TreatmentManager sharedManager] recalculateTreatment];
		} else if (textField == self.dinnerField) {
			[[SettingsManager sharedManager] setDinnerTime:components];
			self.dinnerField.text = [self timeToString:[[SettingsManager sharedManager] dinnerTime]];
			[[TreatmentManager sharedManager] recalculateTreatment];
		} else if (textField == self.sleepField) {
			[[SettingsManager sharedManager] setSleepingTime:components];
			self.sleepField.text = [self timeToString:[[SettingsManager sharedManager] sleepingTime]];
			[[TreatmentManager sharedManager] recalculateTreatment];
		}
	}
	_fieldBeingEdited = nil;
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (_amEditingLanguage)
		return [[LanguageManager sharedManager] languages].count;
	else
		return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (_amEditingLanguage)
		return [[LanguageManager sharedManager] languages][row];
	else
		return [NSString stringWithFormat:@"%u", (unsigned int)row+3];
}

#pragma mark -
#pragma mark PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (_amEditingLanguage) {
		NSString *language = [[LanguageManager sharedManager] languages][row];

		self.languageField.text = language;
		[self.languageField resignFirstResponder];

		NSString *localeId = [[LanguageManager sharedManager] idForLanguage:language];

		[[LanguageManager sharedManager] setLanguageId:localeId];

		[[SettingsManager sharedManager] setAppLanguage:localeId];

		[self setLanguageStrings];

		[self.navigationController popToRootViewControllerAnimated:YES];
	} else {
		self.mealsField.text = [NSString stringWithFormat:@"%u", (unsigned int)row+3];
		[self.mealsField resignFirstResponder];

		[[SettingsManager sharedManager] setNumberOfMeals:row+3];

		[[TreatmentManager sharedManager] recalculateTreatment];
	}
}

@end
