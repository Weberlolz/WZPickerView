## WZPickerView
A picker with two types, UIPickerView or UIDatePicker.
Contains with a black transparent view and a toolbar with "Cancel" and "Done" button.

Build with ["Masonry"](https://github.com/SnapKit/Masonry) - A powerful autolayout library.
https://github.com/SnapKit/Masonry

## Usage
Link files into ypur project.
If "Masonry" is already used in yor project, no needed to link it again.

Import header
```objective-c
#import "WZPickerView.h"
```

After import, call
```objective-c
WZPickerView *pickerView = [WZPickerView showPickerOnView:yourView WithPickerType:(WZPickerViewType)type];
```
or
```objective-c
WZPickerView *pickerView = [[WZPickerView alloc] initWithType:(WZPickerViewType)type];
[yourView addSubview:pickerView];
[pickerView show];
```
This will create a view and show it on the screen.

## Delegate
```objective-c
@required
- (void)WZPickerView:(WZPickerView *)pickerView doneButtonPressed:(UIBarButtonItem *)button;
```
This method will be called when the "Done" button pressed.

```objective-c
@optional
- (NSInteger)WZPickerView:(WZPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)WZPickerView:(WZPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
```
These methods are used to set data source and delegate for picker view, so no needed when picker type is `WZPickerViewTypeDate`.