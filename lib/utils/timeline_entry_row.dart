import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:meta/meta.dart';

class LinePainter extends CustomPainter {
  LinePainter(
      {@required this.lineColor,
      @required this.backgroundColor,
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
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    canvas.drawLine(size.topCenter(new Offset(0.0, 2.0)),
        size.bottomCenter(new Offset(0.0, -2.0)), linePaint);
  }

  void _paint(Canvas canvas, Size size) {
    Paint linePaint = new Paint()
      ..color = lineColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    canvas.drawLine(size.topCenter(new Offset(0.0, 2.0)),
        size.bottomCenter(new Offset(0.0, -2.0)), linePaint);

    Paint fillPaint = new Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), 8.0, fillPaint);
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
      {@required this.lineColor,
      @required this.backgroundColor,
      @required this.imagesBaseUrl,
      @required this.entry});

  Widget _buildTimeColumn(BuildContext context) {
    return new Container(
        width: 30.0,
        //color: Colors.lightBlue,
        child: new Center(
          child: new Text(
            entry.taxonomy,
            style: new TextStyle(
              fontSize: 9.0,
              fontWeight: FontWeight.normal,
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

  Widget _buildTextColumn(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Container(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: new Text(
            entry.description,
            style: new TextStyle(
              //color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        new Text(
          entry.description,
          style: new TextStyle(
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return new Container(
      height: 80.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
      //color: Colors.amber,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeColumn(context),
          _buildLineColumn(context),
          new Expanded(child: _buildTextColumn(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardContent(context);
  }
}

class TimelineEntryEnding extends StatelessWidget {
  final Color color;
  final Color backgroundColor;

  TimelineEntryEnding({@required this.color, @required this.backgroundColor});

  Widget _buildTimeColumn(BuildContext context) {
    return new Container(
      width: 30.0,
    );
  }

  Widget _buildLineColumn(BuildContext context) {
    return new Container(
        width: 40.0,
        //color: Colors.lightGreen,
        child: new CustomPaint(
            painter: new LinePainter(
                lineColor: color,
                backgroundColor: backgroundColor,
                ending: true)));
  }

  Widget _buildCardContent(BuildContext context) {
    return new Container(
      height: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
      //color: Colors.amber,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildTimeColumn(context), _buildLineColumn(context)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardContent(context);
  }
}
