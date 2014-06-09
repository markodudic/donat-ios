//
//	IndicationViewController.m
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import "IndicationViewController.h"
#import "SettingsManager.h"

@interface IndicationViewController ()

@end

@implementation IndicationViewController

@synthesize indicationType = _indicationType;

- (void)updateViewActivation {
	_amActive = [[SettingsManager sharedManager] activeIndication] == _indicationType;
	[self.bigButton setTitle:_amActive ? ___(@"button_indication_stop") : ___(@"button_indication_start") forState:UIControlStateNormal];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.view insertSubview:[[UIImageView alloc] initWithImage:
							  [UIImage imageNamed:IS_IPHONE_5 ? @"back-5.png" : @"back-4.png"]]
					 atIndex:0];

	UIFont *titlesFont = [UIFont fontWithName:@"Roboto-Medium" size:18.0f];
	UIFont *subtitlesFont = [UIFont fontWithName:@"Roboto-Medium" size:16.0f];
	UIFont *textFont = [UIFont fontWithName:@"Roboto-Light" size:14.0f];

	[self.titleLabel setFont:titlesFont];
	[self.bigButton.titleLabel setFont:titlesFont];
	[self.drinkTitle setFont:subtitlesFont];
	[self.durationTitle setFont:subtitlesFont];
	[self.selectTitle setFont:subtitlesFont];
	[self.descriptionLabel setFont:textFont];
	[self.durationLabel setFont:textFont];

	[self updateViewActivation];

	switch (_indicationType) {
		case kZaprtost:
			self.iconView.image = [UIImage imageNamed:@"icon_zaprtost.png"];
			self.titleLabel.text = ___(@"indication_1");
			self.descriptionLabel.text = ___(@"indication_1_desc");
			self.durationLabel.text = ___(@"indication_1_time");
			break;
		case kZgaga:
			self.iconView.image = [UIImage imageNamed:@"icon_zgaga.png"];
			self.titleLabel.text = ___(@"indication_2");
			self.descriptionLabel.text = ___(@"indication_2_desc");
			self.durationLabel.text = ___(@"indication_2_time");
			break;
		case kMagnezij:
			self.iconView.image = [UIImage imageNamed:@"icon_mg.png"];
			self.titleLabel.text = ___(@"indication_3");
			self.descriptionLabel.text = ___(@"indication_3_desc");
			self.durationLabel.text = ___(@"indication_3_time");
			break;
		case kSladkorna:
			self.iconView.image = [UIImage imageNamed:@"icon_sladkorna.png"];
			self.titleLabel.text = ___(@"indication_4");
			self.descriptionLabel.text = ___(@"indication_4_desc");
			self.durationLabel.text = ___(@"indication_4_time");
			break;
		case kSlinavka:
			self.iconView.image = [UIImage imageNamed:@"icon_slinavka.png"];
			self.titleLabel.text = ___(@"indication_5");
			self.descriptionLabel.text = ___(@"indication_5_desc");
			self.durationLabel.text = ___(@"indication_5_time");
			break;
		case kSecniKamni:
			self.iconView.image = [UIImage imageNamed:@"icon_secni_kamni.png"];
			self.titleLabel.text = ___(@"indication_6");
			self.descriptionLabel.text = ___(@"indication_6_desc");
			self.durationLabel.text = ___(@"indication_6_time");
			break;
		case kDebelost:
			self.iconView.image = [UIImage imageNamed:@"icon_debelost.png"];
			self.titleLabel.text = ___(@"indication_7");
			self.descriptionLabel.text = ___(@"indication_7_desc");
			self.durationLabel.text = ___(@"indication_7_time");
			break;
		case kSrceOzilje:
			self.iconView.image = [UIImage imageNamed:@"icon_srce_ozilje.png"];
			self.titleLabel.text = ___(@"indication_8");
			self.descriptionLabel.text = ___(@"indication_8_desc");
			self.durationLabel.text = ___(@"indication_8_time");
			break;
		case kStres:
			self.iconView.image = [UIImage imageNamed:@"icon_stres.png"];
			self.titleLabel.text = ___(@"indication_9");
			self.descriptionLabel.text = ___(@"indication_9_desc");
			self.durationLabel.text = ___(@"indication_9_time");
			break;
		case kPocutje:
			self.iconView.image = [UIImage imageNamed:@"icon_pocutje.png"];
			self.titleLabel.text = ___(@"indication_10");
			self.descriptionLabel.text = ___(@"indication_10_desc");
			self.durationLabel.text = ___(@"indication_10_time");
			break;
		default:
			// TODO: we have a problem
			break;
	}

	_storedDrinkPanelHeight = self.drinkPanel.frame.size.height;
	_storedDurationPanelHeight = self.durationPanel.frame.size.height;

	[self drinkPressed:self];
	[self durationPressed:self];
}

- (IBAction)drinkPressed:(id)sender {
	CGRect frame = self.drinkPanel.frame;

	CGFloat rotationAngle = frame.size.height > 45.0f ? M_PI : 0.0f;
	CGFloat targetHeight = frame.size.height > 45.0f ? 40.0f : _storedDrinkPanelHeight;

	[UIView animateWithDuration:0.33f animations:^{
		self.drinkPanelHeight.constant = targetHeight;
		self.drinkButton.transform = CGAffineTransformMakeRotation(rotationAngle);
	}];
}

- (IBAction)durationPressed:(id)sender {
	CGRect frame = self.durationPanel.frame;

	CGFloat rotationAngle = frame.size.height > 45.0f ? M_PI : 0.0f;
	CGFloat targetHeight = frame.size.height > 45.0f ? 40.0f : _storedDurationPanelHeight;

	[UIView animateWithDuration:0.33f animations:^{
		self.durationPanelHeight.constant = targetHeight;
		self.durationButton.transform = CGAffineTransformMakeRotation(rotationAngle);
	}];
}

- (IBAction)activationPressed:(id)sender {
	if (_amActive) {
		[[SettingsManager sharedManager] setActiveIndication:kUnknown];
	} else {
		[[SettingsManager sharedManager] setActiveIndication:self.indicationType];
	}
	[self updateViewActivation];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
