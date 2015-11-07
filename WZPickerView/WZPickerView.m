//
//  WZPickerView.m
//
//  A picker with two types, UIPickerView or UIDatePicker.
//  Contains with a black transparent view and a toolbar with "Cancel" and "Done" button.
//
//  Build with "Masonry" - A powerful autolayout library.
//  https://github.com/SnapKit/Masonry
//

#import "WZPickerView.h"

@interface WZPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign, nonatomic) WZPickerViewType pickerType;

@property (strong, nonatomic) UIView *blockView;
@property (strong, nonatomic) UIView *inputView;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIView *divider;

@property (strong, nonatomic) NSDate *selectedDate;
@property (assign, nonatomic) NSInteger selectedPickerIndex;

@end

@implementation WZPickerView
@synthesize delegate, datePicker, pickerView, pickerType, blockView, inputView, toolBar, divider, selectedDate, selectedPickerIndex;

#pragma mark - Override Methods
- (void)setDelegate:(id<WZPickerViewDelegate>)aDelegate {
    delegate = aDelegate;
    
    if (pickerView) {
        [pickerView reloadAllComponents];
    }
}

- (void)updateConstraints {
    if (self.superview) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superview.mas_top);
            make.bottom.equalTo(self.superview.mas_bottom);
            make.left.equalTo(self.superview.mas_left);
            make.right.equalTo(self.superview.mas_right);
        }];
    }
    
    [super updateConstraints];
}

#pragma mark - init
+ (WZPickerView *)showPickerOnView:(UIView *)view WithPickerType:(WZPickerViewType)type {
    
    WZPickerView *pickerView = [[WZPickerView alloc] initWithType:type];
    [view addSubview:pickerView];
    [pickerView layoutIfNeeded];
    
    [pickerView show];
    
    return pickerView;
}

- (instancetype)initWithType:(WZPickerViewType)type {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
        
        pickerType = type;
        
        [self createBlockView];
        [self createInputView];
        [self createToolBar];
        [self createPicker];
        [self createDivider];
    }
    
    return self;
}

- (void)createBlockView {
    blockView = [[UIView alloc] init];
    blockView.alpha = 0.0;
    blockView.backgroundColor = [UIColor blackColor];
    [self addSubview:blockView];
    
    UITapGestureRecognizer *tapOnBlockView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed)];
    [blockView addGestureRecognizer:tapOnBlockView];
    
    [blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)createInputView {
    inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    [self addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.height.equalTo(@206);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)createToolBar {
    toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.translucent = YES;
    toolBar.backgroundColor = [UIColor whiteColor];
    [inputView addSubview:toolBar];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    UIBarButtonItem *spaceBetween = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [toolBar setItems:@[cancelButton,spaceBetween,doneButton]];
    
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_top);
        make.height.equalTo(@44);
        make.left.equalTo(inputView.mas_left);
        make.right.equalTo(inputView.mas_right);
    }];
}

- (void)createPicker {
    switch (pickerType) {
        case WZPickerViewTypeDate:{
            datePicker = [[UIDatePicker alloc] init];
            [inputView addSubview:datePicker];
            
            [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(toolBar.mas_bottom);
                make.left.equalTo(inputView.mas_left);
                make.right.equalTo(inputView.mas_right);
                make.bottom.equalTo(inputView.mas_bottom);
            }];
            
            break;
        }
            
        case WZPickerViewTypePicker:{
            pickerView = [[UIPickerView alloc] init];
            pickerView.dataSource = self;
            pickerView.delegate = self;
            [inputView addSubview:pickerView];
            
            [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(toolBar.mas_bottom);
                make.left.equalTo(inputView.mas_left);
                make.right.equalTo(inputView.mas_right);
                make.bottom.equalTo(inputView.mas_bottom);
            }];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)createDivider {
    divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor darkGrayColor];
    [inputView addSubview:divider];
    
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolBar.mas_bottom);
        make.height.equalTo(@1);
        make.left.equalTo(inputView.mas_left);
        make.right.equalTo(inputView.mas_right);
    }];
}

#pragma mark - Button Actions
- (void)cancelButtonPressed {
    [self hide:^{
        switch (pickerType) {
            case WZPickerViewTypeDate:
                datePicker.date = selectedDate;
                break;
                
            case WZPickerViewTypePicker:
                [pickerView selectRow:selectedPickerIndex inComponent:0 animated:NO];
                break;
                
            default:
                break;
        }
    }];
}

- (void)doneButtonPressed:(UIBarButtonItem *)button {
    [self hide:nil];
    
    if ([delegate respondsToSelector:@selector(WZPickerView:doneButtonPressed:)]) {
        [delegate WZPickerView:self doneButtonPressed:button];
    }
}

#pragma mark - Public Methods
- (void)show {
    self.userInteractionEnabled = YES;
    
    switch (pickerType) {
        case WZPickerViewTypeDate:
            selectedDate = datePicker.date;
            break;
            
        case WZPickerViewTypePicker:
            selectedPickerIndex = [pickerView selectedRowInComponent:0];
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        blockView.alpha = 0.7;
        [inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@206);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        [self layoutIfNeeded];
    }];
}

- (void)hide:(void (^)(void))completion {
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        blockView.alpha = 0.0;
        [inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.height.equalTo(@206);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([delegate respondsToSelector:@selector(WZPickerView:numberOfRowsInComponent:)]) {
        return [delegate WZPickerView:self numberOfRowsInComponent:component];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([delegate respondsToSelector:@selector(WZPickerView:titleForRow:forComponent:)]) {
        return [delegate WZPickerView:self titleForRow:row forComponent:component];
    }
    
    return @"";
}

@end
