import 'package:flutter/material.dart';
import 'package:law_app/items/TaxonomyItem.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/items/TermVerticalItem.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/services/BackendService.dart';

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
            widget.term.name,
            style: TextStyle(color: Color(0xff1b4392)),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Color(0xff1b4392),
            indicatorColor: Color(0xff1b4392),
           /* indicator: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.orangeAccent]),
                borderRadius: BorderRadius.circular(50),
                color: Colors.redAccent),*/
         /*   indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.redAccent),*/
           /* indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0),
                insets: EdgeInsets.symmetric(horizontal:16.0)
            ),*/
            tabs: widget.term.cntTerms
                .map((tab) => Tab(text: tab.name))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: widget.term.cntTerms.map((view) =>
              Column(
                children: <Widget>[
                  Container(
                    height: 120,
                    padding: EdgeInsets.only(left: 50,right: 50),
                    child: Center(
                      child: Text(view.slug.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18,color: Color(0xff1b4392)),),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                          color: Colors.grey
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top:20),
                      height: MediaQuery.of(context).size.height*0.65,
                      child: CustomScrollView(slivers: <Widget>[
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
                ],
              ),
          ).toList(),
        ),
      ),
    );
  }
}
