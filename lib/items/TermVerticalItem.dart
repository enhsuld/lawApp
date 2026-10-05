import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term_law.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/custom_textspan.dart';
import 'package:share_plus/share_plus.dart';

class TermVerticalItem extends StatefulWidget {
  final TermLawModel model;
  final int index;
  final String search;
  final bool initiallyExpanded;
  final double fontSize;

  const TermVerticalItem(
    this.model,
    this.index,
    this.search, {
    Key? key,
    this.initiallyExpanded = false,
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  _TermVerticalItemState createState() => _TermVerticalItemState();
}

class _TermVerticalItemState extends State<TermVerticalItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded || widget.search.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant TermVerticalItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.search.isNotEmpty && widget.search != oldWidget.search) {
      _isExpanded = true;
    } else if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

  String _getSubtitlePreview() {
    final taxonomies = widget.model.cntTermTaxonomies;
    if (taxonomies == null || taxonomies.isEmpty) return '';
    final first = taxonomies.first;
    if (first is! TaxonomyModel) return '';
    final desc = (first.description ?? '').replaceAll('\n', ' ').trim();
    final tax = (first.taxonomy ?? '').trim();
    if (tax.isNotEmpty && !desc.startsWith(tax)) {
      return '$tax. $desc';
    }
    return desc;
  }

  void _copyArticle(BuildContext context) {
    final buffer = StringBuffer();
    final title = widget.model.slug ?? widget.model.name ?? '';
    if (title.isNotEmpty) {
      buffer.writeln(title);
    }
    final taxonomies = widget.model.cntTermTaxonomies ?? [];
    for (var tax in taxonomies) {
      if (tax is TaxonomyModel) {
        final taxNum = tax.taxonomy ?? '';
        final desc = tax.description ?? '';
        if (taxNum.isNotEmpty) {
          buffer.writeln('$taxNum. $desc');
        } else {
          buffer.writeln(desc);
        }
      }
    }
    Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Амжилттай хуулагдлаа',
              style: TextStyle(fontFamily: 'Fregat'),
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

  void _shareArticle() {
    final buffer = StringBuffer();
    final title = widget.model.slug ?? widget.model.name ?? '';
    if (title.isNotEmpty) {
      buffer.writeln('Монгол Улсын Үндсэн хууль');
      buffer.writeln(title);
      buffer.writeln('');
    }
    final taxonomies = widget.model.cntTermTaxonomies ?? [];
    for (var tax in taxonomies) {
      if (tax is TaxonomyModel) {
        final taxNum = tax.taxonomy ?? '';
        final desc = tax.description ?? '';
        if (taxNum.isNotEmpty) {
          buffer.writeln('$taxNum. $desc');
        } else {
          buffer.writeln(desc);
        }
      }
    }
    final box = context.findRenderObject() as RenderBox?;
    final size = MediaQuery.of(context).size;
    final Rect sharePositionOrigin =
        (box != null && box.hasSize && !box.size.isEmpty)
            ? box.localToGlobal(Offset.zero) & box.size
            : Rect.fromLTWH(0, 0, size.width, size.height / 2);

    Share.share(
      buffer.toString().trim(),
      subject: title.isNotEmpty ? title : 'Монгол Улсын Үндсэн хууль',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  void _copyClause(BuildContext context, String clauseText) {
    Clipboard.setData(ClipboardData(text: clauseText.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Заалт хуулагдлаа', style: TextStyle(fontFamily: 'Fregat')),
          ],
        ),
        backgroundColor: ColorLaw.blue,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitleText = _getSubtitlePreview();
    final taxonomies = (widget.model.cntTermTaxonomies ?? [])
        .whereType<TaxonomyModel>()
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _isExpanded
              ? ColorLaw.blue.withOpacity(0.35)
              : const Color(0xFFE5E7EB),
          width: _isExpanded ? 1.2 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: ColorLaw.blue,
                ),
          ),
          child: ExpansionTile(
          key: PageStorageKey<String>(
              'term_${widget.model.id}_${widget.initiallyExpanded}_${widget.search}'),
          initiallyExpanded:
              widget.initiallyExpanded || widget.search.isNotEmpty,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: ColorLaw.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "§ ${widget.index + 1}",
              style: const TextStyle(
                color: ColorLaw.blue,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                fontFamily: "Fregat",
              ),
            ),
          ),
          title: Text(
            (widget.model.slug ?? widget.model.name ?? "").toUpperCase(),
            style: TextStyle(
              color: ColorLaw.blue,
              fontSize: (widget.fontSize + 1).clamp(15.0, 22.0),
              fontWeight: FontWeight.w600,
              fontFamily: "Fregat",
            ),
          ),
          subtitle: !_isExpanded && subtitleText.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    subtitleText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: (widget.fontSize - 3).clamp(12.0, 15.0),
                      color: Colors.grey.shade600,
                      fontFamily: "Fregat",
                    ),
                  ),
                )
              : null,
          children: [
            ...taxonomies.map((data) {
              final taxLabel = (data.taxonomy != null && data.taxonomy!.isNotEmpty)
                  ? ((data.taxonomy!.length > 3)
                      ? data.taxonomy!.substring(0, 1)
                      : data.taxonomy! + ".")
                  : "";
              final desc = data.description ?? '';
              return InkWell(
                onLongPress: () {
                  final textToCopy = taxLabel.isNotEmpty
                      ? "$taxLabel $desc"
                      : desc;
                  _copyClause(context, textToCopy);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (taxLabel.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 2, right: 8),
                          child: Text(
                            taxLabel,
                            style: TextStyle(
                              fontSize: widget.fontSize,
                              color: ColorLaw.blue,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Fregat",
                            ),
                          ),
                        ),
                      Expanded(
                        child: RichText(
                          text: searchMatch(
                            desc,
                            widget.search,
                            fontSize: widget.fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            // Article action buttons: Copy & Share
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 10, top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _copyArticle(context),
                    icon: const Icon(Icons.copy_rounded,
                        size: 15, color: ColorLaw.blue),
                    label: const Text(
                      "Хуулах",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: ColorLaw.blue,
                        fontFamily: "Fregat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      backgroundColor: ColorLaw.blue.withOpacity(0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _shareArticle,
                    icon: const Icon(Icons.share_rounded,
                        size: 15, color: ColorLaw.blue),
                    label: const Text(
                      "Хуваалцах",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: ColorLaw.blue,
                        fontFamily: "Fregat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      backgroundColor: ColorLaw.blue.withOpacity(0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
