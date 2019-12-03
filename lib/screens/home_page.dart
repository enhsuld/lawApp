import 'package:flutter/material.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/services/BackendService.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int PAGE_SIZE = 10;

  var publishedTerms = new List<TermModel>();

  @override
  void initState() {
    super.initState();
    BackendService.getContent(0 + 1, PAGE_SIZE).then((terms) {
      setState(() {
        this.publishedTerms = terms;
        print(terms);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top:50,left: 15.0, right: 15.0),
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(8.0),
                child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey,size: 30.0),
                        suffixIcon: IconButton(icon: new Icon(Icons.format_line_spacing, color: Color(0xFF676E79)),  onPressed:(){},),
                        contentPadding:
                        EdgeInsets.only(left: 15.0, top: 15.0),
                        hintText: 'Хайлт хийх',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Quicksand'))),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:40,left: 50,right: 50,bottom: 10),
              child: Text(
                'МОНГОЛ УЛСЫН ҮНДСЭН ХУУЛЬ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21.0,
                  color: Color(0xFF222455),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 460,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: publishedTerms.length,
                itemBuilder: (ctx, i) {
                  final item = publishedTerms[i];
                  return TermItem(item, i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
