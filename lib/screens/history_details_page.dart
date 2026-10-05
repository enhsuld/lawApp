import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/timeline_entry_row.dart';

class HistoryDetailsPage extends StatefulWidget {
  final int term;
  final String? title;
  final String? era;
  final String? timeRange;
  final String? imageUrl;

  const HistoryDetailsPage({
    Key? key,
    required this.term,
    this.title,
    this.era,
    this.timeRange,
    this.imageUrl,
  }) : super(key: key);

  @override
  _HistoryDetailsPageState createState() => _HistoryDetailsPageState();
}

class _HistoryDetailsPageState extends State<HistoryDetailsPage> {
  static const int PAGE_SIZE = 15;
  final List<TaxonomyModel> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadPage();
      }
    });
  }

  Future<void> _loadPage({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _page = 0;
      _hasMore = true;
      _items.clear();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newItems =
          await BackendService.getHistoryList(widget.term, _page, PAGE_SIZE);
      if (mounted) {
        setState(() {
          _items.addAll(newItems);
          _page++;
          if (newItems.length < PAGE_SIZE) {
            _hasMore = false;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasHeader = (widget.title ?? "").isNotEmpty ||
        (widget.era ?? "").isNotEmpty ||
        (widget.timeRange ?? "").isNotEmpty;

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
          (widget.era != null && widget.era!.isNotEmpty)
              ? widget.era!.toUpperCase()
              : "ТҮҮХИЙН ДЭЛГЭРЭНГҮЙ",
          style: const TextStyle(
            color: Color(0xff1b4392),
            fontWeight: FontWeight.w700,
            fontFamily: "Fregat",
            fontSize: 16.5,
            letterSpacing: 0.6,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF1B4392),
        onRefresh: () => _loadPage(refresh: true),
        child: _items.isEmpty && _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF1B4392)),
              )
            : _items.isEmpty && !_hasMore
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
                          "Түүхэн тэмдэглэл олдсонгүй",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontFamily: "Fregat",
                          ),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // Толгой карт
                      if (hasHeader)
                        SliverToBoxAdapter(
                          child: _buildHeaderCard(),
                        ),

                      // Цаг хугацааны дараалал гарчиг
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B4392),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "ЦАГ ХУГАЦААНЫ ДАРААЛАЛ",
                                style: TextStyle(
                                  color: Color(0xFF475569),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Fregat",
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Түүхийн цаг хугацааны эгнээнүүд
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 30),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == _items.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF1B4392),
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                );
                              }
                              return TimelineEntryRow(
                                lineColor: ColorLaw.blue,
                                backgroundColor: Theme.of(context).canvasColor,
                                imagesBaseUrl: "",
                                entry: _items[index],
                              );
                            },
                            childCount: _items.length + (_hasMore ? 1 : 0),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final title = widget.title ?? "";
    final era = widget.era ?? "";
    final timeRange = widget.timeRange ?? "";
    final hasImage = (widget.imageUrl ?? "").isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
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
        child: Container(
          color: const Color(0xFF0F1E3D),
          child: Stack(
            children: [
              // Арын дэвсгэр
              if (hasImage) ...[
                Positioned.fill(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.imageUrl!,
                    errorWidget: (_, __, ___) => _buildHeritageWatermark(),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.4, 1.0],
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.black.withOpacity(0.65),
                          Colors.black.withOpacity(0.92),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else
                Positioned.fill(
                  child: _buildHeritageWatermark(),
                ),

              // Агуулга
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (era.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A).withOpacity(0.92),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFBBF24).withOpacity(0.6),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              era.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Fregat",
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        if (era.isNotEmpty && timeRange.isNotEmpty)
                          const SizedBox(width: 8),
                        if (timeRange.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFBBF24).withOpacity(0.3),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  size: 12,
                                  color: Color(0xFFFBBF24),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  timeRange,
                                  style: const TextStyle(
                                    color: Color(0xFFFDE68A),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Fregat",
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (title.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Fregat",
                          height: 1.3,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeritageWatermark() {
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
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                'assets/images/suld.png',
                width: 170,
                height: 170,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
