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
    DonateInfo("mde", "2021-02-13 21:11", "感谢您为小米GMS安装做出的努力", "￥ 6.66"),
    DonateInfo("匿名", "2021-03-27 21:53", "黑鲨4安装框架成功，感谢！", "￥ 18.00"),
    DonateInfo("simcheu", "2021-03-28 09:58:39", "感谢付出", "￥ 3.00"),
    DonateInfo("匿名", "2021-04-13 17:14:06", null, "￥ 3.00"),
    DonateInfo("匿名", "2021-04-16 15:53:41", "好用，谢谢", "￥ 50.00"),
    DonateInfo("匿名", "2021-04-16 18:21:02", null, "￥ 3.00"),
    DonateInfo("匿名", "2021-04-24 13:13:33", "感谢作者，来瓶可乐吧", "￥ 3.00"),
    DonateInfo("匿名", "2021-05-22 11:39:43", null, "￥ 2.00"),
    DonateInfo("匿名", "2021-07-02 11:39:43", null, "￥ 5.00"),
    DonateInfo("匿名", "2021-07-16 14:04:59", null, "￥ 6.66"),
    DonateInfo("匿名", "2021-07-27 18:40:03", "十分感谢", "￥ 6.66"),
    DonateInfo("匿名", "2021-08-06 15:49:15", null, "￥ 28.88"),
    DonateInfo("匿名", "2021-10-16 01:10:58", null, "￥ 1.00"),
    DonateInfo("匿名", "2021-11-26 13:37:00", null, "￥ 12.00"),
    DonateInfo("匿名", "2022-01-09 14:40:00", "这软件帮了我大忙了", "￥ 5.00"),
    DonateInfo("匿名", "2022-03-15 19:52:10", null, "￥ 20.00"),
    DonateInfo("匿名", "2022-03-18 17:51:56", null, "￥ 5.00"),
    DonateInfo("匿名", "2022-03-19 20:17:07", null, "￥ 3.00"),
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
            subtitle: Text("更新于 2022-04-12"),
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
