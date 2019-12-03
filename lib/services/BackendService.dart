import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term.dart';

class BackendService {
  //static String apiURL = "http://192.168.1.116:80/api/v1";
 // static String url = "http://192.168.1.111:8080/api";
  static String url = "http://goldwatch.ml/api";
  static String apiURL = url + "/cnt";

  static Future<List<TermModel>> getContent(offset, limit,
      {publish: '', filters: ''}) async {

    final response = (await http.get(
        apiURL + '/term/term/all'));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TermModel>> getContentById(id) async {
    final response = (await http.get(apiURL + '/term/list/'+id.toString()));
    print(response.statusCode);
    print(json.decode(response.body));
    return TermModel.fromJsonList(json.decode(response.body));
  }

  static Future<List<TaxonomyModel>> getTaxonomyById(id) async {
    final response = (await http.get(apiURL + '/term/taxonomy/list/'+id.toString()));
    print(response.statusCode);
    print(json.decode(response.body));
    return TaxonomyModel.fromJsonList(json.decode(response.body));
  }
}
