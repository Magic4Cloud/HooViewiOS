//
//  EVUserSettingCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//



#import "EVUserSettingCell.h"
#import "EVBaseObject.h"
#import "EVLoginInfo.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "EVUserTagsView.h"

#define MAX_STARWORDS_LENGTH 10

@interface CCProvince : EVBaseObject

@property (nonatomic,copy) NSString *name;  // 省名
@property (nonatomic,copy) NSArray *cities; // 省内城市

@end

@implementation CCProvince

@end

@implementation CCUserSettingItem

@end

@interface EVUserSettingCell () <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TextFiledLeftCon;

@property (nonatomic, weak) IBOutlet UILabel *settingTltieLabel;    // 行名
@property (nonatomic, weak) IBOutlet UITextField *contentTextField; // 内容

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@property (nonatomic, strong) NSArray *provices;                     // 省
@property (nonatomic, assign) NSInteger provinceIndex;               // 省的序号
@property (nonatomic, assign) NSInteger cityIndex;                   // 城市序号

@property (nonatomic, strong) UIPickerView *pickerView;              // 选择器


@property (nonatomic, weak) UILabel *signatureLabel;               // 个性签名
@property (nonatomic, weak) UILabel *introduceLabel;               // 详细资料

@property (nonatomic, strong) UIButton *indicateImageView;        // 右箭头

@property (nonatomic, assign) BOOL hasMannueChanged;

@property (nonatomic,copy) NSString *constellation;



@end

@implementation EVUserSettingCell

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
}

- (void)textFiledResignFirstResponse
{
    [self.contentTextField resignFirstResponder];
}
- (void)textFieldBecomeFirstResponse {
    [self.contentTextField becomeFirstResponder];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.settingTltieLabel.textColor = [UIColor evTextColorH2];
    
    self.headImageView.clipsToBounds = YES;
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.backgroundColor = [UIColor clearColor];
    
    self.contentTextField.tintColor = [UIColor textBlackColor];
    self.contentTextField.textColor = [UIColor colorWithHexString:@"#cccccc"];
    self.contentTextField.delegate = self;
   
    self.indicateImageView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.indicateImageView.hidden = NO;
    self.indicateImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_indicateImageView];
    [self.indicateImageView setImage:[UIImage imageNamed:@"btn_next_n"] forState:(UIControlStateNormal)];
    [_indicateImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_indicateImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [_indicateImageView autoSetDimension:ALDimensionHeight toSize:40];
    [_indicateImageView autoSetDimension:ALDimensionWidth toSize:40];
    
    CGFloat accessViewHeight = 49;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, accessViewHeight)];
    view.backgroundColor = [UIColor colorWithHexString:@"#d7d7d7"];
    self.contentTextField.inputAccessoryView = view;
    
    UIButton *comfirButton = [[UIButton alloc] init];
    comfirButton.tag = 200;
    [comfirButton setTitle:kOK forState:UIControlStateNormal];
    [view addSubview:comfirButton];
    [comfirButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
    [comfirButton autoSetDimension:ALDimensionWidth toSize:100];
    [comfirButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.tag = 100;
    [cancelButton setTitle:kCancel forState:UIControlStateNormal];
    [view addSubview:cancelButton];
    [cancelButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeRight];
    [cancelButton autoSetDimension:ALDimensionWidth toSize:100];
    [cancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self signatureLabel];
    [self introduceLabel];
    
    [EVNotificationCenter addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    EVUserTagsView *userTagsView = [[EVUserTagsView alloc] init];
    [self.contentView addSubview:userTagsView];
    self.userTagsView = userTagsView;
    [userTagsView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:0];
    [userTagsView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:94];
    [userTagsView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [userTagsView autoSetDimension:ALDimensionHeight toSize:20];
}

- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    [self restrictionInputCharLength:textField];
}

- (NSString *)restrictionInputCharLength:(UITextField *)textField
{
    NSString *toBeString = textField.text;
    NSInteger tobeInteger = [toBeString numOfWordWithLimit:10];
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position || !selectedRange)
    {
        if (tobeInteger > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                NSUInteger toBeIndex = [toBeString stringToIndexLength:10];
                NSString *toString = [toBeString substringWithRange:NSMakeRange(0, toBeIndex)];
                textField.text = toString;
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
    return textField.text;
}

- (void)buttonDidClicked:(UIButton *)btn {
    switch ( btn.tag )
    {
        case 100:   // 取消
            break;
        case 200:   // 确定
          
            break;
        default:
            break;
    }
    if ([self.settingItem.settingTitle isEqualToString:kBirthDayTitle]) {
        if (self.constellationB) {
            self.constellationB(self.constellation);
        }
    }
    [self.contentTextField resignFirstResponder];
}

- (void)textChanged {
    if ( [self.settingItem.settingTitle isEqualToString:kNameTitle] )
    {
       NSString *textString =  [self restrictionInputCharLength:self.contentTextField];
        self.settingItem.contentTitle = textString;
        self.settingItem.loginInfo.nickname = textString;
    }
    else if ( [self.settingItem.settingTitle isEqualToString:kSexTitle] )
    {
        NSString *gender = [self.contentTextField.text isEqualToString:kE_GlobalZH(@"e_male")] ? @"male" : @"female";
        self.settingItem.loginInfo.gender = gender;
        self.settingItem.contentTitle = self.contentTextField.text;
    }
    
    else if ( [self.settingItem.settingTitle isEqualToString:kBirthDayTitle] )
    {
        self.settingItem.loginInfo.birthday = self.contentTextField.text;
        self.constellation = self.contentTextField.text;
        //地区
    }
    else if ( [self.settingItem.settingTitle isEqualToString:kLocationTitle] )
    {
        self.settingItem.loginInfo.location = self.contentTextField.text;
    }
    else if ( [self.settingItem.settingTitle isEqualToString:kIntroTitle] )
    {  // 个性签名
    }
    else if ( [self.settingItem.settingTitle isEqualToString:kIntroduceTitle] )
    {  // 详细资料
    }
    else if ([self.settingItem.settingTitle isEqualToString:@"执业证号"]) {
        self.settingItem.contentTitle = self.contentTextField.text;
        self.settingItem.loginInfo.credentials = self.contentTextField.text;
    }
}

- (NSArray *)provices {
    if ( _provices == nil )
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        _provices = [CCProvince objectWithDictionaryArray:array];
    }
    return _provices;
}

- (void)setSettingItem:(CCUserSettingItem *)settingItem
{
    _settingItem = settingItem;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.contentTextField.userInteractionEnabled = settingItem.access;
    self.settingTltieLabel.text = settingItem.settingTitle;
    switch (settingItem.keyBoardType)
    {
        case EVKeyBoardLocation:
            [self setUpLocationKeyBoard];
            break;
        case EVKeyBoardNormal:
            self.contentTextField.inputView = nil;
            break;
        case EVKeyBoardSex:
            [self setUpLocationKeyBoard];
            break;
        default:
            break;
    }

    switch (settingItem.cellStyleType) {
        case EVCellStyleNomal:
        {
            self.contentTextField.text = settingItem.contentTitle;
            self.contentTextField.textColor = [UIColor evTextColorH1];
            self.signatureLabel.hidden = YES;
            self.introduceLabel.hidden = YES;
            self.contentTextField.hidden = NO;
            self.contentTextField.textColor = [UIColor evTextColorH1];
            self.headImageView.hidden = YES;
            self.indicateImageView.hidden = NO;
            self.userTagsView.hidden = YES;
            self.TextFiledLeftCon.constant = 62;
        }
            break;
        case EVCellStyleSignature:
        {
            self.signatureLabel.text = self.settingItem.contentTitle;
            self.signatureLabel.textColor = [UIColor evTextColorH1];
            self.signatureLabel.hidden = NO;
            self.contentTextField.hidden = YES;
            self.headImageView.hidden = YES;
            self.indicateImageView.hidden = NO;
            self.userTagsView.hidden = YES;
            self.TextFiledLeftCon.constant = 62;
        }
            break;
            
        case EVCellStyleIntroduce:
        {
            self.signatureLabel.hidden = NO;
            self.signatureLabel.text = self.settingItem.contentTitle;
            self.introduceLabel.hidden = YES;
            self.signatureLabel.textColor = [UIColor evTextColorH1];
            self.contentTextField.hidden = YES;
            self.headImageView.hidden = YES;
            self.indicateImageView.hidden = NO;
            self.userTagsView.hidden = YES;
            self.TextFiledLeftCon.constant = 62;
        }
            break;

            
        case EVCellStyleHeaderImage:
        {
            self.signatureLabel.hidden = YES;
            self.contentTextField.hidden = YES;
            self.headImageView.hidden = NO;
            self.indicateImageView.hidden = NO;
            self.contentTextField.placeholder = settingItem.placeHolder;
            self.signatureLabel.text = settingItem.placeHolder;
            self.signatureLabel.textColor = [UIColor evTextColorH1];
             self.userTagsView.hidden = YES;
            [self.headImageView cc_setImageWithURLString:settingItem.logoUrl placeholderImage:[UIImage imageNamed:@"login_icon_default"]];
            if (settingItem.logoImage == nil) {
                break;
            }
            self.headImageView.image = settingItem.logoImage;
            self.TextFiledLeftCon.constant = 62;
        }
            break;
            
        case EVCellStyleName:
        {
            self.contentTextField.text = settingItem.contentTitle;
            self.contentTextField.textColor = [UIColor evTextColorH1];
            self.signatureLabel.hidden = YES;
            self.contentTextField.hidden = NO;
            self.contentTextField.textColor = [UIColor evTextColorH1];
            self.headImageView.hidden = YES;
            self.indicateImageView.hidden = YES;
            self.userTagsView.hidden = YES;
            self.TextFiledLeftCon.constant = 62;
        }
            break;
     case EVCellStyleTags:
        {
            self.signatureLabel.hidden = YES;
            self.contentTextField.hidden = YES;
            self.headImageView.hidden = YES;
            self.contentTextField.hidden = YES;
            self.indicateImageView.hidden = NO;
            self.userTagsView.hidden = NO;
            self.TextFiledLeftCon.constant = 62;
        }
            break;
    case EVCellStylePreNum:
        {
            self.contentTextField.text = settingItem.contentTitle;
            self.contentTextField.textColor = [UIColor evTextColorH1];
            self.signatureLabel.hidden = YES;
            self.contentTextField.hidden = NO;
            self.headImageView.hidden = YES;
            self.contentTextField.hidden = NO;
            self.indicateImageView.hidden = YES;
            self.userTagsView.hidden = YES;
            self.TextFiledLeftCon.constant = 94;
        }
            break;
        default:
            break;
    }
    
}

- (void)setUpLocationKeyBoard {
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    // 设置数据源 和 代理
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.contentTextField.inputView = pickerView;
    
    int originalSelectedComponent_0_row = 0;
    int originalSelectedComponent_1_row = 0;
    
    if ( self.settingItem.keyBoardType == EVKeyBoardLocation )
    {
        NSString *orignalProvince = nil;
        NSString *orignalCity = nil;
        NSRange range ;
        if ( self.settingItem.contentTitle || ![self.settingItem.contentTitle isEqualToString:@""] )
        {
            range = [self.settingItem.contentTitle rangeOfString:@" "];
            if ( range.location != NSNotFound )
            {
                orignalProvince = [self.settingItem.contentTitle substringToIndex:range.location];
                orignalCity = [self.settingItem.contentTitle substringFromIndex:range.location + range.length];
            }
            else
            {
                orignalProvince = @"福建";
                orignalCity = @"福州";
            }
        }
        BOOL find = NO;
        for (int i = 0; i < self.provices.count; ++i)
        {
            CCProvince *province = self.provices[i];
            
            if ( orignalProvince && [province.name isEqualToString:orignalProvince] )
            {
                originalSelectedComponent_0_row = i;
                
                NSArray *cities = province.cities;
                for (int j = 0; j < cities.count; ++j)
                {
                    NSString *city = cities[j];
                    if ( [city isEqualToString:orignalCity] )
                    {
                        originalSelectedComponent_1_row = j;
                        find = YES;
                        break;
                    }
                }
                if ( find )
                {
                    break;
                }
            }
        }
        self.provinceIndex = originalSelectedComponent_0_row;
        self.cityIndex = originalSelectedComponent_1_row;
        [pickerView selectRow:originalSelectedComponent_0_row inComponent:0 animated:YES];
    }
    else if ( self.settingItem.keyBoardType == EVKeyBoardSex )
    {
        originalSelectedComponent_0_row = [self.settingItem.contentTitle isEqualToString:kE_GlobalZH(@"e_male")] ? 0 : 1;
        self.provinceIndex = originalSelectedComponent_0_row;
        [pickerView selectRow:originalSelectedComponent_0_row inComponent:0 animated:YES];
    }
}

- (void)setUpDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    self.contentTextField.inputView = datePicker;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//时间格式
    NSString * dateStr = @"1990-05-19 12:23:55";//设定默认时间
    NSDate * date = [dateFormatter dateFromString:dateStr];
    [datePicker setDate:date animated:YES];
}

- (void)dateChanged:(id)sender
{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    UIDatePicker* control = (UIDatePicker*)sender;
    
    if ( !self.hasMannueChanged && self.settingItem.contentTitle.length )
    {
        NSDate *orignalDdate = [fmt dateFromString:self.settingItem.contentTitle];
        if (orignalDdate && [orignalDdate isKindOfClass:[NSDate class]])
        {
            control.date = orignalDdate;
        }
    }
    
    self.hasMannueChanged = YES;
    
    NSDate *date = control.date;
    
    if ( date == nil )
    {
        date = [NSDate date];
    }
    
    self.contentTextField.text = [fmt stringFromDate:date];
    [self textChanged];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( self.settingItem.keyBoardType == EVKeyBoardLocation )
    {
        UIPickerView *pickerView = (UIPickerView *)textField.inputView;
        [self pickerView:pickerView didSelectRow:self.provinceIndex inComponent:self.cityIndex];
    }
    else if ( self.settingItem.keyBoardType == EVKeyBoardSex )
    {
        textField.text = [self.settingItem.contentTitle isEqualToString:kE_GlobalZH(@"e_male")] ? kE_GlobalZH(@"e_male") : kE_GlobalZH(@"e_female");
        [self textChanged];
    }
}


#pragma mark - UIPickerViewDataSource 数据源方法
// 返回有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ( self.settingItem.keyBoardType == EVKeyBoardLocation )
    {
        return 2;
    }
    return 1;
}

// 每一列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ( self.settingItem.keyBoardType == EVKeyBoardLocation )
    {
        if ( 0 == component )
        {
            return self.provices.count;
        }
        else
        {
            NSInteger selectIndex = [pickerView selectedRowInComponent:0];
            // 取出城市数组
            NSArray *cities = [self.provices[selectIndex] cities];
            return cities.count;
        }
    }
    else
    {
        return 2;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ( self.settingItem.keyBoardType == EVKeyBoardLocation  )
    {
        if ( 0 == component )
        {
            CCProvince *province = self.provices[row];
            return province.name;
        }
        else
        {
            NSInteger selectIndex = self.provinceIndex;
            CCProvince *province = self.provices[selectIndex];
            // 显示城市
            NSArray *cities = province.cities;
            if ( (NSInteger)cities.count - 1 < row  )
            {
                row = (NSInteger)cities.count - 1;
            }
            return cities[row];
        }
    }
    else
    {
        return row == 0 ? kE_GlobalZH(@"e_male") : kE_GlobalZH(@"e_female");
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ( self.settingItem.keyBoardType == EVKeyBoardLocation  )
    {
        if ( 0 == component )
        {
            self.provinceIndex = row;
            [pickerView reloadComponent:1];
            // 让第一列回到第一行
            if ( !self.settingItem.contentTitle )
            {
                [pickerView selectRow:0 inComponent:1 animated:YES];
            }
        }
        
        // 设置label
        // 省份
        NSInteger proviceIndex = [pickerView selectedRowInComponent:0];
        
        NSString *provStr = [self.provices[proviceIndex] name];
        
        // 城市
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
        
        NSArray *cities = [self.provices[self.provinceIndex] cities];
        if ( cities.count -1 >= cityIndex  )
        {
            NSString *cityStr = cities[cityIndex];
            self.contentTextField.text = [NSString stringWithFormat:@"%@ %@", provStr, cityStr];
        }
        self.cityIndex = cityIndex;
    }
    else
    {
        self.contentTextField.text = row == 0 ? kE_GlobalZH(@"e_male") : kE_GlobalZH(@"e_female");
    }
    [self textChanged];
}

- (UILabel *)signatureLabel
{
    if ( !_signatureLabel )
    {
        UILabel *signatureLabel = [[UILabel alloc] init];
        signatureLabel.numberOfLines = 0;
        signatureLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:16.f];
        signatureLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        signatureLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:signatureLabel];
        
        [signatureLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.indicateImageView withOffset:-6];
        [signatureLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:94];
        [signatureLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        _signatureLabel = signatureLabel;
    }
    return _signatureLabel;
}

- (UILabel *)introduceLabel
{
    if ( !_introduceLabel )
    {
        UILabel *introduceLabel = [[UILabel alloc] init];
        introduceLabel.numberOfLines = 3;
        introduceLabel.font = [UIFont systemFontOfSize:16.0];
        introduceLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        introduceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:introduceLabel];
        
        [introduceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.indicateImageView withOffset:-6];
        [introduceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:94];
        [introduceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        _introduceLabel = introduceLabel;
    }
    return _introduceLabel;
}


@end
