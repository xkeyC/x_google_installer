// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "_locale" : MessageLookupByLibrary.simpleMessage("zh_CN"),
    "c_donate" : MessageLookupByLibrary.simpleMessage("让 XGI 变得更好"),
    "c_donate_tip" : MessageLookupByLibrary.simpleMessage("* 捐赠是您完全自愿的行为，您的捐赠会让本软件更好的发展，您不会因为捐赠而获得更优先的技术支持或软件功能性上的改变，捐赠的方式和金额都由您来决定，推荐您在捐赠时备注您的昵称与留言，捐赠者名单将会永久的硬编码于本软件的代码之中，并随着软件的更新而更新。"),
    "c_downgrade_install" : MessageLookupByLibrary.simpleMessage("除非您对您的设备进行过一些 Hack 操作，否则 Android 系统将不允许您进行降级安装，请先卸载新版本，再重新安装旧版本。"),
    "c_err_connect_server" : MessageLookupByLibrary.simpleMessage("未成功连接至 clinux.co 服务器。请检查您的网络连接，然后重试。"),
    "c_framework_error" : MessageLookupByLibrary.simpleMessage("啊嘞！您的设备还没有安装 Google Play 服务。"),
    "c_framework_is_system_app" : MessageLookupByLibrary.simpleMessage("抱歉，您的 Google 框架为系统预装应用，我们无法帮您卸载。"),
    "c_framework_ok" : MessageLookupByLibrary.simpleMessage("全部OK！现在，您可以在您的设备上享受 Google Play 服务！"),
    "c_framework_update" : MessageLookupByLibrary.simpleMessage("您的 Google 框架可以更新啦！"),
    "c_framework_warning" : MessageLookupByLibrary.simpleMessage("道友请留步！您设备的 Google 框架 不完整。"),
    "c_fuck_miui" : MessageLookupByLibrary.simpleMessage("检测到您正在使用 MIUI，请确保您的设备为 MIUI 12.5 21.2.1 之前的版本，否则安装器暂时无法帮助您安装 Google 框架。\n适用于 MIUI 21.2.1 的 Root 版开发方案正在开发中，敬请期待。"),
    "c_installation_failed" : MessageLookupByLibrary.simpleMessage("部分设备已经预装了与 Google 官方签名不一致的 Google Play Service 程序，该服务将会在您成功登录 Play Store 后自动更新为官方版，请尝试跳过 Service 的安装，稍后直接安装并启动 Google Play。"),
    "c_tip_framework_install" : MessageLookupByLibrary.simpleMessage("注意：\n\n安装完毕后请前往应用设置，务必授权以下权限：\n\n·自启动权限（部分设备） \n\n·读取手机状态（信息）权限 \n\n·在后台弹出窗口权限。（部分设备）\n\n·MIUI12用户请注意将该应用的空白通行证关闭。"),
    "c_tip_installed" : MessageLookupByLibrary.simpleMessage("小提示：\n\n如果您遇到 Chrome, Youtube 等 Google 应用无法识别已登录账号的情况，请尝试开启这些应用的读取账户权限。\n\n如果 Google Play 提示连接到服务器出现了一些问题， 无法正常登录，请尝试开启 play 的安装应用权限。"),
    "c_tip_store_install" : MessageLookupByLibrary.simpleMessage("注意：\n\n安装完毕后请前往应用设置，务必授权以下权限：\n\n·读取手机状态（信息）权限 \n\n·在后台弹出窗口权限。（部分设备）\n\n·MIUI12用户请注意将该应用的空白通行证关闭。"),
    "title_about" : MessageLookupByLibrary.simpleMessage("关于"),
    "title_all_done" : MessageLookupByLibrary.simpleMessage("全部完成，点击任意位置返回"),
    "title_architecture" : MessageLookupByLibrary.simpleMessage("处理器架构"),
    "title_check_update" : MessageLookupByLibrary.simpleMessage("检查更新"),
    "title_checking_data" : MessageLookupByLibrary.simpleMessage("正在核对信息，请保持网络通畅..."),
    "title_deviceInfo" : MessageLookupByLibrary.simpleMessage("设备信息"),
    "title_donate" : MessageLookupByLibrary.simpleMessage("捐赠"),
    "title_donor_list" : MessageLookupByLibrary.simpleMessage("捐赠者名单"),
    "title_downgrade_install" : MessageLookupByLibrary.simpleMessage("降级安装！"),
    "title_enforce_continue" : MessageLookupByLibrary.simpleMessage("强制执行"),
    "title_error" : MessageLookupByLibrary.simpleMessage("出错了！"),
    "title_fix_google" : MessageLookupByLibrary.simpleMessage("修复 Google 框架"),
    "title_fuck_miui" : MessageLookupByLibrary.simpleMessage("发现 MIUI！"),
    "title_google_apps_status" : MessageLookupByLibrary.simpleMessage("Google 应用状态"),
    "title_install_google" : MessageLookupByLibrary.simpleMessage("安装 Google 框架"),
    "title_install_with_browser" : MessageLookupByLibrary.simpleMessage("使用浏览器下载安装"),
    "title_installation_failed" : MessageLookupByLibrary.simpleMessage("安装失败？"),
    "title_join_qq_group" : MessageLookupByLibrary.simpleMessage("加入 QQ 群"),
    "title_next" : MessageLookupByLibrary.simpleMessage("下一步"),
    "title_not_install" : MessageLookupByLibrary.simpleMessage("未安装"),
    "title_open_google" : MessageLookupByLibrary.simpleMessage("打开 Google Play"),
    "title_opens_source_license" : MessageLookupByLibrary.simpleMessage("开源软件许可"),
    "title_project_home_site" : MessageLookupByLibrary.simpleMessage("项目主页"),
    "title_project_main_developer" : MessageLookupByLibrary.simpleMessage("主要开发者"),
    "title_reinstall_google_framework" : MessageLookupByLibrary.simpleMessage("重新安装"),
    "title_remove_download_file" : MessageLookupByLibrary.simpleMessage("删除下载文件"),
    "title_retry" : MessageLookupByLibrary.simpleMessage("重试"),
    "title_settings" : MessageLookupByLibrary.simpleMessage("设置"),
    "title_skip" : MessageLookupByLibrary.simpleMessage("跳过"),
    "title_start_install" : MessageLookupByLibrary.simpleMessage("开始安装"),
    "title_uninstall" : MessageLookupByLibrary.simpleMessage("卸载"),
    "title_upgrade_google" : MessageLookupByLibrary.simpleMessage("升级 Google 框架"),
    "title_use_default" : MessageLookupByLibrary.simpleMessage("使用默认配置"),
    "title_view_donor_list" : MessageLookupByLibrary.simpleMessage("查看捐赠者名单")
  };
}
