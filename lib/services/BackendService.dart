import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:law_app/models/history.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/models/term_law.dart';

class BackendService {
  //static String apiURL = "http://192.168.1.116:80/api/v1";
  // static String url = "http://192.168.1.111:8080/api";
  static String url = "http://audit.tyder.mn/api";
  static String link = "http://audit.tyder.mn/";
  static String apiURL = url + "/cnt";

  static Future<List<TermModel>> getContent(offset, limit,
      {publish: '', filters: ''}) async {
    final response = (await http.get(apiURL + '/term/term/all'));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TermOnlyModel>> getTerm(offset, limit,
      {publish: '', filters: ''}) async {
    final response = (await http.get(apiURL + '/term/all'));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermOnlyModel.fromJsonList(jsonList: json.decode(response.body));
  }

  static Future<List<TermModel>> getContentById(id) async {
    final response = (await http.get(apiURL + '/term/list/' + id.toString()));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TermLawModel>> getLawSearch({keyword: ""}) async {
    final response = (await http.get(apiURL + '/term/search$keyword'));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermLawModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TaxonomyModel>> getTaxonomyById(id) async {
    final response =
        (await http.get(apiURL + '/term/taxonomy/list/' + id.toString()));
    print(response.statusCode);
    print(json.decode(response.body));
    return TaxonomyModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TaxonomyModel>> getHistoryList(id, offset, limit) async {
    final response = (await http
        .get(apiURL + '/term/taxonomy/tax/$id?page=$offset&size=$limit'));
    print(response.statusCode);
    return TaxonomyModel.fromJsonList(json.decode(response.body),
        dataKey: "content");
  }

  static Future<List<HistoryModel>> getHistoryGroup() async {
    final response = (await http.get(apiURL + '/term/item/88'));
    print(response.statusCode);
    return HistoryModel.fromJsonList(
        jsonList: json.decode(response.body), dataKey: "child");
  }

  static Future<List<TermOnlyModel>> getOrshilList(id, offset, limit) async {
    final response = (await http.get(apiURL + '/term/json/$id'));
    print(response.body);
    return TermOnlyModel.fromJsonList(
        jsonList: json.decode(response.body), dataKey: "cntTerms");
  }
}
