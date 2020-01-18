import 'package:flutter/material.dart';
import 'package:law_app/items/TermVerticalItem.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/models/term_law.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:material_search/material_search.dart';

class LawDetailPage extends StatefulWidget {
  final TermOnlyModel term;

  LawDetailPage({Key key, this.term});

  _LawDetailPageState createState() => _LawDetailPageState();
}

class _LawDetailPageState extends State<LawDetailPage> {
  List<Map<String, dynamic>> _tabs = [];
  List<String> _views = [];

  static const int PAGE_SIZE = 10;
  List<TermLawModel> publishedTerms = new List();
  List<TaxonomyModel> publishedTaxonomy = new List();

  @override
  void initState() {
    super.initState();
    getLaws(keyword: "");
  }

  getLaws({keyword}) {
    BackendService.getLawSearch(keyword: keyword).then((terms) {
      setState(() {
        this.publishedTerms = terms;
      });
    });
  }

  final _names = [
    'хууль',
    'Үндсэн',
  ];

  String _name = 'No one';
  String search = "";

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
              placeholder: 'Хайх',
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
              onSubmit: (String value) {
                Navigator.of(context).pop(value);
              },
            ),
          );
        });
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      if (value != null) {
        setState(() {
          search = value as String;
        });
        getLaws(keyword: "?query=" + (value as String));
      }
      //setState(() => _name = value as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (publishedTerms.length > 0)
        ? DefaultTabController(
            length: publishedTerms.length,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: ColorLaw.blue,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                title: Text(
                  "Үндсэн хууль".toUpperCase(),
                  style: TextStyle(
                      color: ColorLaw.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
                actions: <Widget>[
                  (search != null && search.length > 0)
                      ? MaterialButton(
                          onPressed: () {
                            setState(() {
                              search = "";
                            });
                            getLaws(keyword: "");
                          },
                          minWidth: 20,
                          child: Icon(
                            Icons.clear,
                            color: ColorLaw.blue,
                          ),
                        )
                      : MaterialButton(
                          onPressed: () {
                            _showMaterialSearch(context);
                          },
                          minWidth: 20,
                          child: Icon(
                            Icons.search,
                            color: ColorLaw.blue,
                          ),
                        )
                ],
                bottom: TabBar(
                  isScrollable: true,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700),
                  unselectedLabelStyle: TextStyle(),
                  labelColor: ColorLaw.blue,
                  //indicatorColor: ColorLaw.blue,
                  indicatorPadding: EdgeInsets.all(10),
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 5.0, color: ColorLaw.blue),
                      insets: EdgeInsets.symmetric(horizontal: 16.0)),
                  // BoxDecoration(
                  //     color: ColorLaw.blue,
                  //     borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(10),
                  //         topRight: Radius.circular(10))),
                  indicatorSize: TabBarIndicatorSize.label,
                  //indicatorSize: TabBarIndicatorSize.label,
                  tabs:
                      publishedTerms.map((tab) => Tab(text: tab.name)).toList(),
                ),
              ),
              body: TabBarView(
                children: publishedTerms
                    .map(
                      (view) => new Container(
                          child: CustomScrollView(slivers: <Widget>[
                        SliverList(
                          delegate: new SliverChildListDelegate([
                            Container(
                              height: 120,
                              padding: EdgeInsets.only(left: 50, right: 50),
                              decoration: BoxDecoration(
                                  //shape: BoxShape.circle,
                                  //color: Colors.white,
                                  //border: Border.all(                                      width: 1.5, color: ColorLaw.blue),
                                  //borderRadius:                                      BorderRadius.all(Radius.circular(5)),
                                  image: DecorationImage(
                                fit: BoxFit.cover,
                                image: new AssetImage("assets/images/tug.jpg"),
                              )),
                              child: Center(
                                child: Text(
                                  view.slug.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
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
                              return new TermVerticalItem(item, index, search);
                            },
                            childCount: view.cntTerms.length,
                          ),
                        ),
                      ])),
                    )
                    .toList(),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
