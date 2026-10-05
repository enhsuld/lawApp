import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const int PAGE_SIZE = 10;

  var publishedTerms = <TermOnlyModel>[];
  bool _isLoading = true;

  // Оршил цэсийг хамгийн эхэнд байршуулах эрэмбэлэлтийн бүтэц
  List<TermOnlyModel> _sortTerms(List<TermOnlyModel> list) {
    const orderMap = {
      "2": 1, // 1. Оршил (Preamble) - Хамгийн дээр
      "3": 2, // 2. Монгол улсын үндсэн хууль
      "4": 3, // 3. Нэмэлт өөрчлөлтүүд
      "5": 4, // 4. Монгол улсын түүх
      "6": 5, // 5. Найзтайгаа хуваалцах
    };

    final result = List<TermOnlyModel>.from(list);
    result.sort((a, b) {
      final orderA = orderMap[a.slug] ??
          (a.name?.toLowerCase().contains("оршил") == true ? 1 : 99);
      final orderB = orderMap[b.slug] ??
          (b.name?.toLowerCase().contains("оршил") == true ? 1 : 99);
      return orderA.compareTo(orderB);
    });
    return result;
  }

  _read() async {
    try {
      final terms = await BackendService.getTerm(1, PAGE_SIZE);
      if (mounted) {
        setState(() {
          publishedTerms = _sortTerms(terms);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _verifyVersion() async {
    if (kDebugMode) return;
    try {
      await AppVersionUpdate.checkForUpdates(
        appleId: '1507881332',
        playStoreId: 'mn.law.constitution',
        country: 'mn',
      ).then((data) async {
        if (data.canUpdate == true && mounted) {
          await AppVersionUpdate.showAlertUpdate(
            appVersionResult: data,
            context: context,
            backgroundColor: Colors.grey[200],
            title: 'Мэдэгдэл',
            mandatory: false,
            content: 'Шинэ хувилбар гарсан байна. Шинэчилнэ үү',
            updateButtonText: 'Татах',
            cancelButtonText: 'Үгүй',
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 24.0,
            ),
            contentTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          );
        }
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _read();
    _verifyVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorLaw.blue,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),

              // 1. Төрийн сүлд - Алтан шаргал болон хөх гэрлийн уусалттай (Ambient Glow)
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Сүлдний арын зөөлөн гэрэлтэлтийн уусалт
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFBBF24).withOpacity(0.35),
                            blurRadius: 45,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: const Color(0xFF38BDF8).withOpacity(0.25),
                            blurRadius: 65,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/images/logo_large.png",
                      height: 125,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. Дээд гарчиг
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'МОНГОЛ УЛСЫН ҮНДСЭН ХУУЛЬ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: "Fregat",
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.65),
                        blurRadius: 14,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Үндэсний хээний гоёл бүхий нарийн зааглагч
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 1,
                      color: Colors.white.withOpacity(0.35),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        "assets/images/hee_home.png",
                        height: 12,
                        color: const Color(0xFFFDE68A), // Алтан шаргал туяа
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 1,
                      color: Colors.white.withOpacity(0.35),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // 4. Үндсэн цэсүүд
              Expanded(
                child: _isLoading && publishedTerms.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: publishedTerms.length,
                        itemBuilder: (ctx, i) {
                          final item = publishedTerms[i];
                          return TermItem(item, i);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
