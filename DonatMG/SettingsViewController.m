//
//	SettingsViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsManager.h"
#import "LanguageManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize containerView = _containerView;
@synthesize languageField = _languageField;
@synthesize saveButton = _saveButton;
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

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	self.saveButton.titleLabel.font = kSettingsButtonFont;
	self.legalLabel.font = kLegalFont;
	self.legalButton.titleLabel.font = kBoldTextFont;

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

	UIPickerView *picker = [[UIPickerView alloc] init];
	picker.dataSource = self;
	picker.delegate = self;
	self.languageField.inputView = picker;
	self.mealsField.inputView = picker;

	UIDatePicker *datePicker = [[UIDatePicker alloc] init];
	datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:[[LanguageManager sharedManager] currentLangId]];
	datePicker.datePickerMode = UIDatePickerModeTime;
	datePicker.minuteInterval = 1;

	self.wakeField.inputView = datePicker;
	self.breakfastField.inputView = datePicker;
	self.lunchField.inputView = datePicker;
	self.dinnerField.inputView = datePicker;
	self.sleepField.inputView = datePicker;

	self.mealsField.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[SettingsManager sharedManager] numberOfMeals]];
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
	[_fieldBeingEdited resignFirstResponder];
}

- (void)doneEditing:(UIBarButtonItem *)sender {
	[_fieldBeingEdited resignFirstResponder];
}

- (IBAction)savePressed:(UIButton *)sender {
	// TODO: discuss, as it doesn't make sense, to have this here, because things are saved on the go (as defined in the HIG)
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	_fieldBeingEdited = textField;

	if (textField == self.languageField) {
		_amEditingLanguage = YES;
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
	}

	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
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
		return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (_amEditingLanguage)
		return [[LanguageManager sharedManager] languages][row];
	else
		return [NSString stringWithFormat:@"%ld", row+1];
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
	} else {
		self.mealsField.text = [NSString stringWithFormat:@"%ld", row+1];
		[self.mealsField resignFirstResponder];

		[[SettingsManager sharedManager] setNumberOfMeals:row+1];
	}
}

@end
