import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/models/termTaxonomy.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';

class AdditionDetailPage extends StatefulWidget {
  final TermOnlyModel term;

  AdditionDetailPage({required this.term});

  _AdditionDetailPageState createState() => _AdditionDetailPageState();
}

class _AdditionDetailPageState extends State<AdditionDetailPage> {
  TermTaxonomyModel? publishedTerms;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    BackendService.getTermTaxonomyById(widget.term.id).then((terms) {
      if (mounted) {
        setState(() {
          publishedTerms = terms;
          isLoad = true;
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  String _cleanArticleNumber(TermTaxonomyModel item) {
    // Check name first for accuracy (e.g. 2019.57.3 vs typo slug 2019.57.2)
    final raw = (item.name != null && item.name!.isNotEmpty)
        ? item.name!
        : (item.slug ?? '').trim();
    return raw.replaceAll(RegExp(r'^(2019|2000)\.'), '').trim();
  }

  static List<int> _extractNumberParts(TermTaxonomyModel item) {
    final raw = (item.name != null && item.name!.isNotEmpty)
        ? item.name!
        : (item.slug ?? '').trim();
    final clean = raw.replaceAll(RegExp(r'^(2019|2000)\.'), '').trim();
    final matches = RegExp(r'\d+').allMatches(clean);
    return matches.map((m) => int.tryParse(m.group(0) ?? '') ?? 0).toList();
  }

  static int _compareItems(TermTaxonomyModel a, TermTaxonomyModel b) {
    final aNums = _extractNumberParts(a);
    final bNums = _extractNumberParts(b);
    final minLen = aNums.length < bNums.length ? aNums.length : bNums.length;
    for (int i = 0; i < minLen; i++) {
      if (aNums[i] != bNums[i]) {
        return aNums[i].compareTo(bNums[i]);
      }
    }
    if (aNums.length != bNums.length) {
      return aNums.length.compareTo(bNums.length);
    }
    final aStr = a.name ?? a.slug ?? '';
    final bStr = b.name ?? b.slug ?? '';
    return aStr.compareTo(bStr);
  }

  void _copyText(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              '$label хуулагдлаа',
              style: const TextStyle(fontFamily: 'Fregat'),
            ),
          ],
        ),
        backgroundColor: ColorLaw.blue,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildTaxonomyContent(TermTaxonomyModel model, String articleNumber) {
    if (model.taxonomies != null && model.taxonomies!.isNotEmpty) {
      return _buildTaxonomyText(model.taxonomies![0], articleNumber);
    }

    // Dynamic fallback fetch if taxonomy wasn't in the initial tree
    return FutureBuilder<List<TaxonomyModel>>(
      future: BackendService.getTaxonomyById(model.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorLaw.blue,
                ),
              ),
            ),
          );
        }
        final list = snapshot.data ?? [];
        if (list.isNotEmpty) {
          return _buildTaxonomyText(list[0], articleNumber);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildTaxonomyText(TaxonomyModel tax, String articleNumber) {
    final title = (tax.taxonomy ?? '').trim();
    final description = (tax.description ?? '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'Fregat',
              color: ColorLaw.blue,
            ),
          ),
          const SizedBox(height: 6),
        ],
        if (description.isNotEmpty)
          InkWell(
            onLongPress: () {
              _copyText(context, "$articleNumber $description", "Зүйл, заалт");
            },
            borderRadius: BorderRadius.circular(6),
            child: Text(
              description,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                fontFamily: 'Fregat',
                color: Colors.black87,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TermTaxonomyModel> termsList = (publishedTerms?.cntTerms ?? [])
        .whereType<TermTaxonomyModel>()
        .toList();
    // Sort in ascending numerical order of the constitutional articles (6.2, 19.1, 19.2, ...)
    termsList.sort(_compareItems);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ColorLaw.blue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "${widget.term.name ?? ""} оны ${widget.term.slug ?? ""}",
          style: const TextStyle(
            color: ColorLaw.blue,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "Fregat",
          ),
        ),
      ),
      body: !isLoad
          ? const Center(
              child: CircularProgressIndicator(color: ColorLaw.blue),
            )
          : termsList.isEmpty
              ? const Center(
                  child: Text(
                    "Мэдээлэл олдсонгүй",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: "Fregat",
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  itemCount: termsList.length,
                  itemBuilder: (context, index) {
                    final TermTaxonomyModel item = termsList[index];
                    final articleNumber = _cleanArticleNumber(item);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    articleNumber,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Fregat',
                                      color: ColorLaw.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: ColorLaw.blue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                    ),
                                    child: const Text(
                                      "ӨӨРЧЛӨН НАЙРУУЛСАН",
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Fregat',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  size: 18,
                                  color: ColorLaw.blue,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: "Хуулах",
                                onPressed: () {
                                  final taxDesc =
                                      (item.taxonomies != null &&
                                              item.taxonomies!.isNotEmpty)
                                          ? (item.taxonomies![0].description ??
                                              '')
                                          : '';
                                  _copyText(
                                    context,
                                    '$articleNumber\n$taxDesc',
                                    'Зүйл, заалт',
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildTaxonomyContent(item, articleNumber),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
