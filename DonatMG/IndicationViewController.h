//
//	IndicationViewController.h
//	DonatMG
//
//	Created by Goran Blažič on 01/06/14.
//	Copyright (c) 2014 goranche.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicationViewController : UIViewController {
	BOOL _amActive;
	CGFloat _storedDrinkPanelHeight;
	CGFloat _storedDurationPanelHeight;
}

@property (atomic, assign) IndicationType indicationType;

@property (nonatomic, strong) IBOutlet UIButton *bigButton;

@property (nonatomic, strong) IBOutlet UIView *drinkPanel;
@property (nonatomic, strong) IBOutlet UIView *durationPanel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *drinkPanelHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *durationPanelHeight;

@property (nonatomic, strong) IBOutlet UIButton *drinkButton;
@property (nonatomic, strong) IBOutlet UIButton *durationButton;

@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) IBOutlet UILabel *drinkTitle;
@property (nonatomic, strong) IBOutlet UILabel *selectTitle;

@property (nonatomic, strong) IBOutlet UILabel *durationTitle;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

@end
