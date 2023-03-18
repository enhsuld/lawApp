import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const int PAGE_SIZE = 10;

  var publishedTerms = <TermOnlyModel>[];
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'isMenu';
    final value = prefs.getBool(key) ?? false;
    print('read: $value');
    // if (value) {
    //   print("offline");
    //   BackendService.getTermOffline(0 + 1, PAGE_SIZE).then((terms) {
    //     setState(() {
    //       this.publishedTerms = terms;
    //       print(terms);
    //     });
    //   });
    // } else {
    //   print("online");
    //   BackendService.getTerm(0 + 1, PAGE_SIZE).then((terms) {
    //     setState(() {
    //       this.publishedTerms = terms;
    //       print(terms);
    //     });
    //   });
    // }
    BackendService.getTerm(0 + 1, PAGE_SIZE).then((terms) {
      setState(() {
        this.publishedTerms = terms;
        print(terms);
      });
    });
  }

  void _verifyVersion() async {
    try {
      await AppVersionUpdate.checkForUpdates(
              appleId: '1507881332',
              playStoreId: 'mn.law.constitution',
              country: 'mn')
          .then((data) async {
        print(data);
        if (data.canUpdate!) {
          // await AppVersionUpdate.showBottomSheetUpdate(context: context, appVersionResult: appVersionResult)
          // await AppVersionUpdate.showPageUpdate(context: context, appVersionResult: appVersionResult)
          await AppVersionUpdate.showAlertUpdate(
            appVersionResult: data,
            context: context,
            backgroundColor: Colors.grey[200],
            title: 'Мэдэгдэл',
            content: 'Шинэ хувилбар гарсан байна. Шинэчлэнэ үү',
            updateButtonText: 'Татах',
            cancelButtonText: 'Үгүй',
            titleTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 24.0),
            contentTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          );
        }
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _read();
    _verifyVersion();
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
              //Text('Connection Status: $_connectionStatus'),
              Container(
                height: 220,
                padding:
                    EdgeInsets.only(top: 80, left: 50, right: 50, bottom: 10),
                child: Image.asset("assets/images/logo_large.png"),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 10, left: 8, right: 8),
                child: Text(
                  'МОНГОЛ УЛСЫН ҮНДСЭН ХУУЛЬ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.0,
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
              SizedBox(
                height: 10,
              ),
              Expanded(
                // color: Colors.black,
                // height: MediaQuery.of(context).size.height * 0.5,
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: ListView.builder(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
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
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
