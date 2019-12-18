class TermOnlyModel {
  final int id;
  final String name;
  final String slug;

  const TermOnlyModel({this.id, this.name, this.slug});

  TermOnlyModel.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'];

  static List<TermOnlyModel> fromJsonList({jsonList, dataKey: ""}) {
    if (dataKey != "") jsonList = jsonList[dataKey];
    return jsonList
        .map<TermOnlyModel>((obj) => TermOnlyModel.fromJson(obj))
        .toList();
  }

  map(TermOnlyModel model) {}
}
