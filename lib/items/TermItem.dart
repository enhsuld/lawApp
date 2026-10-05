import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/screens/about_page.dart';
import 'package:law_app/screens/addition_page.dart';
import 'package:law_app/screens/history_page.dart';
import 'package:law_app/screens/law_detail_page.dart';
import 'package:law_app/screens/orshil_page.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/fade_route.dart';

class TermItem extends StatefulWidget {
  final TermOnlyModel model;
  final int index;

  const TermItem(this.model, this.index, {Key? key}) : super(key: key);

  @override
  _TermItemState createState() => _TermItemState();
}

class _TermItemState extends State<TermItem> {
  // Хуучин үндсэн icon зургуудыг ашиглах
  String _getIconAsset(String? slug) {
    switch (slug) {
      case "0":
        return 'assets/images/ic_home_two.png';
      case "1":
        return 'assets/images/ic_home_three.png';
      case "2":
        return 'assets/images/ic_home_two.png';
      case "3":
        return 'assets/images/ic_home_three.png';
      case "4":
        return 'assets/images/ic_home_four.png';
      case "5":
        return 'assets/images/ic_home_five.png';
      case "6":
        return 'assets/images/ic_home_six.png';
      default:
        return 'assets/images/ic_home_two.png';
    }
  }

  void _onItemTap() {
    if (widget.model.slug == "6") {
      final box = context.findRenderObject() as RenderBox?;
      final size = MediaQuery.of(context).size;
      final Rect sharePositionOrigin =
          (box != null && box.hasSize && !box.size.isEmpty)
              ? box.localToGlobal(Offset.zero) & box.size
              : Rect.fromLTWH(0, 0, size.width, size.height / 2);

      Share.share(
        'Монгол Улсын Үндсэн хууль\nhttps://onelink.to/conslaw',
        subject: 'Монгол Улсын Үндсэн хууль',
        sharePositionOrigin: sharePositionOrigin,
      );
    } else if (widget.model.slug == "4") {
      Navigator.of(context).push(
        FadeRoute(builder: (context) => AdditionPage(term: widget.model)),
      );
    } else if (widget.model.slug == "1") {
      Navigator.of(context).push(
        FadeRoute(builder: (context) => AboutPage(term: widget.model)),
      );
    } else if (widget.model.slug == "5") {
      Navigator.of(context).push(
        FadeRoute(builder: (context) => HistoryPage(term: widget.model)),
      );
    } else if (widget.model.slug == "2") {
      Navigator.of(context).push(
        FadeRoute(builder: (context) => OrshilPage(term: widget.model)),
      );
    } else if (widget.model.slug == "3") {
      Navigator.of(context).push(
        FadeRoute(builder: (context) => LawDetailPage(term: widget.model)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.14),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.88),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: ColorLaw.blue.withOpacity(0.12),
                highlightColor: ColorLaw.blue.withOpacity(0.06),
                onTap: _onItemTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Row(
                    children: <Widget>[
                      // Хуучин icon зураг
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Image.asset(
                          _getIconAsset(widget.model.slug),
                          width: 26,
                          height: 26,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Гарчиг
                      Expanded(
                        child: Text(
                          widget.model.name ?? "",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorLaw.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Fregat",
                          ),
                        ),
                      ),

                      // Баруун талын жижиг суман чиглүүлэгч
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: ColorLaw.blue.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
