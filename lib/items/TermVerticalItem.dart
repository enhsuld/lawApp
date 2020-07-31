import 'package:flutter/material.dart';
// import 'package:highlight_text/highlight_text.dart';
import 'package:law_app/models/term_law.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/custom_textspan.dart';

class TermVerticalItem extends StatelessWidget {
  final TermLawModel model;
  final int index;
  final String search;
  // Map<String, HighlightedWord> words = new HashMap();

  TermVerticalItem(this.model, this.index, this.search);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(model);
  }

  TextStyle textStyle =
      new TextStyle(color: Colors.white, backgroundColor: ColorLaw.blue);

  Widget _buildTiles(TermLawModel t) {
    // words = {
    //   search: HighlightedWord(
    //     onTap: () {},
    //     textStyle: textStyle,
    //   ),
    // };
    return new ExpansionTile(
      key: PageStorageKey<int>(model.id),
      initiallyExpanded: (search != null && search.length > 0) ? true : false,
      title: new Text(
        (t?.slug ?? "").toUpperCase(),
        style: TextStyle(
            color: ColorLaw.blue, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      children: t.cntTermTaxonomies
          .map((data) => Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  //key: Key(data.taxonnomy),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        (data.taxonomy.length > 3)
                            ? data.taxonomy.substring(0, 1)
                            : data.taxonomy + ".",
                        style: TextStyle(
                            fontSize: 20,
                            color: ColorLaw.blue,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child:
                            // TextHighlight(
                            //   text: data
                            //       .description, // You need to pass the string you want the highlights
                            //   words: words, // Your dictionary words
                            //   textStyle: TextStyle(
                            //       // You can set the general style, like a Text()
                            //       fontSize: 16.0,
                            //       color: Colors.black),
                            //   textAlign: TextAlign
                            //       .justify, // You can use any attribute of the RichText widget
                            // ),
                            RichText(
                                text: searchMatch(data.description, search))
                        //     Text(
                        //   data.description,
                        //   style: TextStyle(fontSize: 16),
                        //   textAlign: TextAlign.justify,
                        // ),
                        )
                  ],
                ),
              ))
          .toList(),
    );
  }
  // TextStyle posRes =
  //         TextStyle(color: Colors.white, backgroundColor: ColorLaw.blue),
  //     negRes = TextStyle(color: Colors.black, backgroundColor: Colors.white);

  // TextSpan searchMatch({String match: "", String search}) {
  //   if (search == null || search == "")
  //     return TextSpan(text: match, style: negRes);
  //   var refinedMatch = match.toLowerCase();
  //   var refinedSearch = search.toLowerCase();
  //   if (refinedMatch.contains(refinedSearch)) {
  //     if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
  //       return TextSpan(
  //         style: posRes,
  //         text: match.substring(0, refinedSearch.length),
  //         children: [
  //           searchMatch(
  //             match.substring(
  //               refinedSearch.length,
  //             ),
  //           ),
  //         ],
  //       );
  //     } else if (refinedMatch.length == refinedSearch.length) {
  //       return TextSpan(text: match, style: posRes);
  //     } else {
  //       return TextSpan(
  //         style: negRes,
  //         text: match.substring(
  //           0,
  //           refinedMatch.indexOf(refinedSearch),
  //         ),
  //         children: [
  //           searchMatch(
  //             match.substring(
  //               refinedMatch.indexOf(refinedSearch),
  //             ),
  //           ),
  //         ],
  //       );
  //     }
  //   } else if (!refinedMatch.contains(refinedSearch)) {
  //     return TextSpan(text: match, style: negRes);
  //   }
  //   // return TextSpan(
  //   //   text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
  //   //   style: negRes,
  //   //   children: [
  //   //     searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
  //   //   ],
  //   // );
  // }
}
