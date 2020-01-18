import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/screens/addition_page.dart';
import 'package:law_app/screens/history_page.dart';
import 'package:law_app/screens/law_detail_page.dart';
import 'package:law_app/screens/orshil_page.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/fade_route.dart';

class TermItem extends StatefulWidget {
  final TermOnlyModel model;
  final int index;

  TermItem(this.model, this.index);

  @override
  _TermItemState createState() => _TermItemState();
}

class _TermItemState extends State<TermItem> {
  TextStyle style =
      TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 15.0);

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white.withAlpha(220),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            if (widget.model.slug == "6") {
              FlutterShare.share(
                  title: 'Монгол Улсын Үндсэн хууль',
                  text: 'Монгол Улсын Үндсэн хууль',
                  linkUrl: 'http://conslaw.ml',
                  chooserTitle: 'Түгээх боломжтой');
            } else if (widget.model.slug == "4") {
              print(widget.model);
              Navigator.of(context).push(FadeRoute(
                  builder: (context) => AdditionPage(term: widget.model)));
            } else if (widget.model.slug == "5") {
              Navigator.of(context).push(FadeRoute(
                  builder: (context) => HistoryPage(term: widget.model)));
            } else if (widget.model.slug == "0") {
              Navigator.of(context).push(FadeRoute(
                  builder: (context) => OrshilPage(term: widget.model)));
            } else {
              Navigator.of(context).push(FadeRoute(
                  builder: (context) => LawDetailPage(term: widget.model)));
            }
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Image.asset(
                  (widget.model.slug == "0")
                      ? 'assets/images/ic_home_two.png'
                      : (widget.model.slug == "1")
                          ? 'assets/images/ic_home_three.png'
                          : (widget.model.slug == "2")
                              ? 'assets/images/ic_home_two.png'
                              : (widget.model.slug == "3")
                                  ? 'assets/images/ic_home_three.png'
                                  : (widget.model.slug == "4")
                                      ? 'assets/images/ic_home_four.png'
                                      : (widget.model.slug == "5")
                                          ? 'assets/images/ic_home_five.png'
                                          : 'assets/images/ic_home_six.png',
                  width: 25,
                ),
              ),
              Flexible(
                child: Text(widget.model.name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(
                      color: ColorLaw.blue,
                      fontSize: 19,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
