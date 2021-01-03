// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get _locale {
    return Intl.message(
      'en',
      name: '_locale',
      desc: '',
      args: [],
    );
  }

  /// `Uninstall`
  String get title_uninstall {
    return Intl.message(
      'Uninstall',
      name: 'title_uninstall',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get title_about_us {
    return Intl.message(
      'About Us',
      name: 'title_about_us',
      desc: '',
      args: [],
    );
  }

  /// `DeviceInfo`
  String get title_deviceInfo {
    return Intl.message(
      'DeviceInfo',
      name: 'title_deviceInfo',
      desc: '',
      args: [],
    );
  }

  /// `Architecture`
  String get title_architecture {
    return Intl.message(
      'Architecture',
      name: 'title_architecture',
      desc: '',
      args: [],
    );
  }

  /// `Google Apps Status`
  String get title_google_apps_status {
    return Intl.message(
      'Google Apps Status',
      name: 'title_google_apps_status',
      desc: '',
      args: [],
    );
  }

  /// `Not Install`
  String get title_not_install {
    return Intl.message(
      'Not Install',
      name: 'title_not_install',
      desc: '',
      args: [],
    );
  }

  /// `Checking Data...`
  String get title_checking_data {
    return Intl.message(
      'Checking Data...',
      name: 'title_checking_data',
      desc: '',
      args: [],
    );
  }

  /// `Open Google Play`
  String get title_open_google_play {
    return Intl.message(
      'Open Google Play',
      name: 'title_open_google_play',
      desc: '',
      args: [],
    );
  }

  /// `Fix Google Framework`
  String get title_fix_google_play {
    return Intl.message(
      'Fix Google Framework',
      name: 'title_fix_google_play',
      desc: '',
      args: [],
    );
  }

  /// `Install Google Framework`
  String get title_install_google_play {
    return Intl.message(
      'Install Google Framework',
      name: 'title_install_google_play',
      desc: '',
      args: [],
    );
  }

  /// `All Done! Now you can enjoy Google services.`
  String get c_framework_ok {
    return Intl.message(
      'All Done! Now you can enjoy Google services.',
      name: 'c_framework_ok',
      desc: '',
      args: [],
    );
  }

  /// `Google framework isn’t installed on your device!`
  String get c_framework_error {
    return Intl.message(
      'Google framework isn’t installed on your device!',
      name: 'c_framework_error',
      desc: '',
      args: [],
    );
  }

  /// `Your Google Play service is incomplete!`
  String get c_framework_warning {
    return Intl.message(
      'Your Google Play service is incomplete!',
      name: 'c_framework_warning',
      desc: '',
      args: [],
    );
  }

  /// `NOTE:\n\nAfter installation, please go to the application settings and be sure to authorize the following permissions:\n\n·Self-starting permission (some devices)\n\n·Permission to read phone status (information)\n\n·Pop-up window permissions in the background. (Some equipment)\n\n·In addition, MIUI12 users should pay attention to closing the blank pass of the application.`
  String get c_tip_framework_install {
    return Intl.message(
      'NOTE:\n\nAfter installation, please go to the application settings and be sure to authorize the following permissions:\n\n·Self-starting permission (some devices)\n\n·Permission to read phone status (information)\n\n·Pop-up window permissions in the background. (Some equipment)\n\n·In addition, MIUI12 users should pay attention to closing the blank pass of the application.',
      name: 'c_tip_framework_install',
      desc: '',
      args: [],
    );
  }

  /// `NOTE:\n\nAfter installation, please go to the application settings and be sure to authorize the following permissions:\n\n·Permission to read phone status (information)\n\n·Pop-up window permissions in the background. (Some equipment)\n\n·In addition, MIUI12 users should pay attention to closing the blank pass of the application.`
  String get c_tip_store_install {
    return Intl.message(
      'NOTE:\n\nAfter installation, please go to the application settings and be sure to authorize the following permissions:\n\n·Permission to read phone status (information)\n\n·Pop-up window permissions in the background. (Some equipment)\n\n·In addition, MIUI12 users should pay attention to closing the blank pass of the application.',
      name: 'c_tip_store_install',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}