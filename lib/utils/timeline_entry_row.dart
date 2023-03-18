import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:meta/meta.dart';

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
      ..shader = new ui.Gradient.linear(new Offset(0.0, 20.0),
          new Offset(0.0, 0.0), <Color>[backgroundColor, lineColor])
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
    //canvas.drawRect(new Rect.fromLTRB(0.0, 0.0, 20.0, 20.0), fillPaint);
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

  Widget _buildTimeColumn(BuildContext context) {
    return new Container(
        width: 40.0,
        //color: Colors.lightBlue,
        child: new Center(
          child: new Text(
            entry?.taxonomy ?? "",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Widget _buildLineColumn(BuildContext context) {
    return new Container(
        width: 40.0,
        //color: Colors.lightGreen,
        child: new CustomPaint(
            painter: new LinePainter(
                lineColor: lineColor, backgroundColor: lineColor)));
  }

  Widget _buildLineCheck(BuildContext context) {
    return Container(
      width: 30,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 1.5,
              color: ColorLaw.blue,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 28,
                height: 21,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    //shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(width: 1.5, color: ColorLaw.blue),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: new AssetImage("assets/images/tug.png"),
                    )),
                //child: Image.asset("assets/images/tug.png"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextColumn(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Container(
          //height: lengthToHeight((entry?.description ?? "").length),
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: new Text(entry?.taxonomy ?? "",
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.clip,
                    style: new TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                  width: double.infinity,
                  child: new Text(
                    entry?.description ?? "",
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.clip,
                    style: new TextStyle(
                        //color: Colors.black,
                        fontSize: 14),
                  )),
            ],
          ),
          /*      child: new Text(
            entry.description,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.clip,
            style: new TextStyle(
                //color: Colors.black,
                ),
          ),*/
        ),
        // new Text(
        //   entry.description,
        //   style: new TextStyle(
        //     color: Colors.grey[500],
        //   ),
        // ),
      ],
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
        height: lengthToHeight((entry?.description ?? "").length),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
        //color: Colors.amber,
        child: Row(
          children: <Widget>[
            _buildLineCheck(context),
            // Container(
            //   width: 10,
            //   color: Colors.black,
            //   child: Expanded(
            //     child: Stack(),
            //   ),
            // ),
            // Row(
            //   children: <Widget>[
            //     Container(
            //       width: 10,
            //       height: 10,
            //       color: Colors.black,
            //     )
            //   ],
            // ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (entry?.taxonomy ?? "").length > 0
                    ? Container(
                        width: MediaQuery.of(context).size.width - 64,
                        child: new Text(entry?.taxonomy ?? "",
                            textAlign: TextAlign.justify,
                            style: new TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )
                    : Container(),
                Container(
                    width: MediaQuery.of(context).size.width - 68,
                    child: new Text(
                      entry?.description ?? "",
                      textAlign: TextAlign.justify,
                      //overflow: TextOverflow.clip,
                      style: new TextStyle(
                          //color: Colors.black,
                          fontSize: 16),
                    )),
                // SizedBox(
                //   height: 30,
                // )
              ],
            )
          ],
        )
        // new Row(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     //_buildLineColumn(context),
        //     _buildLineCheck(context),
        //     SizedBox(width: 10),
        //     //new Expanded(child: _buildTextColumn(context))
        //   ],
        // ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardContent(context);
  }
}
