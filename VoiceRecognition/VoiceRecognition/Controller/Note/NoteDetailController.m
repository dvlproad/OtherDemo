//
//  NoteDetailController.m
//  Voice2Note
//
//  Created by liaojinxing on 14-6-11.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

#import "NoteDetailController.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "VNConstants.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyContact.h"
/*#import "WXApi.h"*/
#import "AppContext.h"

#import <UMMobClick/MobClick.h>

#import "CJIFlySpeechManager.h"
#import "CJIFlyRecognizerNoViewManager.h"
#import "CJIFlyRecognizerViewManager.h"

@import MessageUI;

static const CGFloat kViewOriginY = 70;
static const CGFloat kTextFieldHeight = 30;
static const CGFloat kToolbarHeight = 44;
static const CGFloat kVoiceButtonWidth = 100;



@interface NoteDetailController () <UIActionSheetDelegate,
MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    VNNote *_note;
    
    IFlyRecognizerView *_iflyRecognizerView;
    BOOL _isEditingTitle;
    
    UIColor *systemColor;
    UIColor *systemDarkColor;
}
@property (nonatomic, strong) UITextField *titleTextField;  /**< 标题 */
@property (nonatomic, strong) UITextView *contentTextView;  /**< 内容 */
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIToolbar *toolbar;

@end


@implementation NoteDetailController

- (instancetype)initWithNote:(VNNote *)note
{
    self = [super init];
    if (self) {
        _note = note;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    systemColor = [UIColor emeraldColor];
    systemDarkColor = [UIColor hollyGreenColor];
    
    [self setupNavigationBar];
    [self setupViews];
    
    [self updateViewByData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigationBar
{
    //这边item改为只有一个复制（另外做了一个强制保存的功能）
    /*
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionSheetSave", @"")
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(save)];
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more_white"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(moreActionButtonPressed)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreItem, saveItem, nil];
    */
    
    UIBarButtonItem *copyItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionSheetCopy", @"")
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(copyAll)];
    self.navigationItem.rightBarButtonItem = copyItem;
}


- (void)updateViewByData {
    if (_note == nil) {
        return;
    }
    
    _titleTextField.text = _note.title;
    _contentTextView.text = _note.content;
    [[CJIFlySpeechManager sharedInstance] speak:_note.content];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self saveForce];//增加一个强制保存的功能
    [IFlySpeechUtility destroy];
    
//    [[CJIFlySpeechManager sharedInstance] stop];
}

- (void)startListenning
{
    [_voiceButton setTitle:@"正在进行" forState:UIControlStateNormal];
    [_voiceButton setBackgroundColor:systemDarkColor];
    
    void(^recognizeResultBlock)(NSString *resultString, BOOL isLast) = ^(NSString *resultString, BOOL isLast) {
        if (_isEditingTitle) {
            _titleTextField.text = [NSString stringWithFormat:@"%@%@", _titleTextField.text, resultString];
        } else {
            _contentTextView.text = [NSString stringWithFormat:@"%@%@", _contentTextView.text, resultString];
        }
        
        if (isLast) {
            [_voiceButton setTitle:@"点击继续" forState:UIControlStateNormal];
            [_voiceButton setBackgroundColor:systemColor];
        }
    };
    
    /*
    //方法一：使用带View的
    [[CJIFlyRecognizerViewManager sharedInstance] initIFlyRecognizerViewWithCenter:self.view.center];
    [[CJIFlyRecognizerViewManager sharedInstance] setRecognizeResultBlock:recognizeResultBlock];
    
    [[CJIFlyRecognizerViewManager sharedInstance] startListening];
    //*/
    
    //*
    //方法二：使用不带view的
    [[CJIFlyRecognizerNoViewManager sharedInstance] setRecognizeResultBlock:recognizeResultBlock];
    [[CJIFlyRecognizerNoViewManager sharedInstance] startListening];
    //*/
    
    NSLog(@"start listenning...");
}

- (void)useVoiceInput
{
    /*
     //此处注释掉，上传本地名片的操作
     if (![AppContext appContext].hasUploadAddressBook) {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
     message:NSLocalizedString(@"UploadABForBetter", @"")
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"ActionSheetCancel", @"")
     otherButtonTitles:NSLocalizedString(@"GotoUploadAB", @""), nil];
     [alertView show];
     [[AppContext appContext] setHasUploadAddressBook:YES];
     return;
     }
     */
    
    [self hideKeyboard];
    [self startListenning];
    [MobClick event:kEventClickVoiceButton];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        IFlyDataUploader *_uploader = [[IFlyDataUploader alloc] init];
        IFlyContact *iFlyContact = [[IFlyContact alloc] init]; NSString *contactList = [iFlyContact contact];
        [_uploader setParameter:@"uup" forKey:@"subject"];
        [_uploader setParameter:@"contact" forKey:@"dtt"];
        //启动上传
        [_uploader uploadDataWithCompletionHandler:^(NSString *grammerID, IFlySpeechError *error) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        } name:@"contact" data:contactList];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         CGFloat keyboardHeight = keyboardFrame.size.height;
         
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - keyboardHeight - kVerticalMargin - kToolbarHeight,
         _contentTextView.frame = frame;
     }               completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - kVoiceButtonWidth - kVerticalMargin * 3;
         _contentTextView.frame = frame;
     }               completion:NULL];
}

- (void)hideKeyboard
{
    if ([_titleTextField isFirstResponder]) {
        _isEditingTitle = YES;
        [_titleTextField resignFirstResponder];
    }
    if ([_contentTextView isFirstResponder]) {
        _isEditingTitle = NO;
        [_contentTextView resignFirstResponder];
    }
}

#pragma mark - Save

- (void)save
{
    [self hideKeyboard];
    if ((_contentTextView.text == nil || _contentTextView.text.length == 0) &&
        (_titleTextField.text == nil || _titleTextField.text.length == 0)) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"InputTextNoData", @"")];
        return;
    }
    NSDate *createDate;
    if (_note && _note.createdDate) {
        createDate = _note.createdDate;
    } else {
        createDate = [NSDate date];
    }
    VNNote *note = [[VNNote alloc] initWithTitle:_titleTextField.text
                                         content:_contentTextView.text
                                     createdDate:createDate
                                      updateDate:[NSDate date]];
    _note = note;
    BOOL success = [note Persistence];
    if (success) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveSuccess", @"")];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateFile object:nil userInfo:nil];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveFail", @"")];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveForce
{
    [self hideKeyboard];
    if ((_contentTextView.text == nil || _contentTextView.text.length == 0) &&
        (_titleTextField.text == nil || _titleTextField.text.length == 0)) {
        return;
    }
    NSDate *createDate;
    if (_note && _note.createdDate) {
        createDate = _note.createdDate;
    } else {
        createDate = [NSDate date];
    }
    VNNote *note = [[VNNote alloc] initWithTitle:_titleTextField.text
                                         content:_contentTextView.text
                                     createdDate:createDate
                                      updateDate:[NSDate date]];
    _note = note;
    BOOL success = [note Persistence];
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateFile object:nil userInfo:nil];
    }
}


- (void)copyAll{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contentTextView.text;
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"CopySuccess", @"")];
}


#pragma mark - More Action

- (void)moreActionButtonPressed
{
    [self hideKeyboard];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"ActionSheetCancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"ActionSheetCopy", @""),
                                  NSLocalizedString(@"ActionSheetMail", @""),
                                  NSLocalizedString(@"ActionSheetWeixin", @""), nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self copyAll];
    } else if (buttonIndex == 1) {
        if ([MFMailComposeViewController canSendMail]) {
            [self sendEmail];
        }
    } else if (buttonIndex == 2) {
        [self shareToWeixin];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:systemColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Eail

- (void)sendEmail
{
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc]init];
    [composer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]) {
        [composer setSubject:_titleTextField.text];
        [composer setMessageBody:_contentTextView.text isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:composer animated:YES completion:nil];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"CanNoteSendMail", @"")];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultFailed) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SendEmailFail", @"")];
    } else if (result == MFMailComposeResultSent) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SendEmailSuccess", @"")];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Weixin

- (void)shareToWeixin
{
    /*
    if (_contentTextView.text == nil || _contentTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"InputTextNoData", @"")];
        return;
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = _contentTextView.text;
    req.bText = YES;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
    [MobClick event:kEventShareToWeixin];
  */
}



#pragma mark - SetupViews & Lazy
- (void)setupViews
{
    [self.view addSubview:self.titleTextField];
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(kHorizontalMargin);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = systemDarkColor;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleTextField);
        make.centerX.mas_equalTo(_titleTextField);
        make.top.mas_equalTo(_titleTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    

    [self.view addSubview:self.voiceButton];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kVoiceButtonWidth);
        make.centerX.mas_equalTo(_titleTextField);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide).mas_offset(-kVerticalMargin);
        make.height.mas_equalTo(kVoiceButtonWidth);
    }];
    
    
    
    [self.view addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleTextField);
        make.centerX.mas_equalTo(_titleTextField);
        make.top.mas_equalTo(_titleTextField.mas_bottom).mas_offset(kVerticalMargin);
        make.bottom.mas_equalTo(_voiceButton.mas_top).mas_offset(kVerticalMargin);
    }];
}

- (UITextField *)titleTextField {
    if (_titleTextField == nil) {
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _titleTextField.placeholder = NSLocalizedString(@"InputViewTitle", @"");
        _titleTextField.textColor = systemDarkColor;
        _titleTextField.inputAccessoryView = self.toolbar;
    }
    
    return _titleTextField;
}

- (UITextView *)contentTextView {
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _contentTextView.textColor = systemDarkColor;
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_contentTextView setScrollEnabled:YES];
        _contentTextView.inputAccessoryView = self.toolbar;
    }
    
    return _contentTextView;
}

- (UIButton *)voiceButton {
    if (_voiceButton == nil) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton setFrame:CGRectZero];
        [_voiceButton setTitle:NSLocalizedString(@"VoiceInput", @"") forState:UIControlStateNormal];
        [_voiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _voiceButton.layer.cornerRadius = kVoiceButtonWidth / 2;
        _voiceButton.layer.masksToBounds = YES;
        [_voiceButton setBackgroundColor:systemColor];
        [_voiceButton addTarget:self action:@selector(useVoiceInput) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton setTintColor:[UIColor whiteColor]];
    }
    return _voiceButton;
}

- (UIToolbar *)toolbar {
    if (_toolbar == nil) {
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
        doneBarButton.width = ceilf(self.view.frame.size.width) / 3 - 30;
        
        UIBarButtonItem *voiceBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"micro_small"] style:UIBarButtonItemStylePlain target:self action:@selector(useVoiceInput)];
        voiceBarButton.width = ceilf(self.view.frame.size.width) / 3;
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kToolbarHeight)];
        _toolbar.tintColor = systemColor;
        _toolbar.items = [NSArray arrayWithObjects:doneBarButton, voiceBarButton, nil];
    }
    return _toolbar;
}


@end
