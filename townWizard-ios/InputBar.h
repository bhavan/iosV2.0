//
//  InputBar.h
//  iGetBest
//
//  Created by Eugen Pavluk on 5/28/10.
//  Copyright 2010 MLS Automatization. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GeneralViewController;

@interface InputBar : UIActionSheet {
	UIPickerView		*pickerView;
}

@property (nonatomic, retain) UIPickerView	*pickerView;

- (void) initWithDelegate:(id<UIPickerViewDelegate, UIPickerViewDataSource>)owner andPickerValue:(NSInteger)nValue;

@end
