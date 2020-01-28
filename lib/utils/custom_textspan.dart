import 'package:flutter/material.dart';
import 'package:law_app/utils/colorlaw.dart';

TextStyle posRes = TextStyle(
        color: Colors.white,
        fontSize: 18,
        backgroundColor: ColorLaw.blue,
        fontFamily: "Fregat"),
    negRes = TextStyle(
        color: Colors.black,
        fontSize: 18,
        backgroundColor: Colors.transparent,
        fontFamily: "Fregat");

final text = '''
Call me Ishmael. Some years ago—never mind how long precisely—having
little or no money in my purse, and nothing particular to interest me
on shore, I thought I would sail about a little and see the watery part
of the world. It is a way I have of driving off the spleen and
regulating the circulation. Whenever I find myself growing grim about
the mouth; whenever it is a damp, drizzly November in my soul; whenever
I find myself involuntarily pausing before coffin warehouses, and
bringing up the rear of every funeral I meet; and especially whenever
my hypos get such an upper hand of me, that it requires a strong moral
principle to prevent me from deliberately stepping into the street, and
methodically knocking people’s hats off—then, I account it high time to
get to sea as soon as I can. This is my substitute for pistol and ball.
With a philosophical flourish Cato throws himself upon his sword; I
quietly take to the ship. There is nothing surprising in this. If they
but knew it, almost all men in their degree, some time or other,
cherish very nearly the same feelings towards the ocean with me.
'''
    .replaceAll("\n", " ")
    .replaceAll("  ", "");

TextSpan searchMatch(String match, search) {
  if (search == null || search == "")
    return TextSpan(text: match, style: negRes);
  var refinedMatch = match.toLowerCase();
  var refinedSearch = search.toLowerCase();
  if (refinedMatch.contains(refinedSearch)) {
    if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
      return TextSpan(
        style: posRes,
        text: match.substring(0, refinedSearch.length),
        children: [
          searchMatch(
              match.substring(
                refinedSearch.length,
              ),
              search),
        ],
      );
    } else if (refinedMatch.length == refinedSearch.length) {
      return TextSpan(text: match, style: posRes);
    } else {
      return TextSpan(
        style: negRes,
        text: match.substring(
          0,
          refinedMatch.indexOf(refinedSearch),
        ),
        children: [
          searchMatch(
              match.substring(
                refinedMatch.indexOf(refinedSearch),
              ),
              search),
        ],
      );
    }
  } else if (!refinedMatch.contains(refinedSearch)) {
    return TextSpan(text: match, style: negRes);
  }
  return TextSpan(
    text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
    style: negRes,
    children: [
      searchMatch(
          match.substring(
            refinedMatch.indexOf(refinedSearch),
          ),
          search)
    ],
  );
}

// import 'package:flutter/material.dart';
// import 'package:law_app/utils/colorlaw.dart';

// class HighLightTextSpan extends StatefulWidget {
//   String text;
//   String search;
//   HighLightTextSpan({this.text, this.search});
//   _HighLightTextSpanState createState() => _HighLightTextSpanState();
// }

// class _HighLightTextSpanState extends State<HighLightTextSpan> {
//   TextStyle posRes =
//           TextStyle(color: Colors.white, backgroundColor: ColorLaw.blue),
//       negRes = TextStyle(color: Colors.black, backgroundColor: Colors.white);

//   TextSpan searchMatch({String match: "", String search}) {
//     if (search == null || search == "")
//       return TextSpan(text: match, style: negRes);
//     var refinedMatch = match.toLowerCase();
//     var refinedSearch = search.toLowerCase();
//     if (refinedMatch.contains(refinedSearch)) {
//       if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
//         return TextSpan(
//           style: posRes,
//           text: match.substring(0, refinedSearch.length),
//           children: [
//             searchMatch(
//               match.substring(
//                 refinedSearch.length,
//               ),
//             ),
//           ],
//         );
//       } else if (refinedMatch.length == refinedSearch.length) {
//         return TextSpan(text: match, style: posRes);
//       } else {
//         return TextSpan(
//           style: negRes,
//           text: match.substring(
//             0,
//             refinedMatch.indexOf(refinedSearch),
//           ),
//           children: [
//             searchMatch(
//               match.substring(
//                 refinedMatch.indexOf(refinedSearch),
//               ),
//             ),
//           ],
//         );
//       }
//     } else if (!refinedMatch.contains(refinedSearch)) {
//       return TextSpan(text: match, style: negRes);
//     }
//     // return TextSpan(
//     //   text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
//     //   style: negRes,
//     //   children: [
//     //     searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
//     //   ],
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextSpan();
//   }
// }
