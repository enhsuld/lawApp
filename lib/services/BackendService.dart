import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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
  static const String url = "https://pimis.mof.gov.mn/conslaw/api";
  static const String link = "https://pimis.mof.gov.mn/conslaw";
  static const String apiURL = "$url/cnt";
  static const Duration timeoutDuration = Duration(seconds: 8);

  static Future<String?> _loadAsset(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (_) {
      return null;
    }
  }

  static Future<List<TermModel>> getContent(dynamic offset, dynamic limit,
      {String publish = '', String filters = ''}) async {
    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/term/all'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200) {
        return TermModel.fromJsonList(json.decode(response.body));
      }
    } catch (_) {}
    return [];
  }

  static Future<List<TermOnlyModel>> getTerm(dynamic offset, dynamic limit,
      {String publish = '', String filters = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'cached_terms_all';

    // 1. Check local cache or bundled asset for immediate offline availability
    String? localJson = prefs.getString(key);
    if (localJson == null || localJson.isEmpty) {
      localJson = await _loadAsset('assets/data/terms_all.json');
      if (localJson != null && localJson.isNotEmpty) {
        await prefs.setString(key, localJson);
      }
    }

    // 2. Try fetching fresh data from network
    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/all'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        await prefs.setString(key, response.body);
        final decoded = json.decode(response.body);
        return TermOnlyModel.fromJsonList(jsonList: decoded);
      }
    } catch (_) {
      // Offline or network error - gracefully fall back
    }

    // 3. Fallback to cached or bundled asset
    if (localJson != null && localJson.isNotEmpty) {
      final decoded = json.decode(localJson);
      return TermOnlyModel.fromJsonList(jsonList: decoded);
    }
    return [];
  }

  static Future<List<TermOnlyModel>> getTermOffline(dynamic offset, dynamic limit,
      {String publish = '', String filters = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'cached_terms_all';
    String? localJson = prefs.getString(key) ??
        await _loadAsset('assets/data/terms_all.json');
    if (localJson != null && localJson.isNotEmpty) {
      return TermOnlyModel.fromJsonList(jsonList: json.decode(localJson));
    }
    return [];
  }

  static Future<List<TermModel>> getContentById(dynamic id) async {
    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/list/$id'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200) {
        return TermModel.fromJsonList(json.decode(response.body));
      }
    } catch (_) {}
    return [];
  }

  static Future<TermChildModel?> getTermById(dynamic id) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_term_child_$id';

    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/item/$id'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        await prefs.setString(cacheKey, response.body);
        return TermChildModel.fromJson(json.decode(response.body));
      }
    } catch (_) {}

    final cached = prefs.getString(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return TermChildModel.fromJson(json.decode(cached));
    }
    return null;
  }

  static Future<ContentModel?> getContentId(dynamic id) async {
    try {
      final response = await http
          .get(Uri.parse('$apiURL/content/item/$id'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return ContentModel.fromJson(json.decode(response.body));
      }
    } catch (_) {}
    return null;
  }

  static Future<TermTaxonomyModel?> getTermTaxonomyById(dynamic id) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_term_taxonomy_$id';

    // 1. Check bundled asset fallback first if available
    String? localJson = prefs.getString(cacheKey);
    if (localJson == null || localJson.isEmpty) {
      localJson = await _loadAsset('assets/data/amendments_$id.json');
      if (localJson != null && localJson.isNotEmpty) {
        await prefs.setString(cacheKey, localJson);
      }
    }

    // 2. Try fetching fresh data from network if online
    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/item/$id'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decoded = json.decode(response.body);
        final children = decoded['child'] as List<dynamic>? ?? [];

        // Ensure each child has its taxonomy populated
        for (var child in children) {
          if (child is Map) {
            final childId = child['id'];
            final hasTax = child['taxonomy'] != null &&
                (child['taxonomy'] as List).isNotEmpty;
            if (!hasTax && childId != null) {
              try {
                final taxRes = await http
                    .get(Uri.parse('$apiURL/term/taxonomy/list/$childId'))
                    .timeout(const Duration(seconds: 4));
                if (taxRes.statusCode == 200) {
                  child['taxonomy'] = json.decode(taxRes.body);
                }
              } catch (_) {}
            }
          }
        }

        final encoded = json.encode(decoded);
        await prefs.setString(cacheKey, encoded);
        return TermTaxonomyModel.fromJson(decoded);
      }
    } catch (_) {}

    // 3. Fallback to cached or bundled asset
    if (localJson != null && localJson.isNotEmpty) {
      return TermTaxonomyModel.fromJson(json.decode(localJson));
    }
    return null;
  }

  static Future<List<TermLawModel>> getLawSearch({String keyword = ""}) async {
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'cached_constitution';

    // 1. Initial complete constitution load (when keyword is empty)
    if (keyword.isEmpty) {
      String? localJson = prefs.getString(cacheKey);
      if (localJson == null || localJson.isEmpty) {
        localJson = await _loadAsset('assets/data/constitution.json');
        if (localJson != null && localJson.isNotEmpty) {
          await prefs.setString(cacheKey, localJson);
        }
      }

      try {
        final response = await http
            .get(Uri.parse('$apiURL/term/search'))
            .timeout(timeoutDuration);
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          await prefs.setString(cacheKey, response.body);
          return TermLawModel.fromJsonList(json.decode(response.body));
        }
      } catch (_) {
        // Fallback to cache/asset on offline or network error
      }

      if (localJson != null && localJson.isNotEmpty) {
        return TermLawModel.fromJsonList(json.decode(localJson));
      }
      return [];
    }

    // 2. Search with query string
    try {
      final encodedQuery = Uri.encodeFull('$apiURL/term/search$keyword');
      final response =
          await http.get(Uri.parse(encodedQuery)).timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final serverResults =
            TermLawModel.fromJsonList(json.decode(response.body));
        if (serverResults.isNotEmpty) {
          return serverResults;
        }
      }
    } catch (_) {}

    // 3. Fallback to full local search (works offline and catches queries)
    try {
      String? localJson = prefs.getString(cacheKey);
      if (localJson == null || localJson.isEmpty) {
        localJson = await _loadAsset('assets/data/constitution.json');
      }
      if (localJson != null && localJson.isNotEmpty) {
        final allLaws = TermLawModel.fromJsonList(json.decode(localJson));
        String rawQuery = keyword
            .replaceAll("?query=", "")
            .replaceAll("?keyword=", "")
            .trim();
        try {
          rawQuery = Uri.decodeComponent(rawQuery);
        } catch (_) {}
        final cleanTerm = rawQuery.toLowerCase().trim();
        if (cleanTerm.isEmpty) return allLaws;

        final List<TermLawModel> matchedChapters = [];
        for (var chapter in allLaws) {
          final chapterName = (chapter.name ?? '').toLowerCase();
          final chapterSlug = (chapter.slug ?? '').toLowerCase();
          final bool chapterMatched =
              chapterName.contains(cleanTerm) || chapterSlug.contains(cleanTerm);

          final List<dynamic> matchingArticles = [];
          for (var article in (chapter.cntTerms ?? [])) {
            final artName = (article.name ?? '').toString().toLowerCase();
            final artSlug = (article.slug ?? '').toString().toLowerCase();
            final bool artNameMatched =
                artName.contains(cleanTerm) || artSlug.contains(cleanTerm);

            bool taxMatched = false;
            for (var tax in (article.cntTermTaxonomies ?? [])) {
              final desc = (tax.description ?? '').toString().toLowerCase();
              final taxName = (tax.taxonomy ?? '').toString().toLowerCase();
              if (desc.contains(cleanTerm) || taxName.contains(cleanTerm)) {
                taxMatched = true;
                break;
              }
            }

            if (artNameMatched || taxMatched || chapterMatched) {
              matchingArticles.add(article);
            }
          }

          if (matchingArticles.isNotEmpty) {
            chapter.cntTerms = matchingArticles;
            matchedChapters.add(chapter);
          }
        }
        return matchedChapters;
      }
    } catch (_) {}
    return [];
  }

  static Future<List<TaxonomyModel>> getTaxonomyById(dynamic id) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_taxonomy_list_$id';

    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/taxonomy/list/$id'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        await prefs.setString(cacheKey, response.body);
        return TaxonomyModel.fromJsonList(json.decode(response.body));
      }
    } catch (_) {}

    final cached = prefs.getString(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return TaxonomyModel.fromJsonList(json.decode(cached));
    }
    return [];
  }

  static Future<List<TaxonomyModel>> getHistoryList(
      dynamic id, dynamic offset, dynamic limit) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_history_${id}_$offset';

    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/taxonomy/tax/$id?page=$offset&size=$limit'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        await prefs.setString(cacheKey, response.body);
        return TaxonomyModel.fromJsonList(json.decode(response.body),
            dataKey: "content");
      }
    } catch (_) {}

    final cached = prefs.getString(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return TaxonomyModel.fromJsonList(json.decode(cached),
          dataKey: "content");
    }
    return [];
  }

  static Future<List<HistoryModel>> getHistoryGroup() async {
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'cached_history_group';

    String? localJson = prefs.getString(cacheKey);
    if (localJson == null || localJson.isEmpty) {
      localJson = await _loadAsset('assets/data/history_group.json');
      if (localJson != null && localJson.isNotEmpty) {
        await prefs.setString(cacheKey, localJson);
      }
    }

    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/item/88'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        await prefs.setString(cacheKey, response.body);
        return HistoryModel.fromJsonList(
            jsonList: json.decode(response.body), dataKey: "child");
      }
    } catch (_) {}

    if (localJson != null && localJson.isNotEmpty) {
      return HistoryModel.fromJsonList(
          jsonList: json.decode(localJson), dataKey: "child");
    }
    return [];
  }

  static Future<List<TermOnlyModel>> getOrshilList(
      dynamic id, dynamic offset, dynamic limit) async {
    try {
      final response = await http
          .get(Uri.parse('$apiURL/term/json/$id'))
          .timeout(timeoutDuration);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return TermOnlyModel.fromJsonList(
            jsonList: json.decode(response.body), dataKey: "cntTerms");
      }
    } catch (_) {}
    return [];
  }
}
