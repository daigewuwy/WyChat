/* ----------------------用于本项目中遇到的问题及解决-------------------- */

// .表视图使用UITableViewStyleGrouped风格时头部多出空白区域

        // 重新设置头部区域
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScaleH(10))];

        使用heightForHeader时，如果是0高度的情况，不要返回0，返回CGFloat_MIN代替0

// .表视图顶部多出空白区域

      1.  -(void)viewWillAppear:(BOOL)animated {
    
        // 重置tableview位置，消除tableView头部多处的空白区域
            if (self.tableView.contentOffset.y<0 || self.tableView.contentOffset.y==0.000000) {
        
                self.tableView.contentInset = UIEdgeInsetsZero;
            }
        }

      2.  _tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);





// .集成插件后在xcode中不显示 for xcode 8.2.1

    sudo gem install update_xcode_plugins
    update_xcode_plugins
    update_xcode_plugins --unsign 或根据上步终端给出的提示做


// .报错:ld: framework not found FileProvider for architecture x86_64

    问题的原因在于，FileProvider这个基本库文件只有在Xcode9之后才有在Xcode8中并没有这个库，解决的办法是下载一个Xcode9，然后将其中的FileProvider文件拷贝到Xcode8相应的位置处，注意要先将正在运行的Xcode8给关掉。

    右击Xcode9，然后点击打开 显示包内容，然后找到如下路径

    Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/FileProvider

    找到这个FileProvider这个库文件，将其拷贝到Xcode8相应的位置。

    注意：在拷贝文件时候，路径中有两个选择，一个是提供给模拟器使用，一个是真机使用，建议将两个路径下的包都拷过去，我就是因为模拟器上的包文件没有拷贝，导致使用模拟器运行一直报错。

    模拟器的文件包路径为：

    Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/FileProvider


// .注册失败

    注意AppKey中是否含有中文字符或者中文输入法下的符号
    错误例子:1132190530181851＃wychat,注意此时的＃号是中文输入法下的，会出现注册失败
    成功例子:1132190530181851#wychat


// .Attempt to insert non-property list object
    向NSUserDefault插入非系统类型的数据

// .使用// 立即将缓存写入存储中[NSUserDefaults standardUserDefaults]存储数据时，发现有时候不能及时写入，导致达不到预想的结果
    // 立即将缓存写入存储中
    [[NSUserDefaults standardUserDefaults] synchronize];

// 编译失败，什么错误信息也没有

    查看是debug版本或者release版本

// 集成EaseUI时候出现错误
    1.出现找不到UIImage的情况，直接在出错的文件顶部手动导入<UIKit/UIKit.h>
    2.由于XCode版本较低，找不到新系统类的时候直接注释掉

// 进入聊天后最后一条消息往下偏移
    tableView的设置不正确
    1.进入EaseMessageViewController
    2.后找到如下方法，加上64
        tableFrame.size.height = self.view.frame.size.height - _chatToolbar.frame.size.height - iPhoneX_BOTTOM_HEIGHT;


// FMDB出现database is locked的情况
    1.尝试重开数据库(一般不是这个情况)
    2.注意数据库对象FMDataBase有没有及时关闭(虽然原作者说不改变模式不要关闭，会影响性能),但是主要原因时没有关闭数据库造成了竟态
