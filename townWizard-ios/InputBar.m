//
//  InputBar.m
//  iGetBest
//
//  Created by Eugen Pavluk on 5/28/10.
//  Copyright 2010 MLS Automatization. All rights reserved.
//

#import "InputBar.h"


@implementation InputBar

@synthesize pickerView;

- (void) initWithDelegate:(id<UIPickerViewDelegate, UIPickerViewDataSource>)owner andPickerValue:(NSInteger)nValue {
	pickerView = [[[UIPickerView alloc] init] autorelease];
	pickerView.delegate = owner;
	pickerView.dataSource = owner;
	pickerView.showsSelectionIndicator = YES;
	[self addSubview:pickerView];
	[pickerView selectRow:nValue inComponent:0 animated:NO];
	if ([pickerView numberOfComponents] == 2) {
		[pickerView selectRow:nValue inComponent:1 animated:NO];
	}
}


@end
