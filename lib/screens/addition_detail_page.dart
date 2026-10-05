import 'package:flutter/material.dart';
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
    final raw = (item.slug ?? item.name ?? '').trim();
    return raw.replaceAll(RegExp(r'^(2019|2000)\.'), '');
  }

  Widget _buildTaxonomyContent(TermTaxonomyModel model) {
    if (model.taxonomies != null && model.taxonomies!.isNotEmpty) {
      return _buildTaxonomyText(model.taxonomies![0]);
    }

    // Dynamic fallback fetch if taxonomy wasn't in the initial tree
    return FutureBuilder<List<TaxonomyModel>>(
      future: BackendService.getTaxonomyById(model.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
          return _buildTaxonomyText(list[0]);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildTaxonomyText(TaxonomyModel tax) {
    final title = (tax.taxonomy ?? '').trim();
    final description = (tax.description ?? '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ColorLaw.blue,
            ),
          ),
          const SizedBox(height: 6),
        ],
        if (description.isNotEmpty)
          Text(
            description,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final termsList = publishedTerms?.cntTerms ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: ColorLaw.blue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "${widget.term.name ?? ""} оны ${widget.term.slug ?? ""}",
          style: TextStyle(
            color: ColorLaw.blue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: !isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : termsList.isEmpty
              ? const Center(
                  child: Text(
                    "Мэдээлэл олдсонгүй",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: termsList.length,
                  itemBuilder: (context, index) {
                    final TermTaxonomyModel item = termsList[index];
                    final articleNumber = _cleanArticleNumber(item);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                articleNumber,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: ColorLaw.blue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: ColorLaw.blue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                ),
                                child: Text(
                                  "ӨӨРЧЛӨН НАЙРУУЛСАН",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildTaxonomyContent(item),
                          const SizedBox(height: 12),
                          Divider(color: Colors.grey[300], thickness: 1),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
