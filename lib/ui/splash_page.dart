import 'package:flutter/material.dart';
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

    AppConf.initData().then((code) async {
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
    super.initState();
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
      supportedLocales: [
        const Locale('en'),
      ],
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
          );
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
