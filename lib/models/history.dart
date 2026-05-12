class HistoryModel {
  int? id;
  String? name;
  String? slug;
  var medias;

  HistoryModel.fromJson(Map jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name']?.toString().trim();
    this.medias = jsonMap['medias'];
    this.slug = jsonMap['slug']?.toString().trim();
  }

  static List<HistoryModel> fromJsonList({jsonList, String dataKey = ""}) {
    if (dataKey != "") jsonList = jsonList[dataKey];
    return jsonList
        .map<HistoryModel>((obj) => HistoryModel.fromJson(obj))
        .toList();
  }
}
