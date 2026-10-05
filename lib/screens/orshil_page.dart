import 'package:flutter/material.dart';
import 'package:law_app/models/term1.dart';

class OrshilPage extends StatefulWidget {
  final TermOnlyModel term;
  const OrshilPage({Key? key, required this.term}) : super(key: key);

  @override
  _OrshilPageState createState() => _OrshilPageState();
}

class _OrshilPageState extends State<OrshilPage> {
  @override
  Widget build(BuildContext context) {
    final list = widget.term.cntTerms ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xff1b4392),
            size: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "ҮНДСЭН ХУУЛИЙН ОРШИЛ".toUpperCase(),
          style: const TextStyle(
            color: Color(0xff1b4392),
            fontWeight: FontWeight.w700,
            fontFamily: "Fregat",
            fontSize: 16.5,
            letterSpacing: 0.6,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 36),
        child: Column(
          children: [
            // Төрийн сүлд болон дэвсгэрийн карт
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Сүлд
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Image.asset(
                      "assets/images/logo_large.png",
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Алтан хээний гоёл
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      "assets/images/hee_home.png",
                      height: 14,
                      color: const Color(0xFFD97706),
                    ),
                  ),

                  // Заалтууд
                  if (list.isEmpty)
                    const Text(
                      "Мэдээлэл олдсонгүй",
                      style: TextStyle(
                        fontFamily: "Fregat",
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    )
                  else
                    ...list.map((model) {
                      final text = model.name?.trim() ?? "";
                      final isFirst = text.startsWith("Монголын ард түмэн бид");
                      final isLast = text.contains("тунхаглаж байна");

                      if (isFirst) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Fregat",
                              color: Color(0xFF1B4392),
                              height: 1.35,
                            ),
                          ),
                        );
                      }

                      if (isLast) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFBFDBFE),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              text,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Fregat",
                                color: Color(0xFF1E3A8A),
                                height: 1.5,
                              ),
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8, right: 10),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD97706), // Golden bullet
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                text.startsWith("-") ? text.substring(1).trim() : text,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Fregat",
                                  color: Color(0xFF334155),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
