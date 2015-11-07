//
//  WZPickerView.h
//
//  A picker with two types, UIPickerView or UIDatePicker.
//  Contains with a black transparent view and a toolbar with "Cancel" and "Done" button.
//
//  Build with "Masonry" - A powerful autolayout library.
//  https://github.com/SnapKit/Masonry
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

typedef enum : NSUInteger {
    WZPickerViewTypePicker,
    WZPickerViewTypeDate
} WZPickerViewType;

@class WZPickerView;

@protocol WZPickerViewDelegate <NSObject>

@required
- (void)WZPickerView:(WZPickerView *)pickerView doneButtonPressed:(UIBarButtonItem *)button;

@optional
- (NSInteger)WZPickerView:(WZPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)WZPickerView:(WZPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

@interface WZPickerView : UIView

+ (WZPickerView *)showPickerOnView:(UIView *)view WithPickerType:(WZPickerViewType)type;
- (instancetype)initWithType:(WZPickerViewType)type;

- (void)show;

@property (weak, nonatomic) id<WZPickerViewDelegate> delegate;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *pickerView;

@end
