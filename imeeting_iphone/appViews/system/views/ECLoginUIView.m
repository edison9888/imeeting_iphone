//
//  ECLoginUIVIEW.m
//  imeeting_iphone
//
//  Created by star king on 12-6-7.
//  Copyright (c) 2012年 elegant cloud. All rights reserved.
//

#import "ECLoginUIView.h"
#import "ectoolkit.h"

@interface ECLoginUIView ()
- (void)initUI;
- (void)loginAction;
@end

@implementation ECLoginUIView

- (id)init {
    self = [super init];
    if (self) {
        // init UI
        [self initUI];
    }
    return self;
}

#pragma mark - UI Initialization

- (void)initUI {
    self.title = NSLocalizedString(@"Account Setting", "");
    self.leftBarButtonItem = nil;
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"register", "") style:UIBarButtonItemStyleBordered target:self action:@selector(jumpToRegisterAction)];
    
    // user phone number input
    _mUserNameInput = [self makeTextFieldWithPlaceholder:NSLocalizedString(@"phone number", "") frame:CGRectMake(0, 0, 280, 30) keyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    // user password input
    _mPwdInput = [self makeTextFieldWithPlaceholder:NSLocalizedString(@"input pwd", "") frame:CGRectMake(0, 0, 280, 30) keyboardType:UIKeyboardTypeDefault];
    _mPwdInput.secureTextEntry = YES;
    
    _mRememberPwdSwitch = [[UISwitch alloc] init];
    _mRememberPwdSwitch.on = YES;
    
    _mAutoLoginSwitch = [[UISwitch alloc] init];
    [_mAutoLoginSwitch addTarget:self action:@selector(switchAutoLoginAction:) forControlEvents:UIControlEventValueChanged];
    
    // login button
    _mLoginButton = [self makeButtonWithTitle:NSLocalizedString(@"Login", "") frame:CGRectMake(0, 0, 140, 30)];
    [_mLoginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    loginTableView.backgroundColor = self.backgroundColor;
    loginTableView.dataSource = self;
    
    [self addSubview:loginTableView];
        
    _mHud = [[MBProgressHUD alloc] initWithView:self];
    
    [self addSubview:_mHud];
    
    //##### set user info in the view
    UserBean *userBean = [[UserManager shareSingleton] userBean];
    _mUserNameInput.text = userBean.name;
    _mPwdInput.text = userBean.password;
    _mRememberPwdSwitch.on = userBean.rememberPwd;
    _mAutoLoginSwitch.on = userBean.autoLogin;
    
}


#pragma mark - UITextFieldDelegate methods implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Switch Actions
- (void)switchAutoLoginAction:(UISwitch*)pSwitch {
    if(pSwitch.on) {
        [_mRememberPwdSwitch setOn:YES animated:YES];
        _mRememberPwdSwitch.enabled = NO;
    } else {
        _mRememberPwdSwitch.enabled = YES;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:pSwitch.on] forKey:@"autologin"];

}

#pragma mark - Button Actions

- (void)jumpToRegisterAction {
    if ([self validateViewControllerRef:self.viewControllerRef andSelector:@selector(jumpToRegisterView)]) {
        [self.viewControllerRef performSelector:@selector(jumpToRegisterView)];
    }
    
}

- (void)loginAction {
    NSString *phoneNumber = [_mUserNameInput.text trimWhitespaceAndNewline];
    NSString *pwd = [_mPwdInput.text trimWhitespaceAndNewline];
    BOOL rememberPwd = _mRememberPwdSwitch.on;
    BOOL autoLogin = _mAutoLoginSwitch.on;
    
    [_mUserNameInput resignFirstResponder];
    [_mPwdInput resignFirstResponder];
    
    if (!phoneNumber || [phoneNumber isEqualToString:@""]) {
        NSLog(@"phone number is null");
        [iToast showDefaultToast:NSLocalizedString(@"please input phone number first", "") andDuration:iToastDurationNormal];
        return;
    }
    
    if (!pwd || [pwd isEqualToString:@""]) {
        [iToast showDefaultToast:NSLocalizedString(@"please input password", "") andDuration:iToastDurationNormal];
        return;
        
    }
    
    
    UserBean *userBean = [[UserManager shareSingleton] setUser:phoneNumber andPwd:pwd];
    userBean.rememberPwd = rememberPwd;
    userBean.autoLogin = autoLogin;
    
    if ([self validateViewControllerRef:self.viewControllerRef andSelector:@selector(login)]) {
        [_mHud setLabelText:NSLocalizedString(@"Logining", "")];
        [_mHud showWhileExecuting:@selector(login) onTarget:self.viewControllerRef withObject:nil animated:YES];
    }
}

#pragma mark - UITableView Datasource Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

// render table cell UI
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"login cell"];
    
    if (cell == nil) {
        switch (indexPath.row) {
            case 0:
                cell = [[ECUIControlTableViewCell alloc] initWithLabelTip:nil andControl:_mUserNameInput];
                break;
            case 1:
                cell = [[ECUIControlTableViewCell alloc] initWithLabelTip:nil andControl:_mPwdInput];
                break;
            case 2:
                cell = [[ECUIControlTableViewCell alloc] initWithLabelTip:NSLocalizedString(@"Remember Pwd", "") andControl:_mRememberPwdSwitch];
                break;
            case 3:
                cell = [[ECUIControlTableViewCell alloc] initWithLabelTip:NSLocalizedString(@"Auto Login", "") andControl:_mAutoLoginSwitch];
                break;
            case 4:
                cell = [[ECUIControlTableViewCell alloc] initWithLabelTip:nil andControl:_mLoginButton];
                break;
            default:
                break;
        }
    }
    return cell;
}


@end