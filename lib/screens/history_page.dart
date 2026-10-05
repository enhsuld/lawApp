import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:law_app/models/history.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/screens/history_details_page.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/fade_route.dart';

class HistoryPage extends StatefulWidget {
  final TermOnlyModel term;
  const HistoryPage({Key? key, required this.term}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryModel> historys = [];
  bool _isLoading = true;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    BackendService.getHistoryGroup().then((onValue) {
      if (mounted) {
        setState(() {
          historys = onValue;
          _isLoading = false;
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HistoryModel> get _filteredHistorys {
    if (_searchQuery.trim().isEmpty) return historys;
    final q = _searchQuery.trim().toLowerCase();
    return historys.where((item) {
      final name = (item.name ?? "").toLowerCase();
      return name.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredHistorys;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
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
          "Монгол улсын түүх".toUpperCase(),
          style: const TextStyle(
            color: Color(0xff1b4392),
            fontWeight: FontWeight.w700,
            fontFamily: "Fregat",
            letterSpacing: 0.8,
            fontSize: 17,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B4392)),
            )
          : historys.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history_edu_rounded,
                        size: 56,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Мэдээлэл олдсонгүй",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: "Fregat",
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Хайлтын талбар болон статистик
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) {
                                  setState(() {
                                    _searchQuery = val;
                                  });
                                },
                                style: const TextStyle(
                                  fontFamily: "Fregat",
                                  fontSize: 14.5,
                                  color: Color(0xFF1E293B),
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      "Түүхэн үе, он цагаар хайх... (жишээ: Хүннү, Юан)",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13.5,
                                    fontFamily: "Fregat",
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF1B4392),
                                    size: 22,
                                  ),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear_rounded,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchQuery = "";
                                            });
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_rounded,
                                  size: 14,
                                  color: Color(0xFF1B4392),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _searchQuery.isEmpty
                                      ? "НИЙТ ${historys.length} ТҮҮХЭН ҮЕ ШАТ"
                                      : "ИЛЭРЦ: ${filtered.length} ТҮҮХЭН ҮЕ",
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Fregat",
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Түүхийн картууд
                    if (filtered.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 54,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Хайлтад тохирох түүхийн үе олдсонгүй",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontFamily: "Fregat",
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = "";
                                  });
                                },
                                child: const Text(
                                  "Бүгдийг харах",
                                  style: TextStyle(
                                    color: Color(0xFF1B4392),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 4, bottom: 28),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final model = filtered[index];
                              return _itemBuilder(context, model, index);
                            },
                            childCount: filtered.length,
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _itemBuilder(BuildContext context, HistoryModel entry, int index) {
    final raw = entry.name?.trim() ?? '';
    String era = '';
    String timeRange = '';
    String title = raw;

    // 1. '/.../' он цагийн мэдээллийг салгах
    final timeMatch = RegExp(r'/([^/]+)/?\s*$').firstMatch(title);
    if (timeMatch != null) {
      timeRange = timeMatch.group(1)!.trim();
      title = title.substring(0, timeMatch.start).trim();
    }

    // 2. Үе / салбар бүлгийг салгах
    final eraRomanMatch = RegExp(
      r'^([IVXLCDM]+\s*үе(?:ийн\s+үргэлжлэл)?\.?)\s*(.*)',
      caseSensitive: false,
    ).firstMatch(title);

    if (eraRomanMatch != null) {
      era = eraRomanMatch.group(1)!.replaceAll('.', '').trim();
      title = eraRomanMatch.group(2)!.trim();
    } else {
      final numberMatch = RegExp(r'^(\d+)\.\s*(.*)').firstMatch(title);
      if (numberMatch != null) {
        era = 'XI үе · ${numberMatch.group(1)}';
        title = numberMatch.group(2)!.trim();
      }
    }

    final hasImage = (entry.medias ?? []).isNotEmpty;
    final imageUrl = hasImage ? (BackendService.link + entry.medias[0]) : '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: const Color(0xFF0F172A),
          child: InkWell(
            onTap: () {
              if (entry.id != null) {
                Navigator.push(
                  context,
                  FadeRoute(
                    builder: (context) => HistoryDetailsPage(
                      term: entry.id!,
                      title: title,
                      era: era,
                      timeRange: timeRange,
                      imageUrl: imageUrl,
                    ),
                  ),
                );
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Арын дэвсгэр: Зураг эсвэл Төрийн сүлд бүхий тансаг градиент
                if (hasImage) ...[
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF0F1E3D),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white38,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => _buildHeritagePattern(),
                  ),
                  // Ууссан градиент давхарга
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.35, 0.65, 1.0],
                        colors: [
                          Colors.black.withOpacity(0.40),
                          Colors.black.withOpacity(0.12),
                          Colors.black.withOpacity(0.70),
                          Colors.black.withOpacity(0.96),
                        ],
                      ),
                    ),
                  ),
                ] else
                  _buildHeritagePattern(),

                // 2. Дээд талын мэдээллийн эгнээ (Үеийн пайз + Дараалал)
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Үеийн пайз
                      if (era.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A).withOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFBBF24).withOpacity(0.6),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_stories_rounded,
                                size: 12,
                                color: Color(0xFFFBBF24),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                era.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Fregat",
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      // Дарааллын дугаар эсвэл архивын тэмдэглэгээ
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          "#${(index + 1).toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Fregat",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Доод талын Он цаг + Гарчиг + Дэлгэрэнгүй товч
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (timeRange.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3.5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.45),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFFBBF24).withOpacity(0.4),
                                    width: 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.schedule_rounded,
                                      size: 13,
                                      color: Color(0xFFFBBF24),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        timeRange,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFFFDE68A),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Fregat",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Fregat",
                                height: 1.25,
                                shadows: [
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Glassmorphic сумын товч
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Зураггүй үед харагдах өвөрмөц төрийн архивын дэвсгэр
  Widget _buildHeritagePattern() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F1E3D),
            Color(0xFF1B3B73),
            Color(0xFF0B1426),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Төрийн сүлдний усан хээ
          Positioned(
            right: -20,
            bottom: -25,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                'assets/images/suld.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Гэрлийн уусалт
          Positioned(
            top: -30,
            left: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.15),
              ),
            ),
          ),
          // Харанхуйлах давхарга
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
