//
//  MBLivingController.m
//  MiaoBo
//
//  Created by kehwa on 16/7/12.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "MBLivingController.h"
#import "OMPlayerView.h"
#import "OMNetworkingConfiguration.h"
#import "OMSwitch.h"
#import "MBLivingUserView.h"
@interface MBLivingController ()<OMSwitchDelegate>

@property (nonatomic , strong)OMPlayerView *playView; //播放器

@property (nonatomic , strong)UIView *pannelView; //操作面板，所有的操作视图(发送弹幕按钮，聊天按钮....)
@property (nonatomic , strong)UIView *bottomView;
@property (nonatomic , strong)UIButton *commentButton;  //发送弹幕
@property (nonatomic , strong)UIButton *chatButton;     //聊天
@property (nonatomic , strong)UIButton *giftButton;     //送礼
@property (nonatomic , strong)UIButton *leaderboardButton;  //礼物贡献榜
@property (nonatomic , strong)UIButton *shareButton;    //分享
@property (nonatomic , strong)UIButton *dismissButton;  //返回

@property (nonatomic , strong)UIView *barrageView;  //弹幕
@property (nonatomic , strong)OMSwitch *openBarrageSwitch; //开启/关闭弹幕
@property (nonatomic , strong)UITextField *barrageInputField; //弹幕输入框
@property (nonatomic , strong)UIButton *sendBarrageButton; //发送弹幕

@property (nonatomic , strong)UIView *barrageInputFieldLeftView;
@property (nonatomic , strong)UILabel *roomLabel; //barrageInputField的左视图


@property (nonatomic , strong)MBLivingUserView *userView;

@end

@implementation MBLivingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.playView];
    [self.view addSubview:self.pannelView];
    [self.view addSubview:self.dismissButton];
    [self.view addSubview:self.barrageView];
    
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.playView.frame = self.view.bounds;
    
    //这里的宽度可以随便设置,因为内部将其宽度默认设置为ScreenWidth-20
    self.userView.frame = CGRectMake(0, 20, 10, 40);
    
    self.pannelView.frame = self.view.bounds;
    
    self.bottomView.frame = CGRectMake(0, kScreenHeight - 30 - 10, kScreenWidth, 30);
    self.commentButton.frame = CGRectMake(10, 0, self.bottomView.bounds.size.height, self.bottomView.bounds.size.height);
    
    
    self.dismissButton.frame = CGRectMake(self.view.frame.size.width - 10 - self.bottomView.bounds.size.height, self.bottomView.frame.origin.y, self.bottomView.bounds.size.height, self.bottomView.bounds.size.height);
    
    
    CGRect dismissBtnRect = CGRectMake(CGRectGetWidth(self.bottomView.frame) - 10 - CGRectGetHeight(self.bottomView.frame), 0, self.bottomView.bounds.size.height, self.bottomView.bounds.size.height);
    self.shareButton.frame = CGRectMake(dismissBtnRect.origin.x - 10 - CGRectGetHeight(self.bottomView.frame), 0, self.bottomView.bounds.size.height, self.bottomView.bounds.size.height);
    self.leaderboardButton.frame = CGRectMake(self.shareButton.frame.origin.x - 10 - CGRectGetHeight(self.bottomView.frame), 0, self.bottomView.bounds.size.height, self.bottomView.bounds.size.height);
    self.giftButton.frame = CGRectMake(self.leaderboardButton.frame.origin.x - 10 - CGRectGetHeight(self.bottomView.frame), 0, self.bottomView.bounds.size.height, self.bottomView.bounds.size.height);
    self.chatButton.frame = CGRectMake(self.giftButton.frame.origin.x - 10 - CGRectGetHeight(self.bottomView.frame), 0, self.bottomView.bounds.size.height, self.bottomView.bounds.size.height);
    
    
    self.barrageView.bounds = CGRectMake(0, 0, kScreenWidth, 40);
    self.barrageView.center = CGPointMake(self.view.center.x, kScreenHeight + self.barrageView.bounds.size.height * 0.5);
    
    self.openBarrageSwitch.frame = CGRectMake(10, 5, 50, self.barrageView.frame.size.height - 10);
    self.sendBarrageButton.frame = CGRectMake(self.barrageView.frame.size.width - 10 - 50, 5, 50, self.barrageView.frame.size.height - 10);
    self.barrageInputField.frame = CGRectMake(CGRectGetMaxX(self.openBarrageSwitch.frame) + 10, 5, self.sendBarrageButton.frame.origin.x - 10 - (CGRectGetMaxX(self.openBarrageSwitch.frame) + 10), self.barrageView.frame.size.height - 10);
    
    self.barrageInputFieldLeftView.frame = CGRectMake(0, 0, 10, self.barrageInputField.frame.size.height);
    
    self.roomLabel.frame = CGRectMake(self.barrageInputField.frame.origin.x + 5, self.barrageInputField.frame.origin.y + 5, 30, self.barrageInputFieldLeftView.frame.size.height - 10);
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHidden:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark -- private method
//弹出动画
- (void)animationAlert:(UIView *)view
{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.5;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1f, 0.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5f, 1.5f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
//    popAnimation.keyTimes = @[@0.0f, @0.2f, @0.4f, @0.8f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
}


#pragma mark - notofication event
- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y - 20;
    self.barrageView.transform = CGAffineTransformMakeTranslation(0, -height);
}

- (void)keyboardWillHidden:(NSNotification *)notification{
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    self.barrageView.transform = CGAffineTransformIdentity;
}


#pragma mark - event response
- (void)sendBarrageAction{
    //显示发送弹幕的输入框
    
    [self.barrageInputField becomeFirstResponder];
}


- (void)dismissButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


//滑动手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        [UIView animateWithDuration:0.4 animations:^{
            if (self.pannelView.center.x != self.view.center.x ) {
                self.pannelView.center = self.view.center;
            }
            
        }];
    }
    
    
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:0.4 animations:^{
            self.pannelView.center = CGPointMake(kScreenWidth * 1.5, kScreenHeight * 0.5);
        }];
    }

}


#pragma mark - OMSwitchDelegate
- (void)didClickSwitch:(OMSwitch *)switchControl status:(BOOL)status{
    if (!status) {
        self.roomLabel.hidden = YES;
        self.barrageInputFieldLeftView.bounds = CGRectMake(0, 0, 10, self.barrageInputFieldLeftView.frame.size.height);
    }else{
        self.barrageInputFieldLeftView.bounds = CGRectMake(0, 0, 40, self.barrageInputFieldLeftView.frame.size.height);
        self.roomLabel.hidden = NO;
        [self animationAlert:self.roomLabel];//添加弹出效果动画
    }
}


#pragma mark - getters and setters
- (UIView *)playView{
    if (_playView == nil) {
        _playView = [[OMPlayerView alloc]initWithUrlString:self.allAnchorTable[self.currentAnchorIndex][@"flv"]];
        _playView.backgroundColor = [UIColor yellowColor];
    }
    return _playView;
}

- (UIView *)pannelView{
    if (_pannelView == nil) {
        _pannelView = [[UIView alloc]init];
        _pannelView.backgroundColor = [UIColor clearColor];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                        action:@selector(handleSwipeFrom:)];
        
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [[self view] addGestureRecognizer:recognizer];

        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [[self view] addGestureRecognizer:recognizer];
        
        [_pannelView addSubview:self.bottomView];
        [_pannelView addSubview:self.userView];
    }
    return _pannelView;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor clearColor];
        
        [_bottomView addSubview:self.commentButton];
        [_bottomView addSubview:self.chatButton];
        [_bottomView addSubview:self.giftButton];
        [_bottomView addSubview:self.leaderboardButton];
        [_bottomView addSubview:self.shareButton];
        
    }
    return _bottomView;
}

- (UIButton *)commentButton{
    if (_commentButton == nil) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"talk_public_40x40"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(sendBarrageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIButton *)chatButton{
    if (_chatButton == nil) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setBackgroundImage:[UIImage imageNamed:@"talk_private_40x40"] forState:UIControlStateNormal];
    }
    return _chatButton;
}

- (UIButton *)giftButton{
    if (_giftButton == nil) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftButton setBackgroundImage:[UIImage imageNamed:@"talk_sendgift_40x40"] forState:UIControlStateNormal];
    }
    return _giftButton;
}

- (UIButton *)leaderboardButton{
    if (_leaderboardButton == nil) {
        _leaderboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leaderboardButton setBackgroundImage:[UIImage imageNamed:@"talk_rank_40x40"] forState:UIControlStateNormal];
    }
    return _leaderboardButton;
}

- (UIButton *)shareButton{
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"talk_share_40x40"] forState:UIControlStateNormal];
    }
    return _shareButton;
}

- (UIButton *)dismissButton{
    if (_dismissButton == nil) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setBackgroundImage:[UIImage imageNamed:@"talk_close_40x40"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (UIView *)barrageView{
    if (_barrageView == nil) {
        _barrageView = [[UIView alloc]init];
        _barrageView.backgroundColor = RGB(235, 235, 241);
        
        [_barrageView addSubview:self.openBarrageSwitch];
        [_barrageView addSubview:self.barrageInputField];
        [_barrageView addSubview:self.sendBarrageButton];
        [_barrageView addSubview:self.roomLabel];
    }
    return _barrageView;
}

- (OMSwitch *)openBarrageSwitch{
    if (_openBarrageSwitch == nil) {
        _openBarrageSwitch = [[OMSwitch alloc]init];
        _openBarrageSwitch.selectedText = @"弹幕";
        _openBarrageSwitch.unselectedText = @"弹幕";
        _openBarrageSwitch.selectedBgColor = RGB(223, 90, 147);
        _openBarrageSwitch.selectedTextColor = RGB(223, 90, 147);
        _openBarrageSwitch.delegate = self;
        _openBarrageSwitch.isOpen = NO;
    }
    return _openBarrageSwitch;
}

- (UITextField *)barrageInputField{
    if (_barrageInputField == nil) {
        _barrageInputField = [[UITextField alloc]init];
        UIImage *image = [UIImage imageNamed:@"input_bg.9"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        [_barrageInputField setBackground:image];
        _barrageInputField.font = [UIFont systemFontOfSize:12];
        NSAttributedString *placeholder = [[NSAttributedString alloc]initWithString:@"发送弹幕100喵币/条" attributes:@{NSFontAttributeName:_barrageInputField.font}];
        _barrageInputField.attributedPlaceholder = placeholder;
        
        _barrageInputField.leftViewMode = UITextFieldViewModeAlways;
        _barrageInputField.leftView = self.barrageInputFieldLeftView;
        
    }
    return _barrageInputField;
}

- (UIButton *)sendBarrageButton{
    if (_sendBarrageButton == nil) {
        _sendBarrageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBarrageButton.backgroundColor = RGB(223, 90, 147);
        [_sendBarrageButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBarrageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBarrageButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _sendBarrageButton.layer.masksToBounds = YES;
        _sendBarrageButton.layer.cornerRadius = 2;
    }
    return _sendBarrageButton;
}

- (UIView *)barrageInputFieldLeftView{
    if (_barrageInputFieldLeftView == nil) {
        _barrageInputFieldLeftView = [[UIView alloc]init];
        _barrageInputFieldLeftView.backgroundColor = [UIColor clearColor];
    }
    return _barrageInputFieldLeftView;
}

- (UILabel *)roomLabel{
    if (_roomLabel == nil) {
        _roomLabel = [[UILabel alloc]init];
        _roomLabel.backgroundColor = RGB(116, 204, 249);
        _roomLabel.font = [UIFont systemFontOfSize:11];
        _roomLabel.text = @"房间";
        _roomLabel.textColor = [UIColor whiteColor];
        _roomLabel.textAlignment = NSTextAlignmentCenter;
        _roomLabel.layer.masksToBounds = YES;
        _roomLabel.layer.cornerRadius = 5;
        _roomLabel.hidden = YES;
    }
    return _roomLabel;
}

- (MBLivingUserView *)userView{
    if (_userView == nil) {
        _userView = [[MBLivingUserView alloc]initWithUser:self.allAnchorTable[self.currentAnchorIndex] allAnchor:self.allAnchorTable];
    }
    return _userView;
}

@end
