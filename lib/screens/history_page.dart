import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:law_app/models/history.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/screens/history_details_page.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/fade_route.dart';
import 'package:law_app/utils/timeline_entry_row.dart';

class HistoryPage extends StatefulWidget {
  final TermOnlyModel term;
  HistoryPage({this.term});
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const int PAGE_SIZE = 10;

  List<HistoryModel> historys = List();

  @override
  void initState() {
    super.initState();

    BackendService.getHistoryGroup().then((onValue) {
      print(onValue);
      if (onValue != null) {
        setState(() {
          historys = onValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff1b4392),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Монгол улсын түүх".toUpperCase(),
            style: TextStyle(color: Color(0xff1b4392)),
          ),
        ),
        body: GridView.count(
          //padding: EdgeInsets.only(top: 0, bottom: 60),
          crossAxisCount: 2,
          //childAspectRatio: .7,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(historys.length, (index) {
            HistoryModel model = historys[index];
            return _itemBuilder(context, model, index);
          }),
        )
        // PagewiseListView(
        //     padding: EdgeInsets.all(0),
        //     pageSize: PAGE_SIZE,
        //     itemBuilder: this._itemBuilder,
        //     pageFuture: (pageIndex) => BackendService.getHistoryList(
        //         widget.term.id, pageIndex, PAGE_SIZE)),
        );
  }

  Widget _itemBuilder(context, HistoryModel entry, _) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            FadeRoute(
                builder: (context) => HistoryDetailsPage(
                      term: entry.id,
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(1),
        child: Stack(
          children: <Widget>[
            Center(
              child: FadeInImage.assetNetwork(
                fit: BoxFit.fill,
                height: 200,
                placeholder: "assets/images/logo@2x.png",
                image: ((entry?.medias ?? []).length > 0)
                    ? BackendService.link + entry.medias[0]
                    : "",
              ),
            ),
            //Image.network("src"),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: Text(
                  entry.name,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
