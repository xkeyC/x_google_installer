import 'package:flutter/material.dart';

makeAppBar(BuildContext context,
    {bool showBackButton = false, Widget title, List<Widget> actions}) {
  Color backgroundColor = getAppBackGroundColor(context);
  Color textColor =
      backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
  return AppBar(
    backgroundColor: backgroundColor,
    brightness: Theme.of(context).brightness,
    elevation: 4,
    leading: showBackButton
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: textColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            })
        : null,
    title: title,
    centerTitle: true,
    actions: actions,
  );
}

Color getTextColor(BuildContext context) {
  Color backgroundColor = getAppBackGroundColor(context);
  return backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
}

Color getAppBackGroundColor(BuildContext context) {
  return isDarkMode(context) ? Theme.of(context).primaryColor : Colors.white;
}

Color getPageBackground(BuildContext context) {
  return isDarkMode(context)
      ? Theme.of(context).primaryColor
      : Color.fromARGB(255, 242, 241, 246);
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

const RadiusDialogShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)));
