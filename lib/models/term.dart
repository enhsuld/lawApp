import 'package:law_app/models/taxonomy.dart';

class TermModel {
  final int id;
  final String name;
  final String slug;
  final int parentId;
  final List<dynamic> cntTerms;
  final List<dynamic> cntTermTaxonomies;

  //const TermModel({this.id, this.name, this.slug, this.parentId});

  const TermModel({this.id, this.name, this.slug, this.parentId, this.cntTerms, this.cntTermTaxonomies});

  //TermModel.fromJson(Map jsonMap) : id=jsonMap['id'],name = jsonMap['name'],slug = jsonMap['slug'],parentId = jsonMap['parentId'];

  TermModel.fromJson(Map jsonMap) : id=jsonMap['id'],name = jsonMap['name'],slug = jsonMap['slug'],parentId = jsonMap['parentId'],cntTerms=(jsonMap['cntTerms']).map((i) => TermModel.fromJson(i)).toList(),cntTermTaxonomies=(jsonMap['cntTermTaxonomies']).map((i) => TaxonomyModel.fromJson(i)).toList();

  static List<TermModel> fromJsonList(jsonList) {
    return  jsonList.map<TermModel>((obj) => TermModel.fromJson(obj)).toList();
  }

  map(TermModel model) {}
}
