import 'package:flutter/material.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const int PAGE_SIZE = 10;

  var publishedTerms = new List<TermOnlyModel>();

  @override
  void initState() {
    super.initState();
    BackendService.getTerm(0 + 1, PAGE_SIZE).then((terms) {
      setState(() {
        this.publishedTerms = terms;
        print(terms);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorLaw.blue,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Home.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 220,
                      padding: EdgeInsets.only(
                          top: 80, left: 50, right: 50, bottom: 10),
                      child: Image.asset("assets/images/logo_large.png"),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 15, bottom: 10, left: 8, right: 8),
                      child: Text(
                        'МОНГОЛ УЛСЫН ҮНДСЭН ХУУЛЬ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: "Fregat",
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/images/hee_home.png"),
                          // Image.asset("assets/images/hee_home.png"),
                          // Image.asset("assets/images/hee_home.png")
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
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
            ],
          ),
        ));
  }
}
