#import "DouToolSettingViewController.h"

@interface DouToolSettingViewController ()

@property (nonatomic, strong) UISwitch *autoPlaySwitch;
@property (nonatomic, strong) UISwitch *globalTransparencySwitch;
@property (nonatomic, strong) UISwitch *friendHideSwitch; // 抖音密友开关
@property (nonatomic, strong) UISwitch *textToSpeechSwitch; // 文字转语音开关
@property (nonatomic, assign) NSInteger currentVideoIndex; // 当前视频索引

@end

@implementation DouToolSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.currentVideoIndex = 0; // 初始化当前视频索引

    // 设置原生导航栏并添加返回按钮
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"抖抖助手"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    navItem.leftBarButtonItem = backButton;
    [navBar setItems:@[navItem]];
    [self.view addSubview:navBar];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
    titleLabel.text = @"抖抖助手";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:titleLabel];

    // 自动播放开关
    self.autoPlaySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 71, 200, 0, 0)];
    [self.autoPlaySwitch setOn:NO animated:NO];
    [self.view addSubview:self.autoPlaySwitch];

    UILabel *autoPlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 80, 40)];
    autoPlayLabel.text = @"视频自动播放";
    autoPlayLabel.textAlignment = NSTextAlignmentLeft;
    autoPlayLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:autoPlayLabel];

    // 全局透明开关
    self.globalTransparencySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 71, 260, 0, 0)];
    [self.globalTransparencySwitch setOn:NO animated:NO];
    [self.view addSubview:self.globalTransparencySwitch];

    UILabel *globalTransparencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, self.view.frame.size.width - 80, 40)];
    globalTransparencyLabel.text = @"设置全局透明";
    globalTransparencyLabel.textAlignment = NSTextAlignmentLeft;
    globalTransparencyLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:globalTransparencyLabel];

    // 抖音密友开关
    self.friendHideSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 71, 320, 0, 0)];
    [self.friendHideSwitch setOn:NO animated:NO];
    [self.view addSubview:self.friendHideSwitch];

    UILabel *friendHideLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, self.view.frame.size.width - 80, 40)];
    friendHideLabel.text = @"隐藏抖音密友";
    friendHideLabel.textAlignment = NSTextAlignmentLeft;
    friendHideLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:friendHideLabel];

    // 文字转语音开关
    self.textToSpeechSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 71, 380, 0, 0)];
    [self.textToSpeechSwitch setOn:NO animated:NO];
    [self.view addSubview:self.textToSpeechSwitch];

    UILabel *textToSpeechLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, self.view.frame.size.width - 80, 40)];
    textToSpeechLabel.text = @"文字转语音";
    textToSpeechLabel.textAlignment = NSTextAlignmentLeft;
    textToSpeechLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textToSpeechLabel];

    // 添加开关改变的监听
    [self.autoPlaySwitch addTarget:self action:@selector(autoPlaySwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.globalTransparencySwitch addTarget:self action:@selector(globalTransparencySwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.friendHideSwitch addTarget:self action:@selector(friendHideSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.textToSpeechSwitch addTarget:self action:@selector(textToSpeechSwitchChanged:) forControlEvents:UIControlEventValueChanged];

    // 添加版本号标签
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 30)];
    versionLabel.text = @"版本 1.0";
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = [UIColor secondaryLabelColor];
    [self.view addSubview:versionLabel];

    // 添加版权标签
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 30)];
    copyrightLabel.text = @"© By Hyangu";
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.font = [UIFont systemFontOfSize:14];
    copyrightLabel.textColor = [UIColor secondaryLabelColor];
    [self.view addSubview:copyrightLabel];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)autoPlaySwitchChanged:(UISwitch *)sender {
    if (sender.isOn) {
        NSLog(@"视频自动播放已启用");
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playNextVideo)
                                                     name:@"VideoPlayEndedNotiName"
                                                   object:nil];
    } else {
        NSLog(@"视频自动播放已禁用");
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"VideoPlayEndedNotiName"
                                                  object:nil];
    }
}

// 播放下一个视频的逻辑
- (void)playNextVideo {
    // 自动播放下一个视频
    NSLog(@"播放下一个视频");
    
    self.currentVideoIndex += 1; // 更新当前视频索引
    // 这里实现滚动到下一个视频的逻辑，例如获取表格视图并滚动到目标索引
    [self scrollToVideoAtIndex:self.currentVideoIndex];
}

// 滚动到指定视频索引的方法
- (void)scrollToVideoAtIndex:(NSInteger)index {
    // 实现滚动到指定视频的逻辑
    // 假设有一个表格视图或集合视图，您需要滚动到该索引
    // 示例:
    // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    // [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)globalTransparencySwitchChanged:(UISwitch *)sender {
    // 处理全局透明开关逻辑
    CGFloat alpha = sender.isOn ? 0.5 : 1.0;
    self.view.alpha = alpha;
}

- (void)friendHideSwitchChanged:(UISwitch *)sender {
    // 处理抖音密友隐藏开关逻辑
}

- (void)textToSpeechSwitchChanged:(UISwitch *)sender {
    // 处理文字转语音开关逻辑
}

@end
