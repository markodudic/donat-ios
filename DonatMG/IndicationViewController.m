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
	[self.bigButton setTitle:_amActive ? NSLocalizedString(@"deactivate_button", nil) : NSLocalizedString(@"activate_button", nil) forState:UIControlStateNormal];
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
			self.titleLabel.text = NSLocalizedString(@"zaprtost", nil);
			self.descriptionLabel.text = NSLocalizedString(@"zaprtost_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"zaprtost_duration", nil);
			break;
		case kZgaga:
			self.iconView.image = [UIImage imageNamed:@"icon_zgaga.png"];
			self.titleLabel.text = NSLocalizedString(@"zgaga", nil);
			self.descriptionLabel.text = NSLocalizedString(@"zgaga_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"zgaga_duration", nil);
			break;
		case kMagnezij:
			self.iconView.image = [UIImage imageNamed:@"icon_mg.png"];
			self.titleLabel.text = NSLocalizedString(@"mg", nil);
			self.descriptionLabel.text = NSLocalizedString(@"mg_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"mg_duration", nil);
			break;
		case kSladkorna:
			self.iconView.image = [UIImage imageNamed:@"icon_sladkorna.png"];
			self.titleLabel.text = NSLocalizedString(@"sladkorna", nil);
			self.descriptionLabel.text = NSLocalizedString(@"sladkorna_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"sladkorna_duration", nil);
			break;
		case kSlinavka:
			self.iconView.image = [UIImage imageNamed:@"icon_slinavka.png"];
			self.titleLabel.text = NSLocalizedString(@"slinavka", nil);
			self.descriptionLabel.text = NSLocalizedString(@"slinavka_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"slinavka_duration", nil);
			break;
		case kSecniKamni:
			self.iconView.image = [UIImage imageNamed:@"icon_secni_kamni.png"];
			self.titleLabel.text = NSLocalizedString(@"secni_kamni", nil);
			self.descriptionLabel.text = NSLocalizedString(@"secni_kamni_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"secni_kamni_duration", nil);
			break;
		case kDebelost:
			self.iconView.image = [UIImage imageNamed:@"icon_debelost.png"];
			self.titleLabel.text = NSLocalizedString(@"debelost", nil);
			self.descriptionLabel.text = NSLocalizedString(@"debelost_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"debelost_duration", nil);
			break;
		case kSrceOzilje:
			self.iconView.image = [UIImage imageNamed:@"icon_srce_ozilje.png"];
			self.titleLabel.text = NSLocalizedString(@"srce_ozilje", nil);
			self.descriptionLabel.text = NSLocalizedString(@"srce_ozilje_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"srce_ozilje_duration", nil);
			break;
		case kStres:
			self.iconView.image = [UIImage imageNamed:@"icon_stres.png"];
			self.titleLabel.text = NSLocalizedString(@"stres", nil);
			self.descriptionLabel.text = NSLocalizedString(@"stres_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"stres_duration", nil);
			break;
		case kPocutje:
			self.iconView.image = [UIImage imageNamed:@"icon_pocutje.png"];
			self.titleLabel.text = NSLocalizedString(@"pocutje", nil);
			self.descriptionLabel.text = NSLocalizedString(@"pocutje_desc", nil);
			self.durationLabel.text = NSLocalizedString(@"pocutje_duration", nil);
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
