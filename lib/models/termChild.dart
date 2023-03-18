class TermChildModel {
  final int? id;
  final String? name;
  final String? slug;
  final List<dynamic>? medias;
  final dynamic meta;
  final List<dynamic>? cntTerms;

  const TermChildModel(
      {this.id, this.name, this.slug, this.cntTerms, this.medias, this.meta});

  TermChildModel.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'],
        medias = jsonMap['medias'] ?? [],
        meta = jsonMap['meta'] ?? [],
        cntTerms = (jsonMap['child'] ?? [])
            .map((i) => TermChildModel.fromJson(i))
            .toList();

  static List<TermChildModel> fromJsonList({jsonList, dataKey: ""}) {
    if (dataKey != "") jsonList = jsonList[dataKey];
    return jsonList
        .map<TermChildModel>((obj) => TermChildModel.fromJson(obj))
        .toList();
  }

  map(TermChildModel model) {}
}
