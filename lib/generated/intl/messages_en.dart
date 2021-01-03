// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "_locale" : MessageLookupByLibrary.simpleMessage("en"),
    "c_framework_error" : MessageLookupByLibrary.simpleMessage("Google framework isn’t installed on your device!"),
    "c_framework_ok" : MessageLookupByLibrary.simpleMessage("All Done! Now you can enjoy Google services."),
    "c_framework_warning" : MessageLookupByLibrary.simpleMessage("Your Google Play service is incomplete!"),
    "c_tip_framework_install" : MessageLookupByLibrary.simpleMessage("NOTE:\n\nAfter installation, please go to the application settings and be sure to authorize the following permissions:\n\n·Self-starting permission (some devices)\n\n·Permission to read phone status (information)\n\n·Pop-up window permissions in the background. (Some equipment)\n\n·In addition, MIUI12 users should pay attention to closing the blank pass of the application."),
    "c_tip_store_install" : MessageLookupByLibrary.simpleMessage("NOTE:\n\nAfter installation, please go to the application settings and be sure to authorize the following permissions:\n\n·Permission to read phone status (information)\n\n·Pop-up window permissions in the background. (Some equipment)\n\n·In addition, MIUI12 users should pay attention to closing the blank pass of the application."),
    "title_about_us" : MessageLookupByLibrary.simpleMessage("About Us"),
    "title_architecture" : MessageLookupByLibrary.simpleMessage("Architecture"),
    "title_checking_data" : MessageLookupByLibrary.simpleMessage("Checking Data..."),
    "title_deviceInfo" : MessageLookupByLibrary.simpleMessage("DeviceInfo"),
    "title_fix_google_play" : MessageLookupByLibrary.simpleMessage("Fix Google Framework"),
    "title_google_apps_status" : MessageLookupByLibrary.simpleMessage("Google Apps Status"),
    "title_install_google_play" : MessageLookupByLibrary.simpleMessage("Install Google Framework"),
    "title_not_install" : MessageLookupByLibrary.simpleMessage("Not Install"),
    "title_open_google_play" : MessageLookupByLibrary.simpleMessage("Open Google Play"),
    "title_uninstall" : MessageLookupByLibrary.simpleMessage("Uninstall")
  };
}
