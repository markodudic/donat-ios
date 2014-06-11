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
}

@property (atomic, assign) IndicationType indicationType;

@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@end
