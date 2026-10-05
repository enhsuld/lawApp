import 'package:flutter/material.dart';
import 'package:law_app/utils/colorlaw.dart';

TextStyle posRes = TextStyle(
        color: Colors.white,
        fontSize: 18,
        backgroundColor: ColorLaw.blue,
        fontFamily: "Fregat");
TextStyle negRes = TextStyle(
        color: Colors.black87,
        fontSize: 18,
        backgroundColor: Colors.transparent,
        fontFamily: "Fregat");

TextSpan searchMatch(String match, dynamic search, {double fontSize = 16.0}) {
  final TextStyle pos = TextStyle(
    color: Colors.white,
    fontSize: fontSize,
    backgroundColor: ColorLaw.blue,
    fontFamily: "Fregat",
  );
  final TextStyle neg = TextStyle(
    color: const Color(0xFF1E293B),
    fontSize: fontSize,
    backgroundColor: Colors.transparent,
    fontFamily: "Fregat",
    height: 1.5,
  );

  if (search == null || search == "" || (search is String && search.isEmpty)) {
    return TextSpan(text: match, style: neg);
  }
  final String searchStr = search.toString();
  var refinedMatch = match.toLowerCase();
  var refinedSearch = searchStr.toLowerCase();
  if (refinedMatch.contains(refinedSearch)) {
    if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
      return TextSpan(
        style: pos,
        text: match.substring(0, refinedSearch.length),
        children: [
          searchMatch(
            match.substring(refinedSearch.length),
            searchStr,
            fontSize: fontSize,
          ),
        ],
      );
    } else if (refinedMatch.length == refinedSearch.length) {
      return TextSpan(text: match, style: pos);
    } else {
      return TextSpan(
        style: neg,
        text: match.substring(
          0,
          refinedMatch.indexOf(refinedSearch),
        ),
        children: [
          searchMatch(
            match.substring(refinedMatch.indexOf(refinedSearch)),
            searchStr,
            fontSize: fontSize,
          ),
        ],
      );
    }
  } else if (!refinedMatch.contains(refinedSearch)) {
    return TextSpan(text: match, style: neg);
  }
  return TextSpan(
    text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
    style: neg,
    children: [
      searchMatch(
        match.substring(refinedMatch.indexOf(refinedSearch)),
        searchStr,
        fontSize: fontSize,
      )
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

//   TextSpan searchMatch({String match = "", String? search}) {
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
