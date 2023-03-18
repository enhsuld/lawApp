import 'package:law_app/models/taxonomy.dart';

class TermLawModel {
  int? id;
  String? name;
  String? slug;
  List<dynamic>? cntTerms;
  List<dynamic>? cntTermTaxonomies;

  //const TermLawModel({this.id, this.name, this.slug, this.parentId});

  //TermLawModel.fromJson(Map jsonMap) : id=jsonMap['id'],name = jsonMap['name'],slug = jsonMap['slug'],parentId = jsonMap['parentId'];

  TermLawModel.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'],
        cntTerms =
            (jsonMap['cntTerms']).map((i) => TermLawModel.fromJson(i)).toList(),
        cntTermTaxonomies = (jsonMap['cntTermTaxonomies'])
            .map((i) => TaxonomyModel.fromJson(i))
            .toList();

  TermLawModel.fromJson1(Map jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.slug = jsonMap['slug'];
    this.cntTerms = (jsonMap['cntTerms'] ?? [])
        .map((i) => TermLawModel.fromJson1(i))
        .toList();
    this.cntTermTaxonomies = (jsonMap['cntTermTaxonomies'] ?? [])
        .map((i) => TaxonomyModel.fromJson(i))
        .toList();
  }

  static List<TermLawModel> fromJsonList(jsonList) {
    return jsonList
        .map<TermLawModel>((obj) => TermLawModel.fromJson1(obj))
        .toList();
  }

  map(TermLawModel model) {}
}
