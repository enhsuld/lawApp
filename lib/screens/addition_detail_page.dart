import 'package:flutter/material.dart';
import 'package:law_app/items/TaxonomyItem.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/items/TermVerticalItem.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/services/BackendService.dart';

class AdditionDetailPage extends StatefulWidget {
  final TermModel term;

  AdditionDetailPage({Key key, this.term});

  _AdditionDetailPageState createState() => _AdditionDetailPageState();
}

class _AdditionDetailPageState extends State<AdditionDetailPage> {
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
            widget.term.name.toUpperCase(),
            style: TextStyle(color: Color(0xff1b4392)),
          ),
        ),
        body: Container(
          child: Text("test"),
        ),
      ),
    );
  }
}
