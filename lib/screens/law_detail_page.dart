import 'package:flutter/material.dart';
import 'package:law_app/items/TermVerticalItem.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/models/term_law.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/material_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LawDetailPage extends StatefulWidget {
  final TermOnlyModel term;

  const LawDetailPage({Key? key, required this.term}) : super(key: key);

  @override
  _LawDetailPageState createState() => _LawDetailPageState();
}

class _LawDetailPageState extends State<LawDetailPage>
    with TickerProviderStateMixin {
  List<TermLawModel> publishedTerms = [];
  String search = "";
  TabController? _tabController;
  bool _isLoading = true;
  bool _isExpandedAll = false;
  int _expansionVersion = 0;
  double _fontSize = 16.0;

  final List<String> _suggestedKeywords = [
    'Хүний эрх',
    'Иргэний үндсэн үүрэг',
    'Улсын Их Хурал',
    'Ерөнхийлөгч',
    'Засгийн газар',
    'Шүүх эрх мэдэл',
    'Үндсэн хуулийн цэц',
    'Төрийн сүлд, туг, дуулал',
    'Тусгаар тогтнол',
    'Өмч',
    'Татвар',
    'Хууль санаачлах',
    'Сонгууль',
    'Эдийн засаг',
  ];

  @override
  void initState() {
    super.initState();
    _loadFontSize();
    getLaws(keyword: "");
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble('constitution_font_size');
    if (saved != null && mounted) {
      setState(() {
        _fontSize = saved;
      });
    }
  }

  Future<void> _setFontSize(double size) async {
    setState(() {
      _fontSize = size;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('constitution_font_size', size);
  }

  void _toggleExpandAll() {
    setState(() {
      _isExpandedAll = !_isExpandedAll;
      _expansionVersion++;
    });
  }

  void getLaws({String keyword = ""}) {
    setState(() {
      _isLoading = true;
    });
    BackendService.getLawSearch(keyword: keyword).then((terms) {
      if (mounted) {
        setState(() {
          publishedTerms = terms;
          _isLoading = false;
          if (terms.isNotEmpty) {
            final oldIndex = _tabController?.index ?? 0;
            _tabController?.dispose();
            _tabController = TabController(
              length: terms.length,
              vsync: this,
              initialIndex: oldIndex.clamp(0, terms.length - 1),
            );
          }
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

  MaterialPageRoute<String> _buildMaterialSearchPage(BuildContext context) {
    return MaterialPageRoute<String>(
      settings: const RouteSettings(name: 'material_search'),
      builder: (BuildContext context) {
        return Material(
          child: MaterialSearch<String>(
            placeholder: 'Үндсэн хуулиас хайх...',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ColorLaw.blue),
              onPressed: () => Navigator.of(context).pop(),
            ),
            results: _suggestedKeywords
                .map((String v) => MaterialSearchResult<String>(
                      icon: Icons.search_rounded,
                      value: v,
                      text: v,
                    ))
                .toList(),
            filter: (dynamic value, String criteria) {
              if (criteria.trim().isEmpty) return true;
              return value
                  .toString()
                  .toLowerCase()
                  .trim()
                  .contains(criteria.toLowerCase().trim());
            },
            onSelect: (dynamic value) => Navigator.of(context).pop(value),
            onSubmit: (String value) {
              Navigator.of(context).pop(value);
            },
          ),
        );
      },
    );
  }

  void _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      if (value != null && value is String && value.trim().isNotEmpty) {
        final query = value.trim();
        setState(() {
          search = query;
        });
        getLaws(keyword: "?query=" + query);
      }
    });
  }

  void _showFontSizeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Үсгийн хэмжээ тохируулах",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Fregat",
                            color: ColorLaw.blue,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ColorLaw.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${_fontSize.toInt()} pt",
                            style: const TextStyle(
                              color: ColorLaw.blue,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Fregat",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Live preview container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "НЭГДҮГЭЭР ЗҮЙЛ",
                            style: TextStyle(
                              fontSize: (_fontSize + 1).clamp(15.0, 22.0),
                              fontWeight: FontWeight.bold,
                              color: ColorLaw.blue,
                              fontFamily: "Fregat",
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "1. Монгол Улс бол тусгаар тогтносон, бүрэн эрхт, Бүгд найрамдах улс мөн.",
                            style: TextStyle(
                              fontSize: _fontSize,
                              height: 1.4,
                              fontFamily: "Fregat",
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Slider
                    Row(
                      children: [
                        const Text("A",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            min: 13.0,
                            max: 22.0,
                            divisions: 9,
                            activeColor: ColorLaw.blue,
                            inactiveColor: Colors.grey.shade300,
                            label: "${_fontSize.toInt()}",
                            onChanged: (double val) {
                              setModalState(() {});
                              _setFontSize(val);
                            },
                          ),
                        ),
                        const Text("A",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: ColorLaw.blue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Preset size chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPresetChip("Жижиг", 14.0, setModalState),
                        _buildPresetChip("Энгийн", 16.0, setModalState),
                        _buildPresetChip("Том", 18.0, setModalState),
                        _buildPresetChip("Маш том", 20.0, setModalState),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPresetChip(
      String label, double size, StateSetter setModalState) {
    final isSelected = (_fontSize - size).abs() < 0.5;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontFamily: "Fregat")),
      selected: isSelected,
      selectedColor: ColorLaw.blue.withOpacity(0.15),
      labelStyle: TextStyle(
        color: isSelected ? ColorLaw.blue : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (bool selected) {
        if (selected) {
          setModalState(() {});
          _setFontSize(size);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: ColorLaw.blue),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Text(
            "Үндсэн хууль".toUpperCase(),
            style: const TextStyle(
              color: ColorLaw.blue,
              fontWeight: FontWeight.w700,
              fontFamily: "Fregat",
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: ColorLaw.blue),
        ),
      );
    }

    if (publishedTerms.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: ColorLaw.blue),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Үндсэн хууль".toUpperCase(),
            style: const TextStyle(
              color: ColorLaw.blue,
              fontWeight: FontWeight.w700,
              fontFamily: "Fregat",
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                search.isNotEmpty
                    ? "Хайлтад тохирох зүйл олдсонгүй"
                    : "Мэдээлэл олдсонгүй",
                style: const TextStyle(fontFamily: "Fregat", fontSize: 16),
              ),
              if (search.isNotEmpty) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      search = "";
                    });
                    getLaws(keyword: "");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorLaw.blue,
                  ),
                  child: const Text("Бүх зүйлийг харах",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: ColorLaw.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Үндсэн хууль".toUpperCase(),
          style: const TextStyle(
            color: ColorLaw.blue,
            fontWeight: FontWeight.w700,
            fontFamily: "Fregat",
          ),
        ),
        actions: <Widget>[
          // Font size adjust button
          IconButton(
            tooltip: "Үсгийн хэмжээ",
            onPressed: () => _showFontSizeSheet(context),
            icon: const Icon(Icons.format_size_rounded, color: ColorLaw.blue),
          ),
          // Expand / Collapse all button
          IconButton(
            tooltip: _isExpandedAll ? "Бүгдийг хураах" : "Бүгдийг дэлгэх",
            onPressed: _toggleExpandAll,
            icon: Icon(
              _isExpandedAll
                  ? Icons.unfold_less_rounded
                  : Icons.unfold_more_rounded,
              color: ColorLaw.blue,
            ),
          ),
          // Search button
          if (search.isNotEmpty)
            IconButton(
              tooltip: "Хайлт цэвэрлэх",
              onPressed: () {
                setState(() {
                  search = "";
                });
                getLaws(keyword: "");
              },
              icon: const Icon(Icons.close_rounded, color: ColorLaw.blue),
            )
          else
            IconButton(
              tooltip: "Хайх",
              onPressed: () => _showMaterialSearch(context),
              icon: const Icon(Icons.search_rounded, color: ColorLaw.blue),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: "Fregat",
          ),
          unselectedLabelStyle: const TextStyle(fontFamily: "Fregat"),
          labelColor: ColorLaw.blue,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.5, color: ColorLaw.blue),
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: publishedTerms
              .map((tab) => Tab(text: tab.name ?? ""))
              .toList(),
        ),
      ),
      body: Column(
        children: [
          // If search is active, show query indicator
          if (search.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: ColorLaw.blue.withOpacity(0.08),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      size: 18, color: ColorLaw.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Хайлтын илэрц: "$search"',
                      style: const TextStyle(
                        color: ColorLaw.blue,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Fregat",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        search = "";
                      });
                      getLaws(keyword: "");
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "Цэвэрлэх",
                        style: TextStyle(
                          color: ColorLaw.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          fontFamily: "Fregat",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(publishedTerms.length, (chapterIndex) {
                final view = publishedTerms[chapterIndex];
                final articles = (view.cntTerms ?? [])
                    .whereType<TermLawModel>()
                    .toList();

                return CustomScrollView(
                  slivers: <Widget>[
                    // 1. Chapter Banner with Flag and Gradient Overlay
                    SliverToBoxAdapter(
                      child: Container(
                        height: 125,
                        margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/tug.jpg"),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.55),
                                Colors.black.withOpacity(0.78),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${view.slug ?? view.name ?? ''}".toUpperCase(),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Fregat",
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.35),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  "Нийт ${articles.length} зүйлтэй",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Fregat",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 2. Quick action toolbar (Expand all / Font size status)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: _toggleExpandAll,
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isExpandedAll
                                          ? Icons.unfold_less_rounded
                                          : Icons.unfold_more_rounded,
                                      size: 18,
                                      color: ColorLaw.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _isExpandedAll
                                          ? "Бүгдийг хураах"
                                          : "Бүгдийг дэлгэх",
                                      style: const TextStyle(
                                        color: ColorLaw.blue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Fregat",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _showFontSizeSheet(context),
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.text_fields_rounded,
                                      size: 18,
                                      color: ColorLaw.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Үсэг: ${_fontSize.toInt()}pt",
                                      style: const TextStyle(
                                        color: ColorLaw.blue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Fregat",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 3. Articles list
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final item = articles[index];
                          return TermVerticalItem(
                            item,
                            index,
                            search,
                            key: ValueKey(
                                'term_${item.id}_${_expansionVersion}_${_isExpandedAll}_$search'),
                            initiallyExpanded: _isExpandedAll,
                            fontSize: _fontSize,
                          );
                        },
                        childCount: articles.length,
                      ),
                    ),
                    // 4. Navigation to next chapter button at the bottom of the chapter
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 36),
                        child: (chapterIndex < publishedTerms.length - 1)
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  _tabController?.animateTo(chapterIndex + 1);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorLaw.blue,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_forward_rounded,
                                    size: 18),
                                label: Text(
                                  "Дараагийн бүлэг: ${publishedTerms[chapterIndex + 1].name ?? ''}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Fregat",
                                  ),
                                ),
                              )
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                alignment: Alignment.center,
                                child: Text(
                                  "— Монгол Улсын Үндсэн хууль төгсөв —",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Fregat",
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
