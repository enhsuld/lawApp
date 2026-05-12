import 'package:flutter/material.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/utils/colorlaw.dart';

class LinePainter extends CustomPainter {
  LinePainter(
      {required this.lineColor,
      required this.backgroundColor,
      this.ending = false})
      : super();

  /// The background color
  final Color backgroundColor;

  /// The line color
  final Color lineColor;

  /// Is this line painter for an ending row?
  final bool ending;

  @override
  void paint(Canvas canvas, Size size) {
    if (!ending) {
      _paint(canvas, size);
      return;
    }
    _paintEnding(canvas, size);
  }

  void _paintEnding(Canvas canvas, Size size) {
    Paint linePaint = new Paint()
      ..shader = new LinearGradient(
              colors: [backgroundColor, lineColor],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter)
          .createShader(Offset.zero & size)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    canvas.drawLine(size.topCenter(new Offset(0.0, 2.0)),
        size.bottomCenter(new Offset(0.0, -2.0)), linePaint);
  }

  void _paint(Canvas canvas, Size size) {
    Paint linePaint = new Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    canvas.drawLine(size.topCenter(new Offset(0.0, 2.0)),
        size.bottomCenter(new Offset(0.0, -2.0)), linePaint);

    Paint fillPaint = new Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), 14.0, fillPaint);
  }

  @override
  bool shouldRepaint(LinePainter other) {
    return lineColor != other.lineColor ||
        backgroundColor != other.backgroundColor;
  }
}

class TimelineEntryRow extends StatelessWidget {
  final Color lineColor;
  final Color backgroundColor;
  final String imagesBaseUrl;
  final TaxonomyModel entry;

  TimelineEntryRow(
      {required this.lineColor,
      required this.backgroundColor,
      required this.imagesBaseUrl,
      required this.entry});

  Widget _buildLineCheck(BuildContext context) {
    return Container(
      width: 30,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 1.5,
                color: ColorLaw.blue,
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 21,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: ColorLaw.blue),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: new AssetImage("assets/images/tug.png"),
                  )),
            ),
          )
        ],
      ),
    );
  }

  double lengthToHeight(txtLength) {
    if (txtLength < 50) {
      return 90;
    }
    if (txtLength < 90) {
      return 110;
    }
    if (txtLength < 150) {
      return 140;
    }
    if (txtLength < 220) {
      return 170;
    }

    if (txtLength < 290) {
      return 200;
    }
    if (txtLength < 500) {
      return 250;
    } else {
      return 310;
    }
  }

  Widget _buildCardContent(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLineCheck(context),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      (entry.taxonomy ?? "").isNotEmpty
                          ? Container(
                              child: new Text(entry.taxonomy ?? "",
                                  textAlign: TextAlign.justify,
                                  style: new TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            )
                          : Container(),
                      SizedBox(height: 4),
                      Container(
                          child: new Text(
                        entry.description ?? "",
                        textAlign: TextAlign.justify,
                        style: new TextStyle(fontSize: 16),
                      )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardContent(context);
  }
}
