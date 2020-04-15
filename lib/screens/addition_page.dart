import 'package:flutter/material.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/screens/about_detail_page.dart';
import 'package:law_app/screens/addition_detail_page.dart';
import 'package:law_app/utils/fade_route.dart';

class AdditionPage extends StatefulWidget {
  final TermOnlyModel term;

  AdditionPage({Key key, this.term});

  _AdditionPageState createState() => _AdditionPageState();
}

class _AdditionPageState extends State<AdditionPage> {
  List<Map<String, dynamic>> _tabs = [];
  List<String> _views = [];

  static const int PAGE_SIZE = 10;
  // List<TermModel> publishedTerms = [];
  List<TermModel> publishedTerms = [];

  @override
  void initState() {
    super.initState();

    // BackendService.getContentById(widget.term.id).then((terms) {
    //   setState(() {
    //     this.publishedTerms = terms;
    //     print(terms);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          style:
              TextStyle(color: Color(0xff1b4392), fontWeight: FontWeight.w700),
        ),
      ),
      body:
          //Text(widget.term.cntTerms.length.toString()),
          Container(
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          children: List.generate(widget.term.cntTerms.length, (index) {
            TermOnlyModel childModel = widget.term.cntTerms[index];
            return childModel.slug.length == 4
                ? _itemCons(index)
                : _itemAddition(index);
          }),
        ),
      ),
    );
  }

  _itemAddition(index) {
    print("size " + widget.term.cntTerms.length.toString());
    print("index $index");
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey[300]),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: RawMaterialButton(
        onPressed: () {
          Navigator.push(
              context,
              FadeRoute(
                  builder: (context) => AdditionDetailPage(
                        term: widget.term.cntTerms[index],
                      )));
        },
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 10),
                  child: Image.asset("assets/images/logo_large.png"),
                ),
                Text(
                  widget.term.cntTerms[index].name,
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  widget.term.cntTerms[index].slug,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/images/hee_grid.png",
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }

  _itemCons(index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey[300]),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: RawMaterialButton(
        onPressed: () {
          Navigator.push(
              context,
              FadeRoute(
                  builder: (context) => AboutDetailPage(
                        term: widget.term.cntTerms[index],
                      )));
        },
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: 20, left: 50, right: 50, bottom: 10),
                  child: Image.asset("assets/images/logo_large.png"),
                ),
                Text(
                  widget.term.cntTerms[index].name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  widget.term.cntTerms[index].slug,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/images/hee_grid.png",
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
