import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/screens/law_detail_page.dart';
import 'package:law_app/utils/fade_route.dart';

class TaxonomyItem extends StatefulWidget {
  final TaxonomyModel model;
  final int index;

  TaxonomyItem(this.model, this.index);

  @override
  _TermItemState createState() => _TermItemState();
}

class _TermItemState extends State<TaxonomyItem> {

  TextStyle style = TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 15.0);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            //Navigator.of(context).push(FadeRoute(builder: (context) => LawDetailPage(term: widget.model)));
          },
          child: Row(
            children: <Widget>[
              Text(widget.model.taxonomy,
                  textAlign: TextAlign.center,
                  style: style.copyWith(color: Color(0xff1b4392), fontSize: 15))
            ],
          ),
        ),
      ),
    );
  }
}
