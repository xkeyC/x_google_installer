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
    DonateInfo("匿名", "2021-02-01 21:28:07", "作者辛苦了，来瓶可乐!", "￥ 3.00"),
    DonateInfo("匿名", "2021-02-01 21:45:03", "谢谢！", "￥ 5.00"),
    DonateInfo("ariel", "2021-02-01 21:57:22", "不多表支持", "￥ 10.00"),
    DonateInfo("匿名", "2021-02-01 23:10:39", "感谢您的付出一点心意", "￥ 10.00"),
    DonateInfo("匿名", "2021-02-02 02:34:13", "支持一下！！！", "￥ 6.66"),
    DonateInfo("zerodays", "2021-02-02 07:05:59", null, "￥ 10.00"),
    DonateInfo("匿名", "2021-02-02 16:31:29", "辛苦了，来瓶可乐!", "￥ 3.00"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context,
          showBackButton: true,
          title: ListTile(
            title: Text(
              S.of(context).title_donor_list,
              style: TextStyle(
                  color: getTextColor(context), fontWeight: FontWeight.bold),
            ),
            subtitle: Text("更新于 2021-2-4"),
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
                subtitle: info.comment == null ? null : Text(info.comment),
                trailing: Text(info.count),
                onTap: () {},
              );
            }),
      ),
    );
  }
}
