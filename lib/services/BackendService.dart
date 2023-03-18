import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:law_app/models/content.dart';
import 'package:law_app/models/history.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/models/termChild.dart';
import 'package:law_app/models/termTaxonomy.dart';
import 'package:law_app/models/term_law.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackendService {
  static String url = "https://pimis.mof.gov.mn/conslaw/api";
  static String link = "https://pimis.mof.gov.mn/conslaw";
  static String apiURL = url + "/cnt";

  static Future<List<TermModel>> getContent(offset, limit,
      {publish: '', filters: ''}) async {
    final response = (await http.get(Uri.parse(apiURL + '/term/term/all')));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TermOnlyModel>> getTerm(offset, limit,
      {publish = '', filters = ''}) async {
    final response = (await http.get(Uri.parse(apiURL + '/term/all')));
    final prefs = await SharedPreferences.getInstance();
    final key = 'menu';
    prefs.setBool("isMenu", true);
    prefs.setString(key, response.body);
    print(json.decode(response.body));
    return TermOnlyModel.fromJsonList(jsonList: json.decode(response.body));
  }

  static Future<List<TermOnlyModel>> getTermOffline(offset, limit,
      {publish = '', filters = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'menu';
    final menus = prefs.getString(key) ?? "";
    print('read: $menus');
    // final response = (await http.get(apiURL + '/term/all'));
    return TermOnlyModel.fromJsonList(jsonList: json.decode(menus));
  }

  static Future<List<TermModel>> getContentById(id) async {
    final response =
        (await http.get(Uri.parse(apiURL + '/term/list/' + id.toString())));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermModel.fromJsonList(json.decode(response.body));
  }

  static Future<TermChildModel> getTermById(id) async {
    final response = (await http.get(Uri.parse(apiURL + '/term/item/$id')));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermChildModel.fromJson(json.decode(response.body));
  }

  static Future<ContentModel> getContentId(id) async {
    final response = (await http.get(Uri.parse(apiURL + '/content/item/$id')));
    print(response.statusCode);
    print(json.decode(response.body));
    return ContentModel.fromJson(json.decode(response.body));
  }

  static Future<TermTaxonomyModel> getTermTaxonomyById(id) async {
    final response = (await http.get(Uri.parse(apiURL + '/term/item/$id')));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermTaxonomyModel.fromJson(json.decode(response.body));
  }

  static Future<List<TermLawModel>> getLawSearch({keyword: ""}) async {
    final response =
        (await http.get(Uri.parse(apiURL + '/term/search$keyword')));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermLawModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TaxonomyModel>> getTaxonomyById(id) async {
    final response = (await http
        .get(Uri.parse(apiURL + '/term/taxonomy/list/' + id.toString())));
    print(response.statusCode);
    print(json.decode(response.body));
    return TaxonomyModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TaxonomyModel>> getHistoryList(id, offset, limit) async {
    final response = (await http.get(
        Uri.parse(apiURL + '/term/taxonomy/tax/$id?page=$offset&size=$limit')));
    print(response.statusCode);
    return TaxonomyModel.fromJsonList(json.decode(response.body),
        dataKey: "content");
  }

  static Future<List<HistoryModel>> getHistoryGroup() async {
    final response = (await http.get(Uri.parse(apiURL + '/term/item/88')));
    print(response.statusCode);
    return HistoryModel.fromJsonList(
        jsonList: json.decode(response.body), dataKey: "child");
  }

  static Future<List<TermOnlyModel>> getOrshilList(id, offset, limit) async {
    final response = (await http.get(Uri.parse(apiURL + '/term/json/$id')));
    print(response.body);
    return TermOnlyModel.fromJsonList(
        jsonList: json.decode(response.body), dataKey: "cntTerms");
  }
}
