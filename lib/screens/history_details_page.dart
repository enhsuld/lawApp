import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/timeline_entry_row.dart';

class HistoryDetailsPage extends StatefulWidget {
  final int term;
  HistoryDetailsPage({this.term});
  _HistoryDetailsPageState createState() => _HistoryDetailsPageState();
}

class _HistoryDetailsPageState extends State<HistoryDetailsPage> {
  static const int PAGE_SIZE = 10;
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
          style:
              TextStyle(color: Color(0xff1b4392), fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Center(
          //   child: FadeInImage.assetNetwork(
          //     fit: BoxFit.cover,
          //     height: MediaQuery.of(context).size.height,
          //     placeholder: "assets/images/logo@2x.png",
          //     image:
          //         "http://tyder.mn/api/file/downloadFile/suld/eZk06nj0HA.png1",
          //   ),
          // ),
          // new BackdropFilter(
          //   filter: new prefix0.ImageFilter.blur(sigmaX: 3.0, sigmaY: 4.0),
          //   child: new Container(
          //     decoration:
          //         new BoxDecoration(color: Colors.white.withOpacity(0.0)),
          //   ),
          // ),
          PagewiseListView(
              padding: EdgeInsets.only(top: 15),
              pageSize: PAGE_SIZE,
              itemBuilder: this._itemBuilder,
              pageFuture: (pageIndex) => BackendService.getHistoryList(
                  widget.term, pageIndex, PAGE_SIZE))
        ],
      ),
    );
  }

  Widget _itemBuilder(context, TaxonomyModel entry, _) {
    return new TimelineEntryRow(
        lineColor: ColorLaw.blue,
        backgroundColor: Theme.of(context).canvasColor,
        imagesBaseUrl: "",
        entry: entry);
  }
}
