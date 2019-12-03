import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/screens/law_detail_page.dart';
import 'package:law_app/utils/fade_route.dart';

class TermVerticalItem extends StatelessWidget {
  final TermModel model;
  final int index;

  TermVerticalItem(this.model, this.index);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(model);
  }

  Widget _buildTiles(TermModel t) {
    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      title: new Text(t.slug, style: TextStyle(color: Color(0xff1b4392)),),
      children: t.cntTermTaxonomies.map((data) => ListTile(
              leading: Container(
                width: 40, // can be whatever value you want
                alignment: Alignment.center,
                child: Text(data.taxonomy,style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w800)),
              ),
              title: Text(data.description),
            ))
        .toList(),
    );
  }
}



