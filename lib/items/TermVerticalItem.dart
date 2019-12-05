import 'package:flutter/material.dart';
import 'package:law_app/models/term.dart';

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
      title: new Text(
        t?.slug ?? "",
        style: TextStyle(color: Color(0xff1b4392), fontWeight: FontWeight.w600),
      ),
      children: t.cntTermTaxonomies
          .map((data) => Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(data.taxonomy + ".",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w800)),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        data.description,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
// ListTile(
//                 leading: Container(
//                   width: 40, // can be whatever value you want
//                   alignment: Alignment.topCenter,
//                   child: Text(data.taxonomy,
//                       style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w800)),
//                 ),
//                 title: Text(
//                   data.description,
//                   textAlign: TextAlign.justify,
//                 ),
//               )
