import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/main_page.dart';

import '../api.dart';
import '../conf.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _flutterLogoController;
  AnimationController _appLogoController;
  FlutterLogoStyle _flutterLogoStyle = FlutterLogoStyle.markOnly;
  int flutterLogoDuration = 0;
  Animation<Offset> flutterLogoAnimation;
  bool showPowerByText = false;
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  /// firebase

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    Api.init();

    /// do sth for app init
    _flutterLogoController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    _appLogoController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);

    flutterLogoAnimation = Tween(begin: Offset.zero, end: Offset(0, 3.4))
        .animate(_flutterLogoController);

    _flutterLogoController.addListener(() {
      if (_flutterLogoController.status == AnimationStatus.completed) {
        setState(() {
          showPowerByText = true;
        });
      }
    });

    initData();

    super.initState();
  }

  void initData() {
    AppConf.initData().then((code) async {
      if (code == null) {
        showDialog(
            context: _scaffold.currentContext,
            builder: (context) {
              return AlertDialog(
                title: Text(S.of(context).title_error),
                content: Text(S.of(context).c_err_connect_server),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        initData();
                      },
                      child: Text(S.of(context).title_retry)),
                  TextButton(
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text("ok")),
                ],
              );
            });
      }

      int waitTime = 1000;
      if (code == 1) {
        flutterLogoDuration = 1000;
        setState(() {
          _flutterLogoStyle = FlutterLogoStyle.horizontal;
        });
        _flutterLogoController.duration = Duration(milliseconds: 300);
        _appLogoController.duration = Duration(milliseconds: 500);
        await Future.delayed(Duration(milliseconds: 500));
      } else {
        waitTime = 300;
        setState(() {
          _flutterLogoStyle = FlutterLogoStyle.horizontal;
        });
        setState(() {
          showPowerByText = true;
        });
      }
      _flutterLogoController.forward();
      _appLogoController.forward();
      await Future.delayed(Duration(milliseconds: waitTime));
      _goNext();
    });
  }

  _goNext() {
    Navigator.pushAndRemoveUntil(_scaffold.currentContext,
        MaterialPageRoute(builder: (context) {
      return MainPage();
    }), (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: [const Locale('en'), const Locale('zh', 'CN')],
      navigatorObservers: <NavigatorObserver>[observer],
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
              key: _scaffold,
              body: Stack(
                children: [
                  Center(
                    child: SlideTransition(
                      position: flutterLogoAnimation,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: FlutterLogo(
                              style: _flutterLogoStyle,
                              duration:
                                  Duration(milliseconds: flutterLogoDuration),
                              curve: Curves.easeInExpo,
                            ),
                          ),
                          Positioned(
                            child: showPowerByText
                                ? Center(
                                    child: Text(
                                      "Powered By",
                                      style: TextStyle(fontSize: 9),
                                    ),
                                  )
                                : SizedBox(),
                            top: 25,
                            left: 0,
                            right: 40,
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: FadeTransition(
                      opacity: _appLogoController,
                      child: SizedBox(
                        height: 100,
                        child: Image.asset("assets/appLogo.png"),
                      ),
                    ),
                  )
                ],
              ),
              bottomNavigationBar: SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text(showPowerByText
                          ? "clinux.co Open Source Project"
                          : S.of(context).title_checking_data),
                    ),
                  )));
        },
      ),
    );
  }

  @override
  void dispose() {
    _flutterLogoController.dispose();
    _appLogoController.dispose();
    super.dispose();
  }
}
