class TaxonomyModel {
  final int id;
  final String taxonomy;
  final String description;
  final int parentId;
  final int termId;
 // final List<dynamic> cntTerms;

  const TaxonomyModel({this.id, this.taxonomy, this.description, this.parentId, this.termId});

  //const TermModel({this.id, this.name, this.slug, this.parentId, this.cntTerms});

  TaxonomyModel.fromJson(Map jsonMap) : id=jsonMap['id'],taxonomy = jsonMap['taxonomy'],description = jsonMap['description'],parentId = jsonMap['parentId'],termId = jsonMap['termId'];

  //TermModel.fromJson(Map jsonMap) : id=jsonMap['id'],name = jsonMap['name'],slug = jsonMap['slug'],parentId = jsonMap['parentId'],cntTerms=(jsonMap['cntTerms']).map((i) => TermModel.fromJson(i)).toList();

  static List<TaxonomyModel> fromJsonList(jsonList) {
    return  jsonList.map<TaxonomyModel>((obj) => TaxonomyModel.fromJson(obj)).toList();
  }
}
