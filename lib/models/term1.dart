class TermOnlyModel {
  final int id;
  final String name;
  final String slug;
  final List<dynamic> cntTerms;

  const TermOnlyModel({this.id, this.name, this.slug, this.cntTerms});

  TermOnlyModel.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'],
        cntTerms = (jsonMap['child'] ?? [])
            .map((i) => TermOnlyModel.fromJson(i))
            .toList();

  static List<TermOnlyModel> fromJsonList({jsonList, dataKey: ""}) {
    if (dataKey != "") jsonList = jsonList[dataKey];
    return jsonList
        .map<TermOnlyModel>((obj) => TermOnlyModel.fromJson(obj))
        .toList();
  }

  map(TermOnlyModel model) {}
}
