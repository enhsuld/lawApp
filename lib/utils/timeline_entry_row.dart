import 'package:flutter/material.dart';
import 'package:law_app/models/taxonomy.dart';

class LinePainter extends CustomPainter {
  LinePainter({
    required this.lineColor,
    required this.backgroundColor,
    this.ending = false,
  }) : super();

  final Color backgroundColor;
  final Color lineColor;
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
    final Paint linePaint = Paint()
      ..shader = LinearGradient(
        colors: [backgroundColor, lineColor],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Offset.zero & size)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      size.topCenter(const Offset(0.0, 2.0)),
      size.bottomCenter(const Offset(0.0, -2.0)),
      linePaint,
    );
  }

  void _paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      size.topCenter(const Offset(0.0, 2.0)),
      size.bottomCenter(const Offset(0.0, -2.0)),
      linePaint,
    );

    final Paint fillPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), 10.0, fillPaint);
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

  const TimelineEntryRow({
    Key? key,
    required this.lineColor,
    required this.backgroundColor,
    required this.imagesBaseUrl,
    required this.entry,
  }) : super(key: key);

  Widget _buildLineCheck(BuildContext context) {
    return SizedBox(
      width: 34,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Босоо шугам
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
          // Төрийн тугтай тэмдэглэгээ
          Positioned(
            top: 14,
            left: 2,
            right: 2,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1B4392),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B4392).withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/tug.png",
                    width: 17,
                    height: 17,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final title = (entry.taxonomy ?? "").trim();
    final description = (entry.description ?? "").trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLineCheck(context),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (title.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4, right: 8),
                              width: 3.5,
                              height: 15,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B4392),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B4392),
                                  fontFamily: "Fregat",
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (description.isNotEmpty)
                        Text(
                          description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.55,
                            color: Color(0xFF334155),
                            fontFamily: "Fregat",
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardContent(context);
  }
}
