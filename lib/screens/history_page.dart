import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/timeline_entry_row.dart';

class HistoryPage extends StatefulWidget {
  final TermModel term;
  HistoryPage({this.term});
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
          style: TextStyle(color: Color(0xff1b4392)),
        ),
      ),
      body: PagewiseListView(
          padding: EdgeInsets.all(0),
          pageSize: PAGE_SIZE,
          itemBuilder: this._itemBuilder,
          pageFuture: (pageIndex) => BackendService.getHistoryList(
              widget.term.id, pageIndex, PAGE_SIZE)),
    );
  }

  Widget _itemBuilder(context, TaxonomyModel entry, _) {
    return new TimelineEntryRow(
        lineColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).canvasColor,
        imagesBaseUrl: "",
        entry: entry);
  }
}
