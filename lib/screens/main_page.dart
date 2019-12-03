import 'package:flutter/material.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/services/BackendService.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
                    padding: EdgeInsets.only(top:80,left: 50,right: 50,bottom: 10),
                    child: Image.asset("assets/images/logo@2x.png"),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:15,left: 50,right: 50,bottom: 10),
                    child: Text(
                      'МОНГОЛ УЛСЫН ҮНДСЭН ХУУЛЬ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:20,bottom: 10),
                    child: Image.asset("assets/images/hee_home.png"),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.5,
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
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
      )
    );
  }
}
