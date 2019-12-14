import 'package:law_app/models/taxonomy.dart';

class TermOnlyModel {
  final int id;
  final String name;
  final String slug;

  //const TermModel({this.id, this.name, this.slug, this.parentId});

  const TermOnlyModel({this.id, this.name, this.slug});

  //TermOnlyModel.fromJson(Map jsonMap) : id=jsonMap['id'],name = jsonMap['name'],slug = jsonMap['slug'],parentId = jsonMap['parentId'];

  TermOnlyModel.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'];

  static List<TermOnlyModel> fromJsonList(jsonList) {
    return jsonList
        .map<TermOnlyModel>((obj) => TermOnlyModel.fromJson(obj))
        .toList();
  }

  map(TermOnlyModel model) {}
}
