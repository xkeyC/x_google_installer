import 'package:flutter/material.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

class DonateInfo {
  final String name;
  final String date;
  final String comment;
  final String count;

  const DonateInfo(this.name, this.date, this.comment, this.count);
}

class DonorListPage extends StatefulWidget {
  @override
  _DonorListPageState createState() => _DonorListPageState();
}

class _DonorListPageState extends State<DonorListPage> {
  /// Donate data
  static const List<DonateInfo> _donateInfoList = [
    DonateInfo("xkeyC", "2021-02-01", "这是一条示例，将会在拥有正式信息后移除", "￥ 0.00"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context,
          showBackButton: true,
          title: Text(
            S.of(context).title_donor_list,
            style: TextStyle(
                color: getTextColor(context), fontWeight: FontWeight.bold),
          )),
      body: Scrollbar(
        child: ListView.builder(
            itemCount: _donateInfoList.length,
            itemBuilder: (context, index) {
              final info = _donateInfoList[index];
              return ListTile(
                title: RichText(
                  text: TextSpan(
                      text: "${info.name}",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                          fontSize: 18),
                      children: [
                        TextSpan(
                          text: "  _ ${info.date}",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .color
                                  .withAlpha(125),
                              fontSize: 12),
                        )
                      ]),
                ),
                subtitle: Text(info.comment),
                trailing: Text(info.count),
                onTap: () {},
              );
            }),
      ),
    );
  }
}
