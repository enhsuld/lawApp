class HistoryModel {
  int? id;
  String? name;
  String? slug;
  var medias;

  HistoryModel.fromJson(Map jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.medias = jsonMap['medias'];
    this.slug = jsonMap['slug'];
  }

  static List<HistoryModel> fromJsonList({jsonList, dataKey: ""}) {
    if (dataKey != "") jsonList = jsonList[dataKey];
    return jsonList
        .map<HistoryModel>((obj) => HistoryModel.fromJson(obj))
        .toList();
  }
}
