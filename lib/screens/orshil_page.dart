import 'package:flutter/material.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/utils/colorlaw.dart';

class OrshilPage extends StatefulWidget {
  final TermOnlyModel term;
  OrshilPage({this.term});
  _OrshilPageState createState() => _OrshilPageState();
}

class _OrshilPageState extends State<OrshilPage> {
  static const int PAGE_SIZE = 20;
  List<TermOnlyModel> terms = new List();

  @override
  void initState() {
    super.initState();

    // BackendService.getOrshilList("111", 0, 10).then((onValue) {
    //   if (onValue != null) {
    //     setState(() {
    //       terms = onValue;
    //     });
    //   }
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
          "Оршил".toUpperCase(),
          style:
              TextStyle(color: Color(0xff1b4392), fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        children: List.generate(widget.term.cntTerms.length, (index) {
          TermOnlyModel model = widget.term.cntTerms[index];
          return Center(
            child: Column(
              children: <Widget>[
                (index == 0)
                    ? Container(
                        height: 200,
                        padding: EdgeInsets.only(bottom: 15),
                        child: Image.asset("assets/images/logo_large.png"),
                      )
                    : Container(),
                Text(
                  model.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: ColorLaw.blue),
                ),
                SizedBox(height: 10)
              ],
            ),
          );
        }),
      ),
    );
  }
}
