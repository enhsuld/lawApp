import 'package:law_app/models/taxonomy.dart';

class TermTaxonomyModel {
  final int id;
  final String name;
  final String slug;
  final List<dynamic> medias;
  final dynamic meta;
  final List<dynamic> cntTerms;
  final List<dynamic> taxonomies;

  const TermTaxonomyModel(
      {this.id,
      this.name,
      this.slug,
      this.cntTerms,
      this.medias,
      this.meta,
      this.taxonomies});

  TermTaxonomyModel.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'],
        medias = jsonMap['medias'] ?? [],
        meta = jsonMap['meta'] ?? [],
        cntTerms = (jsonMap['child'] ?? [])
            .map((i) => TermTaxonomyModel.fromJson(i))
            .toList(),
        taxonomies = (jsonMap['taxonomy'] ?? [])
            .map((i) => TaxonomyModel.fromJson(i))
            .toList();

  static List<TermTaxonomyModel> fromJsonList({jsonList, dataKey: ""}) {
    if (dataKey != "") jsonList = jsonList[dataKey];
    return jsonList
        .map<TermTaxonomyModel>((obj) => TermTaxonomyModel.fromJson(obj))
        .toList();
  }

  map(TermTaxonomyModel model) {}
}
