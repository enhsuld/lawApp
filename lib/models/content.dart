class ContentModel {
  int id;
  String title;
  String slug;

  ContentModel.fromJson(Map jsonMap) {
    this.id = jsonMap['id'];
    this.title = jsonMap['title'];
    this.slug = jsonMap['slug'];
  }

  static List<ContentModel> fromJsonList({jsonList, dataKey: ""}) {
    if (dataKey != "") jsonList = jsonList[dataKey];
    return jsonList
        .map<ContentModel>((obj) => ContentModel.fromJson(obj))
        .toList();
  }
}
