import 'package:flutter/material.dart';
import 'package:law_app/items/TaxonomyItem.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/items/TermVerticalItem.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/screens/search_page.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/fade_route.dart';
import 'package:material_search/material_search.dart';

class LawDetailPage extends StatefulWidget {
  final TermModel term;

  LawDetailPage({Key key, this.term});

  _LawDetailPageState createState() => _LawDetailPageState();
}

class _LawDetailPageState extends State<LawDetailPage> {
  List<Map<String, dynamic>> _tabs = [];
  List<String> _views = [];

  static const int PAGE_SIZE = 10;
  // List<TermModel> publishedTerms = [];
  List<TaxonomyModel> publishedTaxonomy = [];

  @override
  void initState() {
    super.initState();

/*    BackendService.getContentById(widget.term.id).then((terms) {
      setState(() {
        this.publishedTerms = terms;
      });
    });*/
  }

  final _names = [
    'хууль',
    'Үндсэн',
  ];

  String _name = 'No one';

  final _formKey = new GlobalKey<FormState>();

  _buildMaterialSearchPage(BuildContext context) {
    return new MaterialPageRoute<String>(
        settings: new RouteSettings(
          name: 'material_search',
          isInitialRoute: false,
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<String>(
              placeholder: 'Search',
              results: _names
                  .map((String v) => new MaterialSearchResult<String>(
                        //icon: Icons.person,
                        value: v,
                        text: "$v",
                      ))
                  .toList(),
              filter: (dynamic value, String criteria) {
                return value.toLowerCase().trim().contains(
                    new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) => Navigator.of(context).pop(value),
              onSubmit: (String value) => Navigator.of(context).pop(value),
            ),
          );
        });
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      setState(() => _name = value as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.term.cntTerms.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff1b4392),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            widget.term.name.toUpperCase(),
            style: TextStyle(color: Color(0xff1b4392), fontSize: 14),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                _showMaterialSearch(context);
              },
              minWidth: 20,
              child: Icon(
                Icons.search,
                color: Color(0xff1b4392),
              ),
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Color(0xff1b4392),
            indicatorColor: Color(0xff1b4392),
            tabs:
                widget.term.cntTerms.map((tab) => Tab(text: tab.name)).toList(),
          ),
        ),
        body: TabBarView(
          children: widget.term.cntTerms
              .map(
                (view) => Container(
                    child: CustomScrollView(slivers: <Widget>[
                  SliverList(
                    delegate: new SliverChildListDelegate([
                      Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: Center(
                          child: Text(
                            view.slug.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff1b4392)),
                          ),
                        ),
                      ),
                      // Divider(
                      //   color: Colors.grey[300],
                      //   thickness: 1,
                      // ),
                    ]),
                  ),
                  SliverList(
                    delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final item = view.cntTerms[index];
                        return TermVerticalItem(item, index);
                      },
                      childCount: view.cntTerms.length,
                    ),
                  ),
                ])),
              )
              .toList(),
        ),
      ),
    );
  }
}
