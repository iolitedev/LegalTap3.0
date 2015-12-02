//
//  CDatePickerViewEx.h
//  LegalTap
//
//  Created by Apptunix on 3/3/15.
//  Copyright (c) 2015 apptunix. All rights reserved.
//
@protocol CDatePickerViewExDelegate;

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIColor *monthSelectedTextColor;
@property (nonatomic, strong) UIColor *monthTextColor;

@property (nonatomic, strong) UIColor *yearSelectedTextColor;
@property (nonatomic, strong) UIColor *yearTextColor;

@property (nonatomic, strong) UIFont *monthSelectedFont;
@property (nonatomic, strong) UIFont *monthFont;

@property (nonatomic, strong) UIFont *yearSelectedFont;
@property (nonatomic, strong) UIFont *yearFont;

@property (nonatomic, assign) NSInteger rowHeight;

@property (nonatomic, strong) NSString *selectMonth;
@property (nonatomic, strong) NSString *selectYear;

@property (nonatomic, strong) id<CDatePickerViewExDelegate> dataDelegate;


@property (nonatomic, strong, readonly) NSDate *date;

-(void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear;
-(void)selectToday;

@end

@protocol CDatePickerViewExDelegate <NSObject>
@optional

-(void)CDatePickerViewEx:(CDatePickerViewEx *)pickerView didSelectDate:(NSString*)selectDate;

@end